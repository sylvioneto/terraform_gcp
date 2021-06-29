# gke
This project demonstrates how to deploy a GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

It creates VPC, Subnet, NAT, DNS Zone, and GKE.

Also, it deploys useful applications to the GKE cluster created:
- Nginx Ingress controller
- External DNS

## Pre-req
- terraform >=0.14

## Deploy

1. Clone this repo
2. Update the Terraform state bucket in [main.tf](./terraform/main.tf) and [variables.tf](./terraform/variables.tf) according to your environment.
3. Run terraform to create Google Cloud resources.
```
$ cd terraform
$ terraform init
$ terraform plan -out gke.tfplan
$ terraform apply "gke.tfplan"
```
4. Update the kubernetes yaml files:
- external-dns.yaml: set domain and service accounts created in step 3.
- ingress-nginx: set the external-ip created in step 3.

5. Run Cloud Build to deploy applications to GKE.
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
