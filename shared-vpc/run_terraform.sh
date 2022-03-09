#!bin/sh

terraform init -backend-config="bucket=$GOOGLE_CLOUD_PROJECT-tf-state" -backend-config="prefix=terraform_gcp/shared_vpc"

terraform plan -out shared_vpc.tfplan

terraform apply shared_vpc.tfplan
