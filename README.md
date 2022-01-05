# Terraform modules and examples for Google Cloud Platform

## Description
Terraform examples for Google Cloud Platform - GCP  
All modules are set to use free tier as much as possible in order to help you to explore GCP without costs.  
Just in case, always check the free-tier eligibility: https://cloud.google.com/free/docs/gcp-free-tier

## Pre-req
- terraform 1.0 or later
- google provider 3.12 or later

## Example
- [cost-management](./cost-management): Monitor your costs with BigQuery, Data Studio and Labels.
- [gke](./gke): How to GKE cluster with Nginx ready to receive deployments.
- [stratozone](./stratozone): Test environment to demonstrate Stratozone Assessment.
- [sole-tenant](./sole-tenant): Use sole-tenant VMs to bring you [Microsoft Licenses](https://cloud.google.com/compute/docs/instances/windows/ms-licensing#byol) to GCP.
