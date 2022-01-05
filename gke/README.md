# gke

## Description

This project demonstrates how to create a Private GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

In this example, all nodes have private ips and the cluster's masters are private.

Resources created:
- VPC
- Subnet
- NAT
- GKE

## Deploy

1. Set env vars for your project id and number
```
$ export GCP_PROJECT_ID="<project-id>"
$ export GCP_PROJECT_NUMBER="<project-number>"
```

2. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

3. Enable the necessary APIs and give Cloud Build's SA permission in case it's the first time you use it.
```
$ gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com
$ gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
```

4. Execute Terraform using Cloud Build.
```
$ gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

5. (optional) Destroy all resources.
```
$ gcloud builds submit . --config cloudbuild_destroy.yaml --project $GCP_PROJECT_ID
```
