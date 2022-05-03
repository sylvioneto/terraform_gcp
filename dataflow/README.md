# Data Pipeline

## Description

This project demonstrates how to create a data pipeline with Dataflow and GCS.

## Deploy

### Terraform

1. Create or select an existing project
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

5. Enable the necessary APIs.
```
gcloud services enable cloudbuild.googleapis.com \
    cloudresourcemanager.googleapis.com \
    compute.googleapis.com \
    container.googleapis.com \
    dataflow.googleapis.com \
    datacatalog.googleapis.com \
    dlp.googleapis.com
```


6. Go to [IAM](https://console.cloud.google.com/iam-admin/iam) and add `Editor` and `Project IAM Admin` role to the Cloud Build's service account `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`.

7. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/dataflow
gcloud builds submit ./terraform --config cloudbuild.yaml --project $GOOGLE_CLOUD_PROJECT
```

### Dataflow job
1. Copy the input file to the raw data bucket.
```
gsutil cp ./data/order_ingest.csv gs://$GOOGLE_CLOUD_PROJECT-data-raw/
```

2. Prepare the environment.
```
pip3 install virtualenv
python3 -m virtualenv venv
source venv/bin/activate
pip3 install apache-beam[gcp]
```

3. Run the job.

    3.1 On Dataflow
    Run:
    ```
    python3 ./job/order_ingest.py \
        --project=$GOOGLE_CLOUD_PROJECT \
        --region=us-east1 \
        --runner=DataflowRunner \
        --job_name=order-ingest \
        --save_main_session \
        --temp_location=gs://$GOOGLE_CLOUD_PROJECT-dataflow-temp/ \
        --subnetwork=regions/us-east1/subnetworks/data-engineering \
        --gcs_raw=$GOOGLE_CLOUD_PROJECT-data-raw \
        --gcs_lake=$GOOGLE_CLOUD_PROJECT-data-lake \
        --gcs_dw=$GOOGLE_CLOUD_PROJECT-data-warehouse
    ```
    Check the job on https://console.cloud.google.com/dataflow/jobs

    3.2 Local (for troubleshooting)
    ```
    python3 ./job/order_ingest.py \
        --project=$GOOGLE_CLOUD_PROJECT \
        --region=us-east1 \
        --runner=DirectRunner \
        --job_name=order-ingest \
        --temp_location=gs://$$GOOGLE_CLOUD_PROJECT-data-raw/temp/ \
        --gcs_raw=$GCP_PROJECT_ID-data-raw \
        --gcs_lake=$GCP_PROJECT_ID-data-lake \
        --gcs_dw=$GCP_PROJECT_ID-data-dw
    ```
4. (optional) Grant Storage Admin and Bigquery Admin to `service-<project-number>@dataflow-service-producer-prod.iam.gserviceaccount.com`service account in case it is the first time you use Dataflow.


## Destroy
1. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/dataflow
gcloud builds submit ./terraform --config cloudbuild_destroy.yaml
```
