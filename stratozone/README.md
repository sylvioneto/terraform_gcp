# Stratozone

This example creates an environment to demonstrate how to execute an assessment with Stratozone.

Resources created:
- app-server-001 (Windows)
- db-server-001 (Linux)
- stratozone-collector (Windows)

## Resources

### Deploy

1. Create or select an existing project
2. Open Cloud Shell and clone this repo into the Cloud Shell VM
```
git clone https://github.com/sylvioneto/terraform_gcp.git
```
3. Ensure the var is set, otherwise set it with `gcloud config set project` command
```
echo $GOOGLE_CLOUD_PROJECT
```

4. Create a bucket to store your project's Terraform state
```
gsutil mb gs://$GOOGLE_CLOUD_PROJECT-tf-state
```

5. Enable necessary APIs
```
gcloud services enable cloudbuild.googleapis.com compute.googleapis.com
```

6. Execute Terraform using Cloud Build.
```
gcloud builds submit . --config cloudbuild.yaml
```

### Destroy
Uncomment the `tf destroy` step in the cloudbuild.yaml file, and trigger the deployment again.


## Stratozone

### Stratozone user/password
Create a user/pass common for Linux and Windows machines. Stratozone will use this credential to access the other machines.

E.g stratozone/Welcome@2021

### Windows

Create the user, then change the password.
```
$ gcloud compute reset-windows-password app-server-001 --user stratozone --zone southamerica-east1-a
$ gcloud compute reset-windows-password stratozone-collector --user stratozone --zone southamerica-east1-a
```

### Linux
Connect to the machine using the `gcloud compute ssh` command or the console, then create the user
```
$ sudo adduser stratozone 
```

### Install Strato-Probe

Connect to the stratozone-collector vm, install and activate the Strato Probe.
Once it's done, you can monitor the collected metrics in the Stratozone Portal.


### Known Issues
#### Linux Target - No authentication methods (server sent: publickey) when trying to access Linux machines.  
There are 2 options for this case.
  1) use a key file instead of user/passo
  2) Edit the /etc/ssh/sshd_config, change `PasswordAuthentication` to `yes`, and restart the service `sudo service ssh restart`.

#### Windows Target - The RPC server is unavailable.  
The Windows firewall in the target machine might be blocking Stratozone collector to reach the target. Turn off the firewall or whitelist the Stratozone collector.

#### Windows Target - Access denied with right user/pass.
It might happen when machines are not in the same domain, or the stratozone user is local. Add a `.\`before the user to indicate is a local login.
