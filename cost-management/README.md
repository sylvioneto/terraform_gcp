# Cost Management

This example demonstrates how to use resource labels and Data Studio to monitor your GCP spending.
It creates an environment with VMs that have labels: team, cost-center, and env.
As a result, you can use the Data Studio to explore your GCP Billing data.

Pre-req:
- [Setup Billing Exporter](https://cloud.google.com/billing/docs/how-to/export-data-bigquery-setup)
- [Setup GCP Cost Summary dashboard](https://cloud.google.com/billing/docs/how-to/visualize-data)

## Deploy

1. Set an env var for your project id.
```
$ export GCP_PROJECT_ID="<project-id>"
```

2. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

3. Execute Terraform using Cloud Build.
```
$ gcloud build submit . \
    
```