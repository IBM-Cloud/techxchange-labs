# Complete Solution Stack with Low-Code Composition

You've built a custom deployable architecture for your application using the high-code approach. Now you'll learn the **low-code approach** by combining your custom DA with pre-built IBM Cloud services to create a complete, production-ready solution stack.

The **low-code approach** means creating a complete solution by combining existing deployable architectures (DAs) together and wiring their inputs and outputs through the UI. The platform engineer doesn't need to write a single line of code or HCL - everything is configured through visual interfaces and reference connections.

> 💡 **Simple Goal:** Combine three deployable architectures into one complete solution:
> - Your custom Code Engine DA (application workload)
> - [Watsonx.ai SaaS DA](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-watsonx-ai-saas-e8ad6597-8c1a-466a-8bb7-243a109daaa8-global) (AI services) - *provided by IBM through the public catalog*
> - **Optional:**[Security & Observability DA](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/deploy-arch-ibm-observability-a3137d28-79e0-479d-8a24-758ebd5a0eab-global) (enterprise features) - *provided by IBM through the public catalog*
>
> For time efficiency, we'll first follow the complete steps for adding Watsonx.ai only, and then show how to add the observability and encryption services as an optional part of the lab. The steps are conceptually the same for all DAs - wiring outputs of one DA as inputs to another. In a real-world scenario, you would wire all DAs first and then share the full stack in one go.

Then, wire them together, test the complete solution, and share it as a reusable stack.

## Step 1: Wire the Components Together

Start by creating a new IBM Cloud project named `<your-initials>-txc-project` that will act as the central workspace for your deployment architecture. This project will serve as a container for all configuration files, resource definitions, and integration logic related to your solution.

> 💡 **Think of it as:** The "root" of your deployment stack—where each individual Deployment Architecture (DA) will be added as a modular component. Once each DA is added and configured, you'll wire them together to form a complete, production-ready solution stack that can be tested and shared to end-users through the private catalog.

### Create a new IBM Cloud project

You will add this architecture to a new IBM Cloud project named `<your-initials>-txc-project`, using the `us-south` region and the `Default` resource group.

> **Important**: Make sure you're in the target sandbox account (Environment 2 - IBM Cloud Sandbox - Target Deployment Account) for this step.

