# Jenkins on GKE
This example demonstrates how to deploy Jenkins on a GKE cluster.

If you don't have a GKE cluster yet, please take a look at [gke](../gke).

## Pre-req
- [GKE](https://console.cloud.google.com/marketplace/product/google/container.googleapis.com?) and [Cloud Build](https://console.cloud.google.com/marketplace/product/google/cloudbuild.googleapis.com) APIs are enabled.
- GKE cluster up and running.
- Knowledge of Workload Identity

## How to deploy

1. Go to your project, and Activate the Cloud Shell terminal.
2. Make sure the right project is set. Otherwise, set the project where you'll deploy Jenkins.
```ssh
gcloud config list
```
3. Create a GSA for Jenkins and allow the KSA to act as it.
```ssh
gcloud iam service-accounts create jenkins --description "Jenkins Service Account" --display-name jenkins

gcloud iam service-accounts add-iam-policy-binding jenkins@<YOUR_PROJECT_ID>.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:<YOUR_PROJECT_ID>.svc.id.goog[jenkins/jenkins]"
```
4. Update the jenkins.yaml replacing the placeholders.
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
