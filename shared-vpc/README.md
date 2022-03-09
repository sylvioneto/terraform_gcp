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

5. Navigate to `terraform_gcp/shared_vpc`, then execute Terraform using Cloud Build with the proper substitutions or shell.

Set env vars
```
export ORG_ID=<ORG_ID>
export BILLING_ACCOUNT_ID=<BILLING_ACCOUNT_ID>
```

5.1 Option 1 - Shell


5.2 Option 2 - Cloud Build
```
gcloud builds submit . --config cloudbuild.yaml \
--project $GOOGLE_CLOUD_PROJECT \
--substitutions _ORG_ID=$ORG_ID,_BILLING_ACCOUNT_ID=$BILLING_ACCOUNT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
