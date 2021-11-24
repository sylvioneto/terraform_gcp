# Jenkins on GKE
This example demonstrates how to deploy Jenkins on a GKE cluster.

If you don't have a GKE cluster yet, please take a look at [gke](../gke).

## Pre-req
- [GKE](https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?) and [Cloud Build](https://console.cloud.google.com/marketplace/product/google/cloudbuild.googleapis.com) APIs are enabled.
- GKE cluster up and running.

## How to deploy

1. Go to your project, and Activate the Cloud Shell terminal.
2. Make sure the right project is set. Otherwise, set the project where you'll deploy Jenkins.
```ssh
gcloud config list
```
3. Create a service account for Jenkins.
```ssh
gcloud iam service-accounts create jenkins --description "Jenkins Service Account" --display-name jenkins
```
4. Update the jenkins.yaml with the SA's name, domain name.

5. Update cloudbuild.yaml according to your cluster's details and run it.
```ssh
gcloud builds submit . --config cloudbuild.yaml
```



## Uninstall
Run the commands below.
```
$ cd terraform
$ terraform init
$ terraform destroy
```
