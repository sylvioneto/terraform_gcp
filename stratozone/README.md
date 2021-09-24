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

E.g stratozone/Welcome@2021

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

### Install Strato-Probe

Connect to the stratozone-collector vm, install and activate the Strato Probe.
Once it's done, you can monitor the collected metrics in the Stratozone Portal.


## Known Issues
Problem: Linux Target - No authentication methods (server sent: publickey) when trying to access Linux machines.  
Solutions: There are 2 options for this case.
  1) use a key file instead of user/passo
  2) Edit the /etc/ssh/sshd_config, change `PasswordAuthentication` to `yes`, and restart the service `sudo service ssh restart`.

Problem: Windows Target - The RPC server is unavailable.  
Solution: The Windows firewall is blocking Stratozone collector to reach the target. Turn off the firewall or whitelist the Stratozone collector.

Problem: Windows Target - Access denied with right user/pass.
Solution: It might happen when machines are not in the same domain or the stratozone user is local. Add a `.\`before the user to indicate is a local login.

