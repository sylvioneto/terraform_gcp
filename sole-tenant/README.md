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

1. Clone this repo into the Cloud Shell or your local machine.
2. Set env vars for your project id and number
```
export GCP_PROJECT_ID=<project-id>
export GCP_PROJECT_NUMBER=<project-number>
```

3. Create a bucket to store your project's Terraform state. 
```
$ gsutil mb gs://$GCP_PROJECT_ID-tf-state
```

4. Enable the necessary APIs and give Cloud Build's SA permission in case it's the first time you use it.
```
$ gcloud services enable cloudbuild.googleapis.com compute.googleapis.com
$ gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member="serviceAccount:$GCP_PROJECT_NUMBER@cloudbuild.gserviceaccount.com" --role='roles/editor'
```

5. Execute Terraform using Cloud Build.
```
$ gcloud builds submit . --config cloudbuild.yaml --project $GCP_PROJECT_ID
```

## Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.
