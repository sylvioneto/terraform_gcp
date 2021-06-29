# gke
This project demonstrates how to deploy a GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

It creates VPC, Subnet, NAT, DNS Zone, and GKE.

Also, it deploys useful applications to the GKE cluster created:
- Nginx Ingress controller
- External DNS
- cert-manager
- Prometheus

## Pre-req
- terraform >=0.14
- helm >=3.4.0

## Deploy

1. Clone this repo
2. Find and replace:
- `<SET-PROJECT-ID>`: GCP Project ID
- `<SET-DNS-NAME>`: DNS name

3. Update the Terraform state bucket in [main.tf](./terraform/main.tf)

4. Run terraform to create Google Cloud resources.
```
$ cd terraform
$ terraform init
$ terraform plan -out gke.tfplan
$ terraform apply "gke.tfplan"
```

5. Set the NGINX_IP env var.
```
$ export NGINX_IP=$(gcloud compute addresses describe my-dev-cluster-ingress-nginx --region us-central1 --format="value(address)")
```

6. Run Cloud Build to deploy applications to GKE.
```
$ gcloud builds submit . \
--config kubernetes.yaml \
--substitutions _NGINX_IP=$NGINX_IP
```

## Uninstall
Run the commands below.
```
$ cd terraform
$ terraform init
$ terraform destroy
```
