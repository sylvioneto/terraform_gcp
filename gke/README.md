# gke
This project demonstrates how to deploy a GKE cluster using [Google CFT](https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/blob/master/docs/terraform.md) modules.

It creates VPC, Subnet, NAT, DNS Zone, and GKE.

Also, it deploys useful applications to the GKE cluster created:
- Nginx Ingress controller
- External DNS

## Pre-req
- terraform >=0.14

## Deploy

1. Enable Cloud Build on your project.
2. Clone this repo
3. Find and replace:
- `<YOUR-PROJECT-ID>`
- <`YOUR-DNS-NAME>`

4. Run terraform to create Google Cloud resources.
```
$ cd terraform
$ terraform init
$ terraform plan -out gke.tfplan
$ terraform apply "gke.tfplan"
```
5. Update the kubernetes yaml files:
- external-dns.yaml: set domain and service accounts created in step 3.
- ingress-nginx: set the external-ip created in step 3.

6. Run Cloud Build to deploy applications to GKE. 
Note: Update the project name.
```
$ gcloud builds submit . --config kubernetes.yaml
```

## Uninstall
Run the commands below.
```
$ cd terraform
$ terraform init
$ terraform destroy
```
