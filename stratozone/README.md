# Stratozone

This example creates an environment to demonstrate how to execute an assessment with Stratozone.

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

### Stratozone user/password
Create a user/pass common for Linux and Windows machines. Stratozone will use this credential to access the other machines.

E.g stratozone/W&lcome@2021

#### Windows

Create the user, then change the password.
```
$ gcloud compute reset-windows-password app-server-001 --user stratozone --zone us-central1-a
$ gcloud compute reset-windows-password stratozone-collector --user stratozone --zone us-central1-a
```

#### Linux
Connect to the machine using the `gcloud compute ssh` command or the console, then create the user
```
$ sudo adduser stratozone 
```
