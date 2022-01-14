# Data Fusion

## Description

This project demonstrates how to create a Data Fusion to execute No Code data pipelines.

## Deploy

1. Set env vars for your project id and number
```
export GCP_PROJECT_ID="<project-id>"
export GCP_PROJECT_NUMBER="<project-number>"
```

2. Create a bucket to store your project's Terraform state. 
```
gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

3. Enable the necessary APIs and give Cloud Build's SA permissions in case it's the first time you use it.
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com datafusion.googleapis.com
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/iam.securityAdmin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/compute.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/datafusion.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/dataproc.admin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/dataproc.worker'
```

4. Execute Terraform using Cloud Build.
```
gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
