# Data Fusion

## Description

This project demonstrates how to create a Data Fusion environment to execute No Code data pipeline.

## Deploy

1. Clone this repo into the Cloud Shell or your local machine.
2. Set env vars for your project id and number
```
export GCP_PROJECT_ID="<project-id>"
export GCP_PROJECT_NUMBER="<project-number>"
```

3. Create a bucket to store your project's Terraform state. 
```
gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

4. Enable the necessary APIs.
```
gcloud services enable cloudbuild.googleapis.com \
    compute.googleapis.com \
    container.googleapis.com \
    cloudresourcemanager.googleapis.com \
    datafusion.googleapis.com
```

5. Give permissions to the service accounts.
```
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/iam.securityAdmin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/editor'
```

6. Execute Terraform using Cloud Build.
```
gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
