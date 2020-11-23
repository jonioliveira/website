# tf-web-from-bucket

## Components

The terraform script contains 2 modules:

-   `terraform/*.tf`: The root module that contains the scripts to deploy website in a bucket
-   `terraform/modules/setup-remote-state/*.tf`: A module to setup the GCP Storage bucket used as the remote state backend of the root module.

## Development Requirements

You will need to have installed the following:

-   [Docker](https://www.docker.com/products/docker-desktop) (>= 18.09.2).
-   [Docker Compose](https://docs.docker.com/compose/install/) (>= 1.23.2).

Note: The project was created with this specific versions but older versions might also work.

## Getting started

To get the list of available commands run:

```sh
make help
```

To fully build or update the infrastructure run:

```sh
make apply
```

## Contributing

The `develop` branch is where the source code of HEAD always reflects a state with the latest delivered development changes for the next release.

A new feature should be developed in a branch whose name follows the pattern: `feature/<ISSUE-CODE>-<SHORT-DESCRIPTION>`, example: `feature/1057-add-user-groups`.

A bug fix should be developed in a branch whose name follows the pattern: `fix/<ISSUE-CODE>-<SHORT-DESCRIPTION>`, example: `fix/1057-fix-user-roles`.

If no issue exist, the `<ISSUE-CODE>-` part of the branch name can be ignored.

When a new feature or bug fix is completed, a new PR (Pull Request) into the `develop` branch should be created so the changes can be reviewed.

The PR title should start with the issue number, for example `1057: Add user groups` if a issue exists.

All PRs should have one of the following labels:

-   feature
-   bugfix

All PRs should have the requester as assignee.

Also if a PR is still a WIP (Work In Progress) it should be marked with the `WIP` label and it should be ignored by the reviewers. This means the PR still has pending changes.

The label `RFC` (Request For Comments) should be added to any PR that it is ready to be reviewed.

The PR reviewer(s) should delegate the merge (when the PR is approved) to the original commiter.

## CI

Every pushed commit will be tested in Circle CI.
The test consists in checking the correctness of the terraform scripts.

Every commit merged into the `develop` branch will also be tested.
After the test `terraform plan` will also be executed so the changes to the state can be reviewed.
In order for the `terraform plan` step to run an administrator must approve it's execution in Circle CI so the `terraform plan` step can gain access to the AWS credentials.

## CD & Releases

Every new git tag with the semver pattern ("v1.0.0" for example) will trigger the CD pipeline in Circle CI.
The CD pipeline requires an administrator approval, after it will run `terraform plan`, followed by another approval step so the plan can be reviewed, the final step will apply the changes if approved.
