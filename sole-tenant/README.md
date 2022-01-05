# Windows Sole-Tenant

## Description
This example creates an environment to demonstrate how to use Sole Tenant nodes to host your Windows Servers VMs.

You can use this approach to lift and shift your VMs to Google Cloud using bringing your own licenses ([BYOL](https://cloud.google.com/compute/docs/nodes/bringing-your-own-licenses)).

Resources created:
- VPC and Subnet
- srv-app-001 (Application Server Windows)
- srv-app-002 (Application Server Windows)
- srv-db-001 (Database Server SQL Server)

## Deploy

1. Set env vars for your project id and number
```
$ export GCP_PROJECT_ID="<project-id>"
$ export GCP_PROJECT_NUMBER="<project-number>"
```

2. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

3. Enable the necessary APIs and give Cloud Build's SA permission in case it's the first time you use it.
```
$ gcloud services enable cloudbuild.googleapis.com compute.googleapis.com
$ gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
```

4. Execute Terraform using Cloud Build.
```
$ gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

5. (optional) Destroy all resources.
```
$ gcloud builds submit . --config cloudbuild_destroy.yaml --project $GCP_PROJECT_ID
```
