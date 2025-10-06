# Developing Custom Automation (High-Code Approach)

In this section, you'll develop your first custom deployable architecture using the **high-code approach** by writing Terraform configurations with terraform-ibm-modules.

You'll create a complete Terraform configuration that builds and containerizes the **Loan Risk AI Agents sample application** from source code, securely pushes the container image to IBM Cloud Container Registry, and deploys it as a scalable, serverless application on Code Engine.

IBM Cloud Code Engine is a fully managed, serverless platform that we'll use in this lab to build our container image directly from source code and run our AI application without managing infrastructure. For our Loan Risk AI Agents application, Code Engine provides two key capabilities: (1) building the container image from the GitHub repository and pushing it to Container Registry, and (2) deploying and running the application with automatic scaling based on demand.

Rather than writing infrastructure code from scratch, you'll use pre-built, enterprise-grade Terraform modules provided in the [terraform-ibm-modules](https://github.com/terraform-ibm-modules) (TIM) library, that provide officially supported IBM Cloud components with built-in security controls and compliance features:

- [terraform-ibm-resource-group](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group) for foundational resource organization
- [terraform-ibm-code-engine](https://github.com/terraform-ibm-modules/terraform-ibm-code-engine) for the complete Code Engine deployment pipeline

## Step 1: Set up Terraform project structure

We will follow standard Terraform practices by organizing the code into a modular, maintainable structure. This approach helps separate concerns, improves readability, and makes the configuration easier to scale or reuse. Therefore, the structure of the Terraform project will be as follows:

```text
ai-agent-for-loan-risk/
├── .gitignore          # Specifies which files and directories Git should ignore and not track in version control.
├── main.tf             # Defines the Terraform resources/modules
├── variables.tf        # Declares input variables used in the project
├── terraform.tfvars    # Provides values for the declared variables
├── outputs.tf          # Outputs useful information after apply (e.g., resource group ID)
├── providers.tf         # Configures the IBM Cloud provider
└── version.tf          # Defines required Terraform and provider versions
```

This structure ensures the configuration is modular, organized, and aligned with Terraform best practices, making it easier to manage the deployment lifecycle of the **Loan Risk AI Agents sample application**.

To begin, navigate to the `terraform-simple-template` directory in your workspace, which contains the required Terraform configuration files: `.gitignore`, `main.tf`, `variables.tf`, `terraform.tfvars`, `outputs.tf`, `providers.tf`, and `version.tf`.

If any of these files are missing, you can create them manually: `right-click` in the folder view, and select `New File`. Enter the file name (e.g., `terraform.tfvars`) and press Enter to create it.

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

Define the required (`ibmcloud_api_key`, `watsonx_project_id` and `prefix`) and optional (`watsonx_ai_api_key` and `container_registry_api_key`) input variables in `variables.tf`. These variables enable you to manage configuration values separately from your main code, making the setup more maintainable and reusable across different environments.

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

Create a **Code Engine secret** to grant access to the private container registry (`private.us.icr.io`), enabling the push of container images for the **Loan Risk AI Agents sample application**. This secret will be used by Code Engine's build process to authenticate with the container registry when pushing the built image.

IBM Cloud Container Registry is a private, multi-tenant registry that you can use to securely store and share your container images with users in your IBM Cloud account. It provides a secure way to store Docker images that can be deployed to various IBM Cloud services, including Code Engine.

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

Create an **IBM Cloud Container Registry namespace** to organize and store container images used by the **Loan Risk AI Agents sample application**.

**Add the following content to `main.tf`:**

```hcl
resource "ibm_cr_namespace" "rg_namespace" {
  name              = "${var.prefix}-crn"
  resource_group_id = module.resource_group.resource_group_id
}
```

### Code Engine build

Create a **Code Engine build** to automatically build container images from source code and push them to the container registry for the **Loan Risk AI Agents sample application**.

The `code_engine_build` module includes key inputs:

- **source_url** – [The URL of the Git repository](https://github.com/IBM/ai-agent-for-loan-risk) that contains the source code for the **Loan Risk AI Agents sample application**.
- **strategy_type** – Set to `dockerfile`, which tells Code Engine to use a Dockerfile located in the [Git repository](https://github.com/IBM/ai-agent-for-loan-risk/blob/main/Dockerfile) to define how the container image should be built.
- **output_secret** – The name of the Code Engine secret (created in the previous step) that contains credentials for authenticating with the IBM Cloud Container Registry. This allows the built image to be securely pushed to the container registry under your CR namespace.
- **output_image** – The full path of the image (including registry namespace and image name) where the final container will be stored. This is the destination in IBM Cloud Container Registry where the built image is pushed.

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

Deploy a Code Engine application to run the containerized **Loan Risk AI Agents sample application** as a scalable, serverless workload in your AI agent infrastructure.

The `code_engine_app` module includes key inputs:

- **image_reference** – The full path to the container image in IBM Cloud Container Registry (same value as `output_image` from the build step). This image will be used to launch the application. In this case, we point to the image that was built in the previous step.
- **image_secret** – The name of the Code Engine secret (created in the previous step) that provides access to the container registry, allowing the application to securely pull the container image.

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

At the end of the Terraform deployment, output values provide quick access to important information about the resources you’ve provisioned. These outputs can include identifiers, URLs, or other values that are useful for follow-up tasks, integration, or verification.

For the **Loan Risk AI Agents sample application**, the outputs may include:

- **Resource Group ID** – Used to reference the group in other services or modules
- **Code Engine Project Name or ID** – Helpful for tracking and managing workloads
- **Container Image URL** – Used for deployments or monitoring
- **Application Route URL** – The public endpoint to access the deployed loan application

Defining outputs in your `outputs.tf` file helps make your Terraform configuration more user-friendly, modular, and ready for automation or scripting in CI/CD pipelines.

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

### Why Test Locally First?

As a platform engineer, you'll deploy this infrastructure **twice** in this lab: now (locally) to test and validate your automation works correctly, and later (from catalog) to test the deployable architecture experience for end users. This dual-deployment approach ensures your automation is reliable before teams across your organization start using it.

### Configure secure variables

### Set up your configuration values

#### 🔐 IBM Cloud IAM API Key - Required for accessing IBM Cloud resources during this tutorial

> 📝 **Note:** For this lab, the `watsonx_project_id` and `watsonx_ai_api_key` are provided to enable the AI application to function immediately after deployment. In the next steps of this lab, you'll learn how to automate the creation of watsonx.ai resources using deployable architectures, eliminating the need to manually configure project IDs.

To work with IBM Cloud resources, you’ll need an **IBM Cloud IAM API key**.

How to obtain your API key:

1. Go to the [IBM Cloud Console](https://cloud.ibm.com) for your target account
_(Environment 2 – IBM Cloud Sandbox – Target Deployment Account)._
1. Navigate to:
**Manage → Access (IAM) → API Keys**
1. Click **Create**, then enter a `Name` and click on **Create** to generate a new API key.

> ❗ **Important**:
Download your API key file for later use in this lab. In a real-world scenario, this should be stored in a secure location.

> 💡 **Tip:** The `.gitignore` file is already in place for the lab environment and prevents sensitive configuration from being accidentally committed.

Open the `terraform.tfvars` and replace the placeholder values with your actual values:

```hcl
ibmcloud_api_key             = "<your-IBM-cloud-api-key>"        # From IBM Cloud IAM
watsonx_ai_api_key           = "<your-watsonx-ai-api-key>"       # Provided in the lab
watsonx_project_id           = "<your-watsonx-project-id>"       # Provided in the lab
prefix                       = "<your-initials>"                 # Use your initials to avoid naming conflicts
```

Copy and paste this template into your `terraform.tfvars` file, then replace the placeholder values with your actual values.

### Deploy the infrastructure

Now that all required Terraform configuration files are in place, you're ready to deploy the **Loan Risk AI Agents sample application** on IBM Cloud.

In your terminal, run the following commands:

```bash
terraform init
```

> Initializes the working directory by downloading necessary providers and initializing any referenced modules.

<pre style="font-size: 9px;">
terraform init
Initializing the backend...
Initializing modules...
Downloading registry.terraform.io/terraform-ibm-modules/code-engine/ibm 4.5.1 for code_engine_app...
...
Terraform has been successfully initialized!
</pre>

```bash
terraform plan
```

> Shows an execution plan detailing what resources will be created, changed, or destroyed — **without applying changes**.  
> In a real-world scenario, use this to **review safely** before applying anything.

<pre style="font-size: 9px;">
terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  &#43; create
 <= read (data resources)

Terraform will perform the following actions:

  &#35; ibm_cr_namespace.rg_namespace will be created
  &#43; resource "ibm_cr_namespace" "rg_namespace" {
      &#43; name                  = "txc-2025-crn"
      &#43; resource_group_id     = (known after apply)
    }

  &#35; module.code_engine_app.ibm_code_engine_app.ce_app will be created
  &#43; resource "ibm_code_engine_app" "ce_app" {
      &#43; name                          = "ai-agent-for-loan-risk"
      &#43; image_reference               = "private.us.icr.io/txc-2025-crn/ai-agent-for-loan-risk"
      &#43; endpoint                      = (known after apply)
    }

...

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  &#43; app_url           = (known after apply)
  &#43; ce_project_id     = (known after apply)
  &#43; output_image      = "private.us.icr.io/txc-2025-crn/ai-agent-for-loan-risk"
  &#43; resource_group_id = (known after apply)
</pre>

```bash
terraform apply
```

> Applies the changes required to reach the desired state of the configuration.
> When prompted, type `yes` to confirm and begin provisioning. This may take a few minutes, but you can already start exploring the resources being created in your IBM Cloud console while waiting, as described in the next steps.

<pre style="font-size: 9px;">
terraform apply

Terraform used the selected providers to generate the following execution plan...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.resource_group.ibm_resource_group.resource_group[0]: Creating...
module.code_engine_project.ibm_code_engine_project.ce_project: Creating...
...
module.code_engine_app.ibm_code_engine_app.ce_app: Creation complete after 1m1s

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

app_url = "https://ai-agent-for-loan-risk.1xz02kcijske.us-south.codeengine.appdomain.cloud"
ce_project_id = "ed7e8ae7-fa42-4af6-8c54-66e00ea13186"
output_image = "private.us.icr.io/txc-2025-crn/ai-agent-for-loan-risk"
resource_group_id = "82a136aaa2a44964a5b45e9370a93ff2"
</pre>

---
> ✅ **Success:** After running the above commands, your IBM Cloud resources have been **successfully provisioned**. Let's explore the resources you've created in the IBM Cloud Console of your target sandbox account (Environment 2):

We invite you to explore your newly created resources (make sure you open these links in the target sandbox account):
- Resource Groups section: https://cloud.ibm.com/account/resource-groups
- Container Registry section: https://cloud.ibm.com/containers/registry/namespaces
- Code Engine Project section: https://cloud.ibm.com/containers/serverless/projects
  - In the project dashboard, navigate to the **Applications** section from the left-hand menu to view the configuration of your created `application`
  - In the project dashboard, navigate to the **Image builds** section from the left-hand menu to view the configuration of your created `image build`
  - In the project dashboard, navigate to the **Secrets and configmaps** section from the left-hand menu to view the configuration of your created `secret`

You can also view all your resources in one place: https://cloud.ibm.com/resources (type your prefix in the name filter to find your resources)

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

You've successfully built and tested custom Terraform automation for the **Loan Risk AI Agents sample application**. You've learned how to create infrastructure configurations using enterprise-grade modules and validate your automation through local testing.

In the next step, you'll learn how to package this automation as a deployable architecture and publish it to the IBM Cloud Catalog for organization-wide use.

---

▶️ **Next:** [Publishing Your Automation to the Catalog](./05-publish-sample-agentic-da-into-catalog.md)
