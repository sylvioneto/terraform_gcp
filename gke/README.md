# GKE - Google Kubernetes Engine

## Description

This project demonstrates how to create a Private GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

In this example, all nodes have private ips and the cluster's masters are private.

Resources created:
- VPC
- Subnet
- NAT
- GKE

## Deploy

1. Clone this repo into the Cloud Shell or your local machine.
2. Set env vars for your project id and number
```
export GCP_PROJECT_ID=<project-id>
export GCP_PROJECT_NUMBER=<project-number>
```

3. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

4. Enable the necessary APIs and give Cloud Build's SA permissions in case it's the first time you use it.
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/iam.securityAdmin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/container.admin'
```

5. Execute Terraform using Cloud Build.
```
$ gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
