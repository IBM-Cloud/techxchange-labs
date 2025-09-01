# Terraform IBM Cloud Code Engine Serverless Setup for Loan Risk AI Agents sample application

This Terraform configuration deploys an IBM Cloud Code Engine serverless project, container registry, and associated resources for the AI Agent for Loan Risk application. It automates provisioning of the following components:

- IBM Cloud Resource Group
- Code Engine Project 
- Code Engine Secret 
- IBM Container Registry Namespace
- Code Engine Build (Docker image build from GitHub source)
- Code Engine Application (serverless container deployment with environment variables)

## Reference Architecture

![loan-risk-code-engine](./reference-architecture/ce-app-da.svg)

## Usage

1. Clone the repository containing this Terraform configuration.

1. Configure your variables in a terraform.tfvars file or via environment variables:
    - ibmcloud_api_key - Your IBM Cloud API key
    - watsonx_project_id - watsonx.ai project ID

1. Initialize Terraform modules and providers:
```bash
terraform init
```

1. Plan the deployment to review changes:
```bash
terraform plan
```

1. Apply the configuration to deploy resources:
```bash
terraform apply
```
