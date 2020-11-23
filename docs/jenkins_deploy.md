# Jenkins Deploy

How to deploy a gatsby website to gcp using jenkins

-   Create a bucket
-   Load Balance para http/https
-   Add CDN to Load Balancer
-   Use:
-   gsutil web set -m index.html -e 404.html gs://www.example.com
-   Use the gsutil web set command to set the MainPageSuffix property with the -m flag and the NotFoundPage with the -e flag:
