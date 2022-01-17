# Cloud Composer

## Description

This project demonstrates how to create a Cloud Composer environment to execute data pipelines.

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

3. Enable the necessary APIs.
```
gcloud services enable cloudbuild.googleapis.com \
    cloudresourcemanager.googleapis.com \
    compute.googleapis.com \
    container.googleapis.com \
    dataflow.googleapis.com
```

4. Give permissions to the service accounts.
```
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/iam.securityAdmin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/editor'
```


5. Execute Terraform using Cloud Build.
```
gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

6. Deploy the pipeline
```
python3 order_ingest.py \
    --runner=DataflowRunner \
    --project=syl-dataflow-demo \
    --region=us-east1 \
    --subnetwork=data-engineering
```


## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
