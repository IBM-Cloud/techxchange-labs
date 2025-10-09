# Developing Custom Automation (High-Code Approach)

In this section, you'll develop a custom deployable architecture using the **high-code approach** with Terraform and IBM Cloud modules.

You'll create Terraform configuration to deploy the **Loan Risk AI Agents sample application** using IBM Cloud Code Engine - a fully managed, serverless platform that handles both building container images from source code and running applications with automatic scaling.

You'll use pre-built modules from the [terraform-ibm-modules](https://github.com/terraform-ibm-modules) library instead of writing infrastructure code from scratch.

## Step 1: Set up Terraform project structure

You're already in the `terraform-simple-template` directory in your WebIDE Development Workspace, which contains most of the required Terraform files:
- `main.tf` - Defines resources and modules
- `variables.tf` - Declares input variables
- `outputs.tf` - Defines output values
- `providers.tf` - Configures the IBM Cloud provider
- `version.tf` - Sets required Terraform versions

## Step 2: Set up IBM Cloud provider

Set up the provider configuration by updating two files: `providers.tf` and `version.tf`. These files specify your IBM Cloud API key and region settings, which are necessary for Terraform to authenticate with IBM Cloud and understand which region and services to interact with during resource provisioning.

**Add the following content to `providers.tf`:**

```hcl
provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south"
}
```

**Add the following content to `version.tf`:**

```hcl
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.80.4"
    }
  }
}
```

## Step 3: Define input variables

Define the required (`ibmcloud_api_key`, `watsonx_project_id` and `prefix`) and optional (`watsonx_ai_api_key`) input variables in `variables.tf`. These variables enable you to manage configuration values separately from your main code, making the setup more maintainable and reusable across different environments.

**Add the following content to `variables.tf`:**

```hcl
variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key."
  sensitive   = true
}

variable "watsonx_ai_api_key" {
  type        = string
  description = "The API key for IBM watsonx in the target account. If this key is not provided, the IBM Cloud API key will be used instead."
  sensitive   = true
  default     = null
}

variable "watsonx_project_id" {
  type        = string
  description = "IBM Watsonx project ID."
}

variable "prefix" {
  type        = string
  description = "The prefix to be added to all resources name created by this solution."
}
```

## Step 4: Configure infrastructure components

Now we'll build the main Terraform configuration that defines all the infrastructure components needed to deploy our application. The `main.tf` file orchestrates resource groups, Code Engine project, secrets, builds, and the application deployment.

All resources will be created with a prefix (`${var.prefix}-`) to avoid naming conflicts and provide consistent naming structure.

### Resource group

Create a **Resource Group** to logically organize and manage your IBM Cloud resources. Using your initials as a prefix in the resource group name helps avoid naming conflicts with other resources in your account.

**Add the following content to `main.tf`:**

```hcl
module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.3.0"
  resource_group_name = "${var.prefix}-resource-group"
}
```

> For more information about this module, see the [terraform-ibm-resource-group documentation](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group).

### Code Engine project

Create a **Code Engine project** to host and manage the **Loan Risk AI Agents sample application** workloads in a serverless container environment.

**Add the following content to `main.tf`:**

```hcl
module "code_engine_project" {
  source            = "terraform-ibm-modules/code-engine/ibm//modules/project"
  version           = "4.5.1"
  name              = "${var.prefix}-ce-project"
  resource_group_id = module.resource_group.resource_group_id
}
```

### Code Engine secret

Create a **Code Engine secret** to grant access to the private container registry (`private.us.icr.io`), enabling the push of container images for the application. IBM Cloud Container Registry is the service that you can use to store and share your container images. This secret authenticates with the container registry during the build process.

**Add the following content to `main.tf`:**

```hcl
module "code_engine_secret" {
  source     = "terraform-ibm-modules/code-engine/ibm//modules/secret"
  version    = "4.5.1"
  name       = "${var.prefix}-registry-access-secret"
  project_id = module.code_engine_project.id
  format     = "registry"
  data = {
    "server"   = "private.us.icr.io",
    "username" = "iamapikey",
    "password" = var.ibmcloud_api_key,
  }
}
```

