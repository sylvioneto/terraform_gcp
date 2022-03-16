# Shared VPC

## Description

This project demonstrate how to use Shared-VPC and Google Cloud terraform modules.

Resources created:
- Network project (Host project) with the subnets below:
    - dev
    - qa
    - prod

- Dev project (Service project)
- QA project (Service project)
- Prod project (Service project)



## Deploy

1. Open Cloud Shell and clone this repo.
2. Make sure GOOGLE_CLOUD_PROJECT env var is set:
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your the Terraform state. 
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs and give Cloud Build's SA permissions in case it's the first time you use it.
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com
```

5. Navigate to `terraform_gcp/shared_vpc`, then set the env vars and execute Terraform.
```
export TF_VAR_org_id=<ORG_ID>
export TF_VAR_billing_account_id=<BILLING_ACCOUNT_ID>
sh run_terraform.sh
```

## Destroy
```
export TF_VAR_org_id=<ORG_ID>
export TF_VAR_billing_account_id=<BILLING_ACCOUNT_ID>
terraform destroy
```
