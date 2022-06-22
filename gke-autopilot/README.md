# GKE - Google Kubernetes Engine

## Description

This project demonstrates how to create a GKE Autopilot cluster.
Resources created:
- VPC
- Subnet
- NAT
- GKE

## Deploy

1. Create a new project and select it.

2. Open Cloud Shell and ensure the var below is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

3. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

4. Enable the necessary APIs
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com container.googleapis.com cloudresourcemanager.googleapis.com containersecurity.googleapis.com
```

5. Go to [IAM](https://console.cloud.google.com/iam-admin/iam) and add `Editor`.

6. Clone this repo into the Cloud Shell VM
```
git clone https://github.com/sylvioneto/terraform_gcp.git
cd ./terraform_gcp/gke
```

7. Find and replace `your-domain.com` by your own domain.

8. Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild.yaml
```

9. At this point your cluster and workloads ar up and running, please check it on [GKE](https://console.cloud.google.com/kubernetes/list/overview).

10. (Optional) In other to have the tls certificate, add the Ingresses IPs to your DNS records, so that GKE will provision the certificate. ([reference](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs))

## Destroy
1. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/gke
gcloud builds submit . --config cloudbuild_destroy.yaml
```
