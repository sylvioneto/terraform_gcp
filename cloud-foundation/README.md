# GCP - Cloud Foundation

## Description

This project demonstrates how to create a foundation for your GCP project so that you can start building your systems following the best practices.

Resources created:
- VPC
- Firewall rules
- Subnets
- NAT
- Docker repository


## Deploy

1. Create a new project and select it.

2. Open Cloud Shell and ensure the var below is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs
```
gcloud services enable cloudbuild.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
cloudresourcemanager.googleapis.com \
containersecurity.googleapis.com \
datamigration.googleapis.com \
servicenetworking.googleapis.com \
artifactregistry.googleapis.com \
sqladmin.googleapis.com \
vpcaccess.googleapis.com
```

5. Go to [IAM](https://console.cloud.google.com/iam-admin/iam) and add `Editor`, `Compute Networking Admin`, and `Security Admin` role to the Cloud Build's service account `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`.

6. Clone this repo into the Cloud Shell VM
```
git clone https://github.com/sylvioneto/terraform_gcp.git
cd ./terraform_gcp/cloud-foundation
```

7. Execute Terraform using Cloud Build
```
gcloud builds submit ./terraform --config cloudbuild.yaml
```

8. (Optional) Customize [terraform.tfvars](./terraform/terraform.tfvars) according to your needs.

## Destroy
1. Execute Terraform using Cloud Build
```
gcloud builds submit ./terraform --config cloudbuild_destroy.yaml
```
