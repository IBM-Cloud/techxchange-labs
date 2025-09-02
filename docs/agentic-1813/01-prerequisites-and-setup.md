# Prerequisites and Setup Requirements

## Technical Prerequisites

While this lab guides you step-by-step without assuming specific prior knowledge, participants will benefit from having:

- Basic knowledge of Terraform syntax and workflows
- Familiarity with containerization and Docker concepts
- Understanding of IBM Cloud services and navigation
- Basic experience with Git and GitHub workflows

> 💡 **Tip:** Don't worry if you're not an expert in these areas - the lab provides detailed instructions and explanations throughout.

## Lab Environment Architecture

### Instructor-Led Provisioning

Participants receive pre-configured IBM Cloud accounts with service quotas optimized for AI workloads, including:

- Administrator access to all IBM services used in this lab, including Code Engine, Log Analysis, and Monitoring services
- Cloud-based development machine with Visual Studio Code, IBM Cloud CLI, and Terraform CLI 1.5+ with IBM Cloud Provider plugin pre-configured

### Self-Paced Implementation

If you're working through this lab independently, ensure you have the following prerequisites before starting:

**IBM Cloud Account**: You need an IBM Cloud account with necessary permissions. Independent learners must have access to or create a Pay-As-You-Go account.

**Development Environment**: Set up your local development machine with the required tools:
  - **Terraform CLI** installed locally.  
    Verify your installation by running:

    ```bash
    terraform -version
    ```

    You should see output similar to:

    ```bash
    Terraform v1.x.x
    ```

    If Terraform is not installed, follow the [official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).

  - **IBM Cloud CLI** installed locally.  
    Verify your installation by running:

    ```bash
    ibmcloud -version
    ```

    You should see output similar to:

    ```bash
    ibmcloud version 2.x.x+...
    ```

    If the IBM Cloud CLI is not installed, follow the [official IBM Cloud CLI installation guide](https://cloud.ibm.com/docs/cli?topic=cli-install-ibmcloud-cli).

  - **Text Editor** such as Visual Studio Code installed locally for editing configuration files.

  - **Git client** installed and configured.  
    Verify your installation by running:

    ```bash
    git --version
    ```

    You should see output similar to:

    ```bash
    git version 2.x.x
    ```

    If Git is not installed, follow the [official Git installation guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).