1. In the IBM Cloud console, click the **navigation menu (☰)** in the top-left corner, then select **Projects** from the menu - or go directly to [**Projects**](https://cloud.ibm.com/projects)
1. On the Projects page, click **Create** to start setting up a new project
1. On the **Create a project** page, fill out the form as follows:
    - Enter `<your-initials>-txc-project` as the project **Name**
    - Select the `Default` **resource group** from the dropdown
    - Select the `Dallas (us-south)` **region** from the region dropdown
1. Then click **Create** to finish setting up the project


### Add and Configure Watsonx.ai SaaS DA

In this step, we’ll add the `Cloud foundation for AI ops and governance with watsonx` Deployment Architecture from the public IBM Cloud Catalog. This will serve as the foundation for our AI sample application.

1. Navigate to the **Catalog** via the top menu, or go directly to the [Catalog page](https://cloud.ibm.com/catalog).
1. In the Catalog search bar, type `Cloud foundation for AI ops and governance with watsonx` and select it from the results.
1. Review the features and capabilities, and choose the product version `v1.9.38`.
1. Select the checkbox labeled `I have read and agree to the following license agreements` and click the **Configure and deploy** button.
1. Since you already have a project, make sure **Add to existing** in the left-hand menu is selected, then choose the `<your-initials>-txc-project` project from the dropdown list.
1. Change the configuration name to `watsonx-ai-saas-demo`, then click **Add**.

After adding a deployable architecture to your project, you can edit its input values to customize the deployment. While configurations can be generic, most projects use specific configurations—or groups of them—to deploy resources across different environments, such as development, test, and production.

1. On the Edit watsonx-ai-saas-demo page, scroll down and click **Next** to continue.
1. To enter the **API key**, simply copy and paste the value of the key you created earlier.
1. Click **Next** to continue.
1. To enter a **resource group**, click `Edit` inside the `resource_group_name` input field, then enter the name of a new or existing resource group. In our case we will use `txc-watson-rg`.
1. To configure all input variables, turn on **Optional inputs** to enable editing of optional inputs and fine-tune your configuration.
1. In the input field labeled `resource_prefix`, enter the `<your-initials>-txc-demo`.
1. When all inputs are configured, click the **Done** button, then save the configuration by clicking **Save** in the top-right corner.


### Add and Configure your custom Code Engine DA

1. Navigate to the **Catalog** via the top menu, or go directly to the [Catalog page](https://cloud.ibm.com/catalog).
1. In the Catalog search bar, type `Loan Risk Evaluation with Watsonx AI Agents` and select it from the results.
1. Choose the correct version of the deployment architecture, then click **Configure and deploy** to proceed.
1. Make sure **Add to existing** is selected from the left menu.  Then, choose `<your-initials>-txc-project` from the dropdown. Update the configuration name if needed — in this case, we'll use `agentic-ai-demo`.
1. Click **Add** to continue.

After adding a deployable architecture to your project, you will customize its input values to match your specific use case. While default configurations are provided, you’ll often adjust them based on the type of workload, connected services, or the overall solution you're building.

1. On the Edit agentic-ai-demo page, scroll down and click **Next** to continue.
1. To enter the **API key**, simply copy and paste the value of the key you created earlier.
1. Click **Next** to continue.
1. Enter your Watsonx API key into the **watsonx_ai_api_key** field. **This step is optional** — if the key is not provided, the IBM Cloud API key will be used by default.
1. We will link the input of the `agentic-ai-demo` to the output of the previously deployed `watsonx-ai-saas-demo` DA. Hover over the **watsonx_project_id** input field and click on **Add Reference**.
1. A new popup will open.
    - For **Source**, select `Configuration`.
    - For **Name**, choose your `watsonx-ai-saas-demo`.
    - Set **Category** to `Output`.
    - For **Property**, select `watsonx_project_id`.
1. Click **OK** to confirm the reference selection.
1. Click the **Optional inputs** toggle to display optional input variables, then modify the **prefix** value as needed.
1. Click **Done**, then click **Save** at the top right to save your configuration.


### Dependency Wiring Overview

Before deploying the solution, let’s summarize how the components are wired together using input/output references across configurations. This step ensures that each deployable architecture (DA) is correctly integrated with the others.

| Deployment architecture             | Depends On                       | Input Field                         | Output Source                         |
|----------------------------|----------------------------------|-------------------------------------|----------------------------------------|
| `agentic-ai-demo`          | `watsonx-ai-saas-demo`           | `watsonx_project_id`                | `watsonx-ai-saas-demo.watsonx_project_id` |

> 🔗 **Description of Wiring Logic**
> - The **Custom Code Engine DA (agentic-ai-demo)** needs access to the Watsonx.ai project it will use. It references `watsonx_project_id`, which is an output from the Watsonx.ai SaaS DA.
>
>These input/output references are configured through the UI and ensure secure, consistent integration across your AI solution stack.


## Step 2: Validate and Deploy Configuration (Optional)

Now that all deployment architecture configurations are connected using input and output variables, you can deploy the entire setup. This step is optional as it may take time and doesn't block the other steps in this lab.

There are two ways to deploy:

1. **Manual Deployment** – Validate and deploy each configuration individually.
1. **Automatic Deployment (Auto-deploy)** – Automatically approve and deploy configuration changes after successful validation.

To enable auto-deploy, follow these steps:

1. To get started, click the **☰ Navigation menu** in the top-left corner, then select **Projects** from the list, and open your project, named `<your-initials>-txc-project`, or go directly to the [Projects page](https://cloud.ibm.com/projects).
1. On the Project Details page, click the **Manage** tab, then select **Settings** from the left-hand menu.
1. Toggle **Auto-deploy** to `On` to enable automatic deployment after successful validation.
1. Navigate back to the **Configurations** tab.

>⚠️ **Important**: If you choose to deploy, you must validate and deploy the Deployment Architectures (DAs) in order, as some configurations depend on outputs from others.
>The correct order is:
>- watsonx-ai-saas-demo (provides Watsonx project ID)
>- agentic-ai-demo (depends on Watsonx project ID from watsonx-ai-saas-demo)
>
>Failing to follow this order may result in failed references or missing values during deployment.

If you choose to deploy:

1. From the table, select **watsonx-ai-saas-demo**, then click **Validate** in the action bar that appears above the table.
1. Click **Validate** again to confirm and start the validation process.
1. Wait for the validation to complete successfully.
   > ⏳ Note: This may take several minutes. While you're waiting, it's a good time to review the configuration documentation, double-check input references, or prepare testing steps for your application.

1. Finally, validate **agentic-ai-demo**:
   - Select it from the table
   - Click **Validate**, then confirm.
   - Wait for successful validation.

## Step 3: View Deployment Outputs and test Load Risk AI Agents sample application

> 🌐 If you deployed the configurations, you can access the **deployed Loan Risk AI Agents sample application** by opening the **Outputs** tab of the `agentic-ai-demo` configuration in your project and using the value of **app_url** — it is the public URL of the running application.
Note that it may take up to 1 minute for the application to fully load after deployment, so if the page doesn't respond immediately, give it a moment before refreshing.

## Step 4: Share the full solution as a stack

Now that you've integrated your custom deployable architecture with existing IBM Cloud services, package the entire stack as a reusable solution for application teams. This aligns with the low-code platform engineering approach—enabling self-service consumption of a complete, governed AI platform.

### What to include

- Your custom DA: Loan Risk AI Agents sample application
- Existing DAs: Cloud foundation for AI ops and governance with watsonx
- Integration wiring: configuration references (e.g., watsonx_project_id), and deployment order

### Create a Stack of Deployable Architectures

1. In the IBM Cloud console, click the **navigation menu (☰)** in the top-left corner, then select **Projects** from the menu - or go directly to [**Projects**](https://cloud.ibm.com/projects).
1. Type `<your-initials>-txc-project` in the search bar and click the matching result.
1. Navigate to the **Configuration** tab.
1. Click the checkbox next to the **Name** column header in the table to select all configurations.
1. In the newly opened bar above, click on **Stack** to start the process.
1. Enter the name `txc-stack-demo` in the field.
1. On the new page, you can expose inputs from each deployment architecture (DA) as global input variables. We will expose a global input variable named **prefix**, which can be shared and used across all DAs. To do this, click on **agentic-ai-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix` input variable.
1. Click on **Review** in the left-hand navigation menu, and then click **Finish**.
1. On the new page, you need to define the **prefix** input. Click **Edit** next to the **prefix** input field, and enter the value `txc-stack-demo`.
1. After entering the value, click **Done**, and then **Save** to confirm.

### Share a Stack of Deployable Architectures

1. To share the stack with others, go back to the [**Projects**](https://cloud.ibm.com/projects) page and select your project named `<your-initials>-txc-project`.
1. Navigate to the **Configuration** tab to continue.
1. Click the **Add to private catalog** button to share the stack through your organization's catalog.

> 📤 The stack can now be **shared and published** for organizational use, enabling teams to easily create new products based on the existing stack definition. This gives developers a one-click, secure, and compliant AI platform; and gives platform teams consistent, maintainable delivery at scale.


## Step 5: (Optional) Add and Configure Observability DA

This step is completely optional and demonstrates how the same concept of wiring DAs can be extended to additional services like observability and key management. You can skip this section if you're focused on understanding the core concepts of creating and sharing stacks.

In this optional step, you will deploy the `Cloud automation for Observability` DA, which includes components such as the Key Management Service (KMS). These services can be used to support features like COS KMS encryption in Watsonx.ai.

1. Navigate to the **Catalog** via the top menu, or go directly to the [Catalog page](https://cloud.ibm.com/catalog).
1. In the Catalog search bar, type `Cloud automation for Observability` and select it from the results.
1. Make sure `Create a new architecture` is selected.
1. Review the features and capabilities, choose the appropriate **variation**, ensure `Instances` is selected, pick the correct version (`v3.1.26`), and click **Configure and deploy**.
1. Since you already have a project, make sure **Add to existing** in the left-hand menu is selected, then choose the `<your-initials>-txc-project` project from the dropdown list.
1. Change the configuration name to `observability-demo`, then click **Add**.
1. On the new page, you can add or remove deployable architectures based on your use case.
1. To manage your own keys and configure account-level settings, select **Cloud Automation for Key Protect** (to retain control over encryption keys) and **Cloud automation for account configuration** (to ensure access control, security policies, and compliance settings are consistently applied across your account).
1. Choose **Resource groups with account settings – Starting at $0.00/mo"** to enable these features without additional cost.

After adding a deployable architecture to your project, you can edit its input values to customize the deployment. While configurations can be generic, most projects use specific configurations—or groups of them—to deploy resources across different environments, such as development, test, and production.

1. On the Edit observability-demo page, scroll down and click **Next** to continue.
1. To enter the **API key**, simply copy and paste the value of the key you created earlier.
1. Click **Next** to continue.
1. Click **Edit** inside the **Prefix** input field, and enter the value `<your-initials>-txc-demo`.
1. Click **Done**, then click **Save** in the top-right corner of the page to save your changes.


### Re-configure Watsonx.ai SaaS DA

1. In the IBM Cloud console, click the **navigation menu (☰)** in the top-left corner, then select **Projects** from the menu - or go directly to [**Projects**](https://cloud.ibm.com/projects).
1. Select your project `<your-initials>-txc-project`.
1. Click the **Configuration** tab, then in the table, open the **options menu (⋮)** for the Watsonx configuration `watsonx-ai-saas-demo` and select Edit.
1. On the Edit watsonx-ai-saas-demo page, scroll down and click **Next** to continue.
1. Click **Next** to continue.
1. Toggle on **Optional inputs**
1. Since we want to enable encryption for Cloud Object Storage (COS) by setting **enable_cos_kms_encryption** to `true`, we need to provide a value for **cos_kms_crn** to specify the Key Protect instance used for encryption. To achieve this, we will wire the KMS CRN from the previously configured `Cloud automation for Observability` DA into the `Cloud foundation for AI ops and governance with watsonx` DA.
    - a) Hover your cursor over **cos_kms_crn**, then click the **Add a reference** button that appears.
    - b) A new popup will open:
        - For **Source**, select `Configuration`.
        - For **Name**, choose `observability-demo`.
        - Set **Category** to `Inputs`.
        - For **Property**, select `existing_kms_instance_crn`.
    - c) Click **OK** to confirm the reference selection.
1. To create a new Key Protect key, enter `cos-kms-key-demo` in the **cos_kms_new_key_name** field.
1. Click **Done**, then click **Save** in the top-right corner of the page to save your changes.

>🔄 **Note**: If you chose to deploy the configurations, you would need to re-validate and re-deploy all configurations after making these changes, following the same process described earlier.


## Platform Engineering Achievement

You've successfully mastered both the **high-code** and **low-code** approaches to building deployable architectures, creating a complete, governed AI platform that enables developer self-service while maintaining enterprise standards.

This integrated solution provides:
- Self-service deployment of complex AI infrastructure
- Enterprise security and governance built-in by default  
- Integrated AI services ready for application development
- Consistent, scalable delivery across teams and environments

---

▶️ **Next:** [Final Review and Cleanup](./07-final-review-cleanup.md)
