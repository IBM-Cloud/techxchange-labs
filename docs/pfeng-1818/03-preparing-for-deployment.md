# 🛠️ Preparing for Deployment

Before provisioning the infrastructure, you need to set up your environment to allow Terraform to communicate with your IBM Cloud account.

## Step 1: Set Up Your IBM Cloud API Key

Terraform requires an API key to authenticate with IBM Cloud.

1.  **Create an IBM Cloud API Key in the "Target Deployment Account".**:
    *   Open the incognito/private browser window where you've logged into your "Target Deployment Account".
    *   Navigate to **Manage > Access (IAM) > API keys**.
    *   Click **Create an IBM Cloud API key**.
    *   Give your key a descriptive name (e.g., `terraform-lab-key`) and click **Create**.
    *   **Important**: A window will pop up with your API key. Copy it immediately and save it. You will not be able to see it again.

2.  **Set the API Key as an Environment Variable**:
    Terraform can read credentials from environment variables. This is a secure way to provide credentials without hardcoding them in your configuration files.

    Open your terminal and run the following command, replacing `<YOUR-IBMCLOUD-API-KEY>` with the key you just created:

    ```bash
    export TF_VAR_ibmcloud_api_key="<YOUR-IBMCLOUD-API-KEY>"
    ```

    > **Note:** The `TF_VAR_` prefix is a special Terraform convention. It tells Terraform to automatically load this environment variable and assign its value to a Terraform variable named `ibmcloud_api_key`.

## Step 2: Define a Unique Prefix for Your Resources

To avoid naming conflicts with other resources in the account, we will use a unique prefix for everything we create.

1.  **Choose a Prefix**:
    A good prefix is something short and easily identifiable, like your initials followed by a short word (e.g., `vb-lab`). Keep in mind the maximum prefix length is 6 characters.

2.  **Set the Prefix as an Environment Variable**:
    Run the following command in your terminal, replacing `<YOUR-PREFIX>` with the prefix you chose:

    ```bash
    export TF_VAR_prefix="<YOUR-PREFIX>"
    ```

## Step 3: Review the Terraform Configuration

The `main.tf` file in the root of the project directory contains the core Terraform configuration. Let's briefly review the key sections that are now configured by the environment variables you just set.

> **Note**: For this tutorial, we’ll keep everything in a single `main.tf` file for simplicity, but in a real environment you would typically split the configuration into multiple files (e.g., `variables.tf`, `outputs.tf`) for better organization and maintainability.

```hcl
# main.tf

variable "ibmcloud_api_key" {
  description = "IBM Cloud API key for authentication and resource provisioning"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Unique prefix for resource naming (e.g., 'vb-lab' or 'ra-dev'). Maximum prefix length is 6 characters."
  type        = string
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south" # You can change this to your preferred region
}

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.80.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1, < 1.0.0"
    }
  }
}
```

-   **`variable` blocks**: These define the `ibmcloud_api_key` and `prefix` variables. The `sensitive = true` argument for the API key prevents Terraform from displaying it in logs.
-   **`provider "ibm"` block**: This block configures the IBM Cloud provider. It's set up to use the `ibmcloud_api_key` variable for authentication.

## Step 4: Initialize Terraform

The final preparation step is to initialize the Terraform working directory. This command downloads the required provider plugins (in this case, for IBM Cloud and `time`).

1.  **Run `terraform init`**:
    In your terminal, at the root of the project directory, run:

    ```bash
    terraform init
    ```

2.  **Verify the Output**:
    You should see a success message confirming that Terraform has been initialized.

You are now ready to start building the infrastructure.

Your workspace is now ready! In the next section, we will start defining the infrastructure resources.

---

[Next: Building the Infrastructure with Terraform Modules](./04-building-with-terraform-modules.md)
