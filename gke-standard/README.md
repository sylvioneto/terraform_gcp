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

1. Create a new project and select it
2. Open Cloud Shell and clone this repo into the Cloud Shell VM
```
git clone https://github.com/sylvioneto/terraform_gcp.git
```
3. Ensure the var is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

4. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

5. Enable the necessary APIs
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com
```

6. Go to [IAM](https://console.cloud.google.com/iam-admin/iam) and add `Editor` and `Security Admin` role to the Cloud Build's service account `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`.

7. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/gke
gcloud builds submit ./terraform --config cloudbuild.yaml --project $GOOGLE_CLOUD_PROJECT
```

## Destroy
1. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/gke
gcloud builds submit . --config cloudbuild_destroy.yaml
```
