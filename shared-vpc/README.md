# Shared VPC

## Description

TO - DO

## Deploy

1. Open Cloud Shell and clone this repo.
2. Make sure GOOGLE_CLOUD_PROJECT env var is set:
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state. 
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs and give Cloud Build's SA permissions in case it's the first time you use it.
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com cloudbilling.googleapis.com
```

5. Navigate to `terraform_gcp/shared_vpc`, then set the env vars and execute Terraform.
```
export TF_VAR_org_id=<ORG_ID>
export TF_VAR_billing_account_id=<BILLING_ACCOUNT_ID>
sh run_terraform.sh
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
