# Stratozone

This example create an environment to demonstrate how to execute an assessment with Stratozone.

Resources created:
- app-server-001 (Windows)
- db-server-001 (Linux)
- stratozone-collector (Windows)

## Steps

### Create resources
```
$ terraform init
$ terraform plan -out gce.tfplan 
$ terraform apply gce.tfplan
```

### Set Passwords

```
gcloud compute reset-windows-password app-server-001 --user admin --zone us-central1-a
gcloud compute reset-windows-password stratozone-collector --user admin --zone us-central1-a
```
