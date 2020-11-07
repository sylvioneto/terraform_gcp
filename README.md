# Terraform modules and examples for Google Cloud Platform

## Description
Terraform modules to use on Google Cloud Platform - GCP  
All modules are set to use free tier by default in order to help to explore GCP without costs.  
However, Google might change free-tier eligibility so please double check https://cloud.google.com/free/docs/gcp-free-tier

## Pre-req
- terraform 0.12.25 or later
- google provider 3.12 or later

## Modules
- [core](./modules/core): It creates core resources that are useful in any GCP project.
- [mig](./modules/mig): It creates a regional Managed Instance Group in a given subnet. It includes Logging and Monitoring agents, and Autoscaling.
- [gke](./modules/gke): It creates a Google Kubernetes Engine with subnet and service account.
