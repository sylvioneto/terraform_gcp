# GKE - Google Kubernetes Engine

## Description

This project demonstrates how to create a Private GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

In this example, all nodes have private ips and the cluster's masters are private.

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
gcloud services enable cloudbuild.googleapis.com \
compute.googleapis.com \
container.googleapis.com \
cloudresourcemanager.googleapis.com \
containersecurity.googleapis.com
```

5. Go to [IAM](https://console.cloud.google.com/iam-admin/iam) and add `Editor` and `Security Admin` role to the Cloud Build's service account `<PROJECT_NUMBER>@cloudbuild.gserviceaccount.com`.

6. Clone this repo into the Cloud Shell VM
```
git clone https://github.com/sylvioneto/terraform_gcp.git
cd ./terraform_gcp/gke-standard
```

7. Find and replace `your-domain.com` by your own domain.

8. Execute Terraform using Cloud Build
```
gcloud builds submit . --config cloudbuild.yaml
```

9. At this point your cluster and workloads ar up and running, please check it on [GKE](https://console.cloud.google.com/kubernetes/list/overview).

10. (Optional) Add the ingress-nginx IP to your DNS records in order to access the applications.  
In case you use Cloud DNS, you can set the env vars below according to your settings:
```
ZONE_NAME=your-public-zone-name
NGINX_IP=your-nginx-ip
DOMAIN=your-domain.com.
```
And run the command below on Cloud Shell terminal.
```
gcloud dns record-sets create jenkins.$DOMAIN      --rrdatas=$NGINX_IP --type=A --ttl=300 --zone=$ZONE_NAME
gcloud dns record-sets create prometheus.$DOMAIN   --rrdatas=$NGINX_IP --type=A --ttl=300 --zone=$ZONE_NAME
gcloud dns record-sets create grafana.$DOMAIN      --rrdatas=$NGINX_IP --type=A --ttl=300 --zone=$ZONE_NAME
gcloud dns record-sets create alertmanager.$DOMAIN --rrdatas=$NGINX_IP --type=A --ttl=300 --zone=$ZONE_NAME
```

## Destroy
1. Execute Terraform using Cloud Build
```
cd ./terraform_gcp/gke
gcloud builds submit . --config cloudbuild_destroy.yaml
```
