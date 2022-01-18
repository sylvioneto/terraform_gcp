# Cost Management

## Description
This example demonstrates how to use resource labels and Data Studio to monitor your GCP spending.
It creates an environment with VMs that have labels: team, cost-center, and env.
As a result, you can use the Data Studio to explore your GCP Billing data.

Pre-req:
- [Setup Billing Exporter](https://cloud.google.com/billing/docs/how-to/export-data-bigquery-setup)
- [Setup GCP Cost Summary dashboard](https://cloud.google.com/billing/docs/how-to/visualize-data)

## Deploy

1. Clone this repo into the Cloud Shell or your local machine.
2. Set env vars for your project id and number
```
$ export GCP_PROJECT_ID="<project-id>"
$ export GCP_PROJECT_NUMBER="<project-number>"
```

3. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

4. Enable Compute and Cloud Build API in case it is the first time you use it.
```
$ gcloud services enable cloudbuild.googleapis.com compute.googleapis.com
```

5. Give Cloud Build's service account necessary permissions
```
$ gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
```

6. Deploy Terraform using Cloud Build.
```
$ gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