### Container Registry namespace

Create an **IBM Cloud Container Registry namespace** to organize and store container images.

**Add the following content to `main.tf`:**

```hcl
resource "ibm_cr_namespace" "rg_namespace" {
  name              = "${var.prefix}-crn"
  resource_group_id = module.resource_group.resource_group_id
}
```

### Code Engine build

Create a **Code Engine build** to automatically build container images from source code and push them to the container registry.

Key inputs:
- **source_url** – [Git repository](https://github.com/IBM/ai-agent-for-loan-risk) containing the AI application source code
- **strategy_type** – Uses the Dockerfile in the repository to build the image
- **output_secret** – References the secret created earlier for registry authentication
- **output_image** – Destination path in Container Registry for the built image

**Add the following content to `main.tf`:**

```hcl
locals {
  output_image = "private.us.icr.io/${resource.ibm_cr_namespace.rg_namespace.name}/ai-agent-for-loan-risk"
}

module "code_engine_build" {
  source                     = "terraform-ibm-modules/code-engine/ibm//modules/build"
  version                    = "4.5.1"
  name                       = "${var.prefix}-ce-build"
  ibmcloud_api_key           = var.ibmcloud_api_key
  project_id                 = module.code_engine_project.id
  existing_resource_group_id = module.resource_group.resource_group_id
  source_url                 = "https://github.com/IBM/ai-agent-for-loan-risk"
  strategy_type              = "dockerfile"
  output_secret              = module.code_engine_secret.name
  output_image               = local.output_image
}
```

### Code Engine application

Deploy a Code Engine application to run the containerized application as a scalable, serverless workload.

Key inputs:
- **image_reference** – Path to the container image built in the previous step
- **image_secret** – References the secret for registry access
- **run_env_variables** – Environment variables for watsonx integration

**Add the following content to `main.tf`:**

```hcl
module "code_engine_app" {
  depends_on      = [ module.code_engine_build ]
  source          = "terraform-ibm-modules/code-engine/ibm//modules/app"
  version         = "4.5.1"
  project_id      = module.code_engine_project.id
  name            = "${var.prefix}-ai-agent-for-loan-risk"
  image_reference = module.code_engine_build.output_image
  image_secret    = module.code_engine_secret.name
  run_env_variables = [{
    type  = "literal"
    name  = "WATSONX_AI_APIKEY"
    value = var.watsonx_ai_api_key != null ? var.watsonx_ai_api_key : var.ibmcloud_api_key  # Uses watsonx API key if provided, otherwise falls back to IBM Cloud API key for LLM inferencing
    },
    {
      type  = "literal"
      name  = "WATSONX_PROJECT_ID"
      value = var.watsonx_project_id
    }
  ]
}
```

## Step 5: Define outputs

Define output values to provide quick access to important resource information after deployment:

- **Resource Group ID** – For referencing in other services
- **Code Engine Project ID** – For managing workloads
- **Container Image URL** – For deployments
- **Application Route URL** – Public endpoint to access the application

**Add the following content to `outputs.tf`:**

```hcl
output "resource_group_id" {
 value       = module.resource_group.resource_group_id
 description = "The ID of the resource group."
}
output "ce_project_id" {
 value       = module.code_engine_project.id
 description = "The ID of the code engine project."
}
output "output_image" {
 value       = local.output_image
 description = "The URL of the container registry image"
}
output "app_url" {
 value       = module.code_engine_app.endpoint
 description = "The public endpoint to access the deployed loan application."
}
```

## Step 6: Configure variables and deploy the infrastructure

### Configure secure variables

You'll deploy this infrastructure twice: locally now to test, and later (optionally) from the catalog to validate the end-user experience.

To work with IBM Cloud resources, create an **IBM Cloud IAM API key**:

1. Go to the [IBM Cloud Console](https://cloud.ibm.com) for your target account _(Environment 2)_
1. Navigate to **Manage → Access (IAM) → API Keys**
1. Click **Create**, enter a `Name` and click **Create**

> ❗ **Important**: Keep the popup window with the API Key open for the next step. You can also download your API key for later use, or keep note of it in a text note for this lab. In production, store this securely.

> 📝 **Note:** For this part of the lab, the `watsonx_project_id` and `watsonx_ai_api_key` are provided to enable the AI application to function immediately after deployment. In the next section of the lab, you'll learn how to create the watsonx.ai instances through automation, eliminating the need to manually provide the project id and watsonx_ai_api_key.



You need to create the `terraform.tfvars` file:

1. Right-click in the file explorer and select **New File**
2. Enter `terraform.tfvars` as the filename and press Enter
3. Copy and paste the following template into the file:

```hcl
ibmcloud_api_key             = "<your-IBM-cloud-api-key>"        # From IBM Cloud IAM
watsonx_ai_api_key           = "<your-watsonx-ai-api-key>"       # Provided in the lab
watsonx_project_id           = "<your-watsonx-project-id>"       # Provided in the lab
prefix                       = "<your-initials>"                 # Use your initials to avoid naming conflicts
```

4. Replace the placeholder values with your actual values

### Deploy the infrastructure

Now deploy the infrastructure:

1. Open a terminal: Click the hamburger menu (☰) → **Terminal → New Terminal**
2. Run these commands:

```bash
terraform init   # Initialize providers and modules
terraform plan   # Preview changes without applying
terraform apply  # Apply changes (type 'yes' when prompted)
```

> This may take a few minutes. While waiting, you can explore the resources being created in the IBM Cloud console.



While you're waiting for the full apply to complete, let's explore the resources being created in the IBM Cloud Console of your target sandbox account (Environment 2). You may need to refresh the page periodically to see the new resources as they are being created.

Make sure you open these links in the target sandbox account:
- Code Engine Project section: https://cloud.ibm.com/containers/serverless/projects
  1. Click on your serverless project named `<your-initials>-ce-project`
  2. In the project dashboard, navigate to the **Image builds** section from the left-hand menu to view your build configuration
  3. Click on the build, then click **step-source-default** to see the logs of the AI app being built
  4. Once the build is done, navigate to the **Applications** section to view your application configuration. You should see the app starting to deploy, based on the docker image just built
  4. In the project dashboard, navigate to the **Secrets and configmaps** section to view your created secrets
- Resource Groups section: https://cloud.ibm.com/account/resource-groups

You can also view all your resources in one place: https://cloud.ibm.com/resources (type your prefix in the name filter to find your resources)

> ✅ **Success:** After the apply completes, your IBM Cloud resources will be successfully provisioned.

> 🌐 To **access** the **deployed Loan Risk AI Agents sample application**, look at the **`app_url`** output from the `terraform apply` command — it provides the public URL of the running application. You can navigate to application URL (`app_url`) in your browser to access and test the AI Agent for Loan Risk application UI.
Note that it may take up to 1 minute for the application to fully load after deployment, so if the page doesn't respond immediately, give it a moment before refreshing.

## Local Infrastructure Cleanup

Now that you've successfully tested your infrastructure automation by deploying it, it's important to clean up the resources to avoid unnecessary costs.

1. **Navigate to your Terraform project directory** (if not already there)
2. **Run the destroy command:**

   ```bash
   terraform destroy
   ```

3. **Review the resources** that will be destroyed and confirm by typing `yes` when prompted
4. **Wait for the destruction process** to complete


> 📝 **Note:** This cleanup only removes the resources you deployed locally for testing. Later in the lab, when you deploy via the catalog using IBM Cloud Projects, you'll learn how to clean up those resources as well.

## Conclusion

You've successfully built and tested custom Terraform automation for the AI application using enterprise-grade modules. In the next step, you'll package this automation as a deployable architecture and publish it to the IBM Cloud Catalog for organization-wide use.

---

▶️ **Next:** [Publishing Your Automation to the Catalog](./05-publish-sample-agentic-da-into-catalog.md)
