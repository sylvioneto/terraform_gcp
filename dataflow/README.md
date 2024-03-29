# Data Pipeline

## Description

This project demonstrates how to create a data pipeline with Dataflow, GCS and BigQuery.

This pipeline gets data from a raw bucket, process and save it into the Data Lake and Data Warehouse.

![image](printscreen.png)

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
gcloud builds submit . --config cloudbuild.yaml --project $GOOGLE_CLOUD_PROJECT
```

### Dataflow job

1. Prepare the environment.
```
pip3 install virtualenv
python3 -m virtualenv venv
source venv/bin/activate
pip3 install apache-beam[gcp]
```

2. (optional) Grant `roles/dataflow.worker`, `roles/storage.admin`, `roles/bigquery.admin` to `<project-number>-compute@developer.gserviceaccount.com` in case it's the first time you use Dataflow.

3. Run the job.

    3.1 On Dataflow
    Run:
    ```
    python3 ./job/order_ingest.py \
        --project=$GOOGLE_CLOUD_PROJECT \
        --region=southamerica-east1 \
        --runner=DataflowRunner \
        --job_name=order-ingest \
        --save_main_session \
        --temp_location=gs://$GOOGLE_CLOUD_PROJECT-dataflow-temp/ \
        --subnetwork=regions/southamerica-east1/subnetworks/dataflow \
        --gcs_raw=$GOOGLE_CLOUD_PROJECT-data-raw \
        --gcs_lake=$GOOGLE_CLOUD_PROJECT-data-lake \
        --gcs_dw=$GOOGLE_CLOUD_PROJECT-data-warehouse
    ```
    Check the job on https://console.cloud.google.com/dataflow/jobs

    3.2 Local (for troubleshooting)
    ```
    python3 ./job/order_ingest.py \
        --project=$GOOGLE_CLOUD_PROJECT \
        --region=southamerica-east1 \
        --runner=DirectRunner \
        --job_name=order-ingest \
        --temp_location=gs://$GOOGLE_CLOUD_PROJECT-dataflow-temp/ \
        --gcs_raw=$GOOGLE_CLOUD_PROJECT-data-raw \
        --gcs_lake=$GOOGLE_CLOUD_PROJECT-data-lake \
        --gcs_dw=$GOOGLE_CLOUD_PROJECT-data-warehouse
    ```

4. Check the job results:
    - Data in GCS Data Lake bucket
    - Data in GCE Data Warehouse bucket
    - BQ ecommerce.orders table


## Destroy
1. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/dataflow
gcloud builds submit . --config cloudbuild_destroy.yaml
```
