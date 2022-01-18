# Cloud Composer

## Description

This project demonstrates how to create a Cloud Composer environment to execute data pipelines.

## Deploy

### Terraform
1. Clone this repo.
2. Set env vars for your project id and number
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
    dataflow.googleapis.com \
    datacatalog.googleapis.com \
    dlp.googleapis.com
```

4. Give permissions to the service accounts.
```
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/iam.securityAdmin'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/editor'
```


5. Execute Terraform using Cloud Build.
```
gcloud builds submit ./terraform --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

### Dataflow job
1. Copy the input file to the raw data bucket.
```
gsutil cp ./data/order_ingest.csv gs://$GCP_PROJECT_ID-data-raw/
```

2. Prepare the environment.
Note: Change the project id in the order_ingest.py file before running it.

```
pip3 install virtualenv
python3 -m virtualenv venv
source venv/bin/activate
pip3 install apache-beam[gcp]
```

3. Run the job.

    3.1 On Dataflow
    ```
    python3 ./job/order_ingest.py \
        --project=$GCP_PROJECT_ID \
        --region=us-east1 \
        --runner=DataflowRunner \
        --job_name=order-ingest \
        --save_main_session \
        --temp_location=gs://$GCP_PROJECT_ID-data-raw/temp/ \
        --subnetwork=regions/us-east1/subnetworks/data-engineering \
        --gcs_raw=$GCP_PROJECT_ID-data-raw \
        --gcs_lake=$GCP_PROJECT_ID-data-lake \
        --gcs_dw=$GCP_PROJECT_ID-data-warehouse
    ```

    3.2 Local (for troubleshooting)
    ```
    python3 ./job/order_ingest.py \
        --project=$GCP_PROJECT_ID \
        --region=us-east1 \
        --runner=DirectRunner \
        --job_name=order-ingest \
        --temp_location=gs://$GCP_PROJECT_ID-data-raw/temp/ \
        --gcs_raw=$GCP_PROJECT_ID-data-raw \
        --gcs_lake=$GCP_PROJECT_ID-data-lake \
        --gcs_dw=$GCP_PROJECT_ID-data-dw
    ```

4. Clear data.
```
gsutil rm -r gs://$GCP_PROJECT_ID-data-lake/*
gsutil rm -r gs://$GCP_PROJECT_ID-data-warehouse/*
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
