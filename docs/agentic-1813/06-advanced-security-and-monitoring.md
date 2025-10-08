# Complete Solution Stack with Low-Code Composition

You've built a custom deployable architecture using the high-code approach. Now you'll learn the **low-code approach** by combining your custom DA with pre-built IBM Cloud services DAs to create a complete solution stack through visual interfaces and reference connections - no code required.

> 💡 **Simple Goal:** Combine three deployable architectures into one complete solution:
> - Your custom Code Engine DA (application workload)
> - [Watsonx.ai SaaS DA](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-watsonx-ai-saas-e8ad6597-8c1a-466a-8bb7-243a109daaa8-global) (AI services) - *provided by IBM through the public catalog*
> - **Optional:**[Security & Observability DA](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/deploy-arch-ibm-observability-a3137d28-79e0-479d-8a24-758ebd5a0eab-global) (enterprise features) - *provided by IBM through the public catalog*
>
> For time efficiency, we'll first follow the complete steps for adding Watsonx.ai only, and then show how to add the observability and encryption services as an optional part of the lab. The steps are conceptually the same for all DAs - wiring outputs of one DA as inputs to another. In a real-world scenario, you would wire all DAs first and then share the full stack in one go.

Then, wire them together, test the complete solution, and share it as a reusable stack.

## Step 1: Wire the Components Together

Start by creating a new IBM Cloud project named `<your-initials>-txc-project` that will act as the central workspace for your deployment architecture. This project will contain all your DAs as modular components that you'll wire together.

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

After adding the deployable architecture, customize its input values:

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

Now customize the input values for your Code Engine DA:

1. On the Edit agentic-ai-demo page, scroll down and click **Next** to continue.
1. To enter the **API key**, simply copy and paste the value of the key you created earlier.
1. Click **Next** to continue.
1. We will link the input of the `agentic-ai-demo` to the output of the previously deployed `watsonx-ai-saas-demo` DA. Hover over the **watsonx_project_id** input field and click on **Add a reference**.
1. A new popup will open.
    - For **Source**, select `Configuration`.
    - For **Name**, choose your `watsonx-ai-saas-demo`.
    - Set **Category** to `Output`.
    - For **Property**, select `watsonx_project_id`.
    - Click **OK** to confirm the reference selection.
1. In the input field labeled `prefix`, enter the `<your-initials>-txc-demo`.
1. Click the **Optional inputs** toggle to display optional input variables - **This step is optional**:
    -  Enter your Watsonx API key into the **watsonx_ai_api_key** field. If the key is not provided, the IBM Cloud API key will be used by default.
    -  Enter your Container Registry API key into the **container_registry_api_key** field. If the key is not provided, the IBM Cloud API key will be used by default. 
 then modify the **prefix** value as needed.
1. Click **Done**, then click **Save** at the top right to save your configuration.


### Dependency Wiring Overview

Your components are now wired together with this dependency:

| Deployment architecture | Depends On            | Input Field          | Output Source                      |
|-------------------------|------------------------|----------------------|-----------------------------------|
| `agentic-ai-demo`       | `watsonx-ai-saas-demo` | `watsonx_project_id` | `watsonx-ai-saas-demo.watsonx_project_id` |


## Step 2: Share the full solution as a stack

Now package the entire stack as a reusable solution for application teams:

### Create a Stack of Deployable Architectures

1. In the IBM Cloud console, click the **navigation menu (☰)** in the top-left corner, then select **Projects** from the menu - or go directly to [**Projects**](https://cloud.ibm.com/projects).
1. Type `<your-initials>-txc-project` in the search bar and click the matching result.
1. Navigate to the **Configuration** tab.
1. Click the checkbox next to the **Name** column header in the table to select all configurations.
1. In the newly opened bar above, click on **Stack** to start the process.
1. Enter the name `txc-stack-demo` in the field.
1. On the new page, you can expose inputs from each deployment architecture (DA) as global input variables. We will expose a global input variable named **prefix**, which can be shared and used across all DAs. To do this:
   - Click on **agentic-ai-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix` input variable.
   - Click on **watsonx-ai-saas-demo**, then go to **Optional inputs**, and select **Stack level** for the `resource_prefix` input variable.
1. Click on **Review** in the left-hand navigation menu, and then click **Finish**.

On the new page, you need to define both the **API key** and the **prefix** inputs, as these are now part of the stack inputs shared across all DAs.

1. First, click the **Edit** for **Security** section to show the **ibmcloud_api_key** field
1. Enter your API key value and click **Done**
1. Next, click the **Edit** for **Inputs** section to show the **prefix** input field
1. Click the cross (✕) icon on the `Not set` bubble next to the prefix input field
1. Enter the value `txc-stack-demo`
1. Toggle the **Optional inputs** section to display the **resource_prefix** field. This field will be linked to **prefix**, ensuring a single shared prefix value between both DAs.
1. Hover over the **resource_prefix** input field and click on **Add a reference**. A new popup will open.
    - For **Source**, select `Configuration`.
    - For **Name**, choose your `agentic-ai-demo`.
    - Set **Category** to `Input`.
    - For **Property**, select `prefix`.
    - Click **OK** to confirm the reference selection.
1. Click **Done**, and then **Save** to confirm

### Share a Stack of Deployable Architectures

1. To share the stack with others, go back to the Projects page and select your project named `<your-initials>-txc-project`.
1. Navigate to the **Configuration** tab to continue.
1. Open the menu (⋮) on the configuration row for the stack and click **Add to private catalog**.
1. In the catalog details page:
   - Select your private catalog: `<your-initials>-txc-catalog`
   - Enter a product name: `Agentic AI application with WatsonX`
   - Select category: `AI/Machine Learning`
   - Click **Add** to complete the process

> 📤 The stack can now be **shared and published** for organizational use, enabling teams to easily create new products based on the existing stack definition. This gives developers a one-click, secure, and compliant AI platform; and gives platform teams consistent, maintainable delivery at scale.

### Test the Deployable Architecture as an End User

To verify that your deployable architecture has been successfully added:

1. Go to the IBM Cloud Catalog by clicking **Catalog** in the top navigation bar
1. Use the search bar and type: `Agentic AI application with WatsonX`
1. Once it appears in the results, click on the deployable architecture
1. From there, you can review the details and deploy it directly from the catalog


## Business Value Delivered

This approach delivers significant business value:
- End users can deploy the AI application with its watsonx.ai dependency in just a few clicks
- The automation blueprint handles all the complex wiring between components
- Platform teams can maintain governance while enabling developer self-service
- The solution can be extended with additional enterprise services (as shown in the bonus content)

---

▶️ **Next:** [Final Review and Cleanup](./07-final-review-cleanup.md)

# Bonus Content

## (Optional) Add and Configure Observability DA

This section demonstrates how to extend your solution with additional enterprise services like observability, monitoring, and key management.

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

Now customize the deployment:

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


