---
title: Sentry and Kubernetes
date: '2022-07-22'
tags: ['sentry', 'kube', 'cloud']
draft: false
summary: Take-aways from deploying Sentry in a k8s cluster
---

Based on my medium article: [Sentry and Kubernetes](https://medium.com/xgeeks/sentry-and-kubernetes-eabc507c96b7)

If you haven’t heard about Kubernetes yet, it’s a platform that allows you to run and orchestrate containers. Currently Kubernetes is about [six years old](https://en.wikipedia.org/wiki/Kubernetes), and over the last two years, it has risen in popularity.
At [xgeeks](https://xgeeks.io/) we are currently working on a client that is looking to create a platform based on Kubernetes. Using this platform they can deploy services on their own and have the ownership of the data generated, besides being able to have more or less computational power on those services.

With a large quantity of deployments we need a way to know and be notified of any errors occurred during runtime on our services. Being notified of this will allow us to iterate faster on bugs that happen in runtime.
Since we want to have our own software running on our platform we need to find a way to have a centralised error management on our cluster. Sentry is an Open-source error tracking application that helps developers to monitor errors in real time.

## Our Solution

Our solution will be to deploy a Sentry instance in our Kubernetes cluster using [Helm](https://helm.sh/) Charts. Although there are no official charts for Sentry, the community has created one that we will be using.

When deploying locally everything seems to go well, but when you try to deploy to the cluster, problems start to appear.

### Problems that we found

Here is our list of problems that we found and how we solved them.

1. **You should not use root images**

For security reasons our platform does not allow to have containers with root privileges by default. Here is an explanation from the Bitnami Engineering blog:

> "Changing the configuration of your containers to make them run as non-root adds an extra layer of security."

**How we solved it**

We created a new image based on the sentry one where we add the UID to the user:

```Dockerfile
#Dockerfile
FROM sentry:9.1.2
#Add User UID and Group UID
RUN usermod -u 3001 sentry
```

2. **Source maps don’t work**

The user created previously doesn’t belong to the sentry user group and doesn’t have permissions to write source maps in the right folder.

**How we solved it**

```Dockerfile
#Dockerfile
FROM sentry:9.1.2
#Add User UID and Group UID
RUN usermod -u 3001 sentry && groupmod -g 3001 sentry
```

3. ** Multiple pods accessing the same storage**

Sentry has 3 containers that need access to the same storage volume aka PVC:

- cron
- web
- worker

So the containers need **ReadWriteAccess**. Many of the k8s storage systems don’t support that kind of permission, so looking to the Sentry documentation we can see that we can change to an S3 or GCS(Google Cloud Storage) bucket. For this implementation we use GCS storage.

**How we solved it**

Create a bucket in GCS and update helm values to use the GCS bucket as storage.

```yaml
# Configure the location of Sentry artifacts
filestore:
  # Set to one of filesystem, gcs or s3 as supported by Sentry.
  backend: gcs
  ## Point this at a pre-configured secret containing a service account. The resulting
  ## secret will be mounted at /var/run/secrets/google
  gcs:
    credentialsFile:
    secretName: sentry-secret
    bucketName: sentry
```

In theory this should do it but when you try to deploy this you notice another problem.

3.1. **Sentry only compiles with minimum needed packages**

When we deploy with GCS credentials to a bucket we see an error of “failing to find packages”. _We can see in the documentation that sentry in version 9.1.2 and prior only compiles its source code with the minimum needed packages._
Since Sentry was created in python we need to create a requirements file to add the missing packages and rebuild the docker image.

```txt
#requirements.txt
google-cloud-storage>=1.13.2,<1.14
```

The new Dockerfile:

```Dockerfile
#Dockerfile
FROM sentry:9.1.2

#Add missing dependencies
COPY requirements.txt /usr/src/sentry/requirements.txt

#Install missing dependencies
RUN if [ -s /usr/src/sentry/requirements.txt ]; then pip install -r /usr/src/sentry/requirements.txt; fi

#Add User UID and Group UID
RUN usermod -u 3001 sentry && groupmod -g 3001 sentry
```

4. Generated passwords come with a cost

Sentry helm chart is configured to generate random passwords to administration, [PostgreSQL](https://www.postgresql.org/) and [Redis](https://redis.io/) if you don’t set them. The problem is that every time you have a new deployment a new password will be generated and the previous one will be deleted. We are using CI/CD to deploy sentry to our platform which causes us to lose the credentials and the ability to redeploy, or in our case, to run “helm upgrade”.

**How we solved it**

We have to clear the namespace and redeploy with the previously generated password.

```sh
helm upgrade ${RELEASE_NAME} sentry \
--install \
--namespace ${NAMESPACE} \
--wait \
-f ${VALUES_PATH} \
--set image.repository=${REGISTRY_REPO} \
--set image.tag=${TAG} \
--set user.password=${USER_PASSWORD} \
--set integrations.slack.clientId=${SLACK_CLIENT_ID} \
--set integrations.slack.clientSecret=${SLACK_CLIENT_SECRET} \
--set integrations.slack.verificationToken=${SLACK_VERIFICATION_TOKEN} \
--set gcs.credentialsFile=${CREDENTIALS_FILE} \
--set postgresql.postgresqlPassword=${POSTGRES_PASSWORD} \
--set redis.password=${REDIS_PASSWORD}
```

There is another solution that is to deploy once and on the redeploy set the secret that contains the passwords. We choose not to follow this approach because we are deploying different containers at each time and for us they should be unique and the process should be omnipotent.

```yaml
postgresql:
  enabled: true
  nameOverride: sentry-postgresql
  existingSecret: sentry-secret
  existingSecretKey: sentry-secret-postgresql-password
redis:
  enabled: true
  nameOverride: sentry-redis
  existingSecret: sentry-secret
  existingSecretKey: sentry-secret-redis-password
```

## Final thoughts

We have succeeded in the deployment of Sentry in our platform and it is a tool that we are using to actively reduce the bugs in our software. When we started the deployment of Sentry, the version that was available was 9.1.3, nowadays you have version 10 available. That version has a lot of new features and we plan to update to that version.
Once we do this will share another list of problems 😄.
I hope I shared a few solutions for your problems in case you are trying to deploy Sentry instance. Feel free to drop any comments! 🙂
If you find this article interesting, please share it, because you know — Sharing is caring!
