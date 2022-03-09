#!bin/sh

terraform init -backend-config="bucket=$GOOGLE_CLOUD_PROJECT-tf-state" -backend-config="prefix=terraform_gcp/shared_vpc"

terraform plan

terraform apply -auto-approve
