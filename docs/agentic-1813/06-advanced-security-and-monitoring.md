# Complete Solution Stack with Low-Code Composition

You've built a custom deployable architecture using the high-code approach. Now you'll learn the **low-code approach** by combining your custom DA with pre-built IBM Cloud services DAs to create a complete solution stack through visual interfaces and reference connections - no code required.

> 💡 **Simple Goal:** Combine four deployable architectures into one complete solution:
> - Your custom Code Engine DA (application workload)
> - [Cloud foundation for AI ops and governance with watsonx](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-watsonx-ai-saas-e8ad6597-8c1a-466a-8bb7-243a109daaa8-global) (Watsonx.AI services) - *provided by IBM through the public catalog*
> - [Cloud automation for Key Protect](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/deploy-arch-ibm-kms-2cad4789-fa90-4886-9c9e-857081c273ee-global?catalog_query=aHR0cHM6Ly9jbG91ZC5pYm0uY29tL2NhdGFsb2cjZGVwbG95YWJsZV9hcmNoaXRlY3R1cmVfdGFi) (Key management services, for encryption) - *provided by IBM through the public catalog*
> - [Cloud automation for Observability](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/deploy-arch-ibm-observability-a3137d28-79e0-479d-8a24-758ebd5a0eab-global) (IBM Cloud Logs and Monitoring) - *provided by IBM through the public catalog*


## Step 1: Add Components to a Project

Start by creating a new IBM Cloud project named `<your-initials>-txc-project` that will act as the central workspace for your deployment architecture. This project will contain all your DAs as modular components that you'll wire together.

> **Important**: Make sure you're in the target sandbox account (Environment 2 - IBM Cloud Sandbox - Target Deployment Account) for this step.

1. In the console, click **☰** in the top-left corner, then **Projects**
1. On the Projects page, click **Create** to start setting up a new project
1. On the **Create a project** page, fill out the form as follows:
    - Enter `<your-initials>-txc-project` as the project **Name**
    - Select the `Default` **resource group** from the dropdown
    - Select the `Dallas (us-south)` **region** from the region dropdown
1. Then click **Create** to finish setting up the project


### Add and Configure your custom Code Engine DA

In this step, we'll add your custom Code Engine DA to the project. This will be the application workload component of your solution.

1. Click **Catalog** in the header bar at top of screen
1. In the Catalog search bar, type `Loan Risk Evaluation with Watsonx AI Agents` and select it from the results.
1. Click **Configure and deploy** to proceed
1. Select **Add to existing** from the left menu and choose `<your-initials>-txc-project` from the dropdown
1. Enter `agentic-ai-demo` as the configuration name
1. Click **Add** to continue.
1. On the Edit agentic-ai-demo page, we won't be making any changes at this point.

### Add and Configure Cloud foundation for AI ops and governance with watsonx

Now, we'll add the `Cloud foundation for AI ops and governance with watsonx` Deployment Architecture from the public IBM Cloud Catalog. This will serve as the foundation for our AI sample application.

1. Click **Catalog** in the header bar at top of screen
1. In the Catalog search bar, type `Cloud foundation for AI ops and governance with watsonx` and select it from the results.
1. Select product version `v1.9.38`
1. Select the checkbox labeled `I have read and agree to the following license agreements` and click **Configure and deploy**
1. Select **Add to existing** from the left menu and choose `<your-initials>-txc-project` from the dropdown
1. Enter `watsonx-ai-saas-demo` as the configuration name and click **Add**
1. On the Edit watsonx-ai-saas-demo page, we won't be making any changes at this point.

### Add and Configure Cloud automation for Key Protect

Next, we'll add the Cloud automation for Key Protect DA to provide security services for our solution.

1. Click **Catalog** in the header bar at top of screen
1. In the Catalog search bar, type `Cloud automation for Key Protect` and select it from the results
1. Select **Fully configurable** variation
1. Click **Configure and deploy**
1. On the "Customize Cloud automation for Key Protect" screen, do NOT select "Cloud automation for account configuration"
1. Select **Add to existing** from the left menu and choose `<your-initials>-txc-project` from the dropdown
1. Enter `key-protect-demo` as the configuration name and click **Add**
1. On the Edit key-protect-demo page, we won't be making any changes at this point

### Add and Configure Cloud automation for Observability

Finally, we'll add the Cloud automation for Observability DA to provide monitoring and observability features.

1. Click **Catalog** in the header bar at top of screen
1. In the Catalog search bar, type `Cloud automation for Observability` and select it from the results.
1. Select `Instances` variation and version `v3.1.26`, then click **Configure and deploy**
1. Select **Add to existing** from the left menu and choose `<your-initials>-txc-project` from the dropdown
1. Enter `observability-demo` as the configuration name and click **Next**
1. **Important**: Unselect **Cloud Automation for Key Protect** as we've already added it separately
1. Click **Add to project**
1. On the Edit observability-demo page, we won't be making any changes at this point.

## Step 2: Create a Stack of Deployable Architectures

Now package the entire stack as a reusable solution for application teams:

1. In the console, click **☰** in the top-left corner, then **Projects**
1. Select your project `<your-initials>-txc-project`
1. Navigate to the **Configuration** tab
1. Click the checkbox next to the **Name** column header in the table to select all configurations
1. Click the **Stack** button that appears in the toolbar
1. Enter the name `secure-ai-stack` in the field and click **Continue**
1. On the new page, you can expose inputs from each deployment architecture (DA) as input variables for the stack. These are the variables that end-users of the stack will initially see, so it's best to keep them simple and minimal. We will expose the following stack input variables:
   - Click on **agentic-ai-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix` input variable
   - Click on **watsonx-ai-saas-demo**, then go to **Required inputs**, and select **Stack level** for the `resource_group_name` input variable
   - Click on **watsonx-ai-saas-demo**, then go to **Optional inputs**, and select **Stack level** for the `use_existing_resource_group` input variable
   - Click on **key-protect-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix`, `resource_group_name`, `region`, and `use_existing_resource_group` input variables
   - Click on **observability-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix` and `region` input variables

1. For all DAs, also expose all settings under **Security** by selecting **Stack level** for the checkboxes for **authorizations** and **compliance_profile**

1. Click on **Review** in the left-hand navigation menu, and then click **Finish**

> **Note**: You may be directed to a screen showing an input error for the Security section. You can ignore this error.

## Step 3: Wire the Components Together

Now that we've created a stack with all four components, we need to wire them together to create a complete solution.

### Wire the Custom DA with Watsonx.ai

First, let's connect your custom Code Engine DA with the Watsonx.ai SaaS DA:

1. In the console, click **☰** in the top-left corner, then **Projects**
1. Select your project `<your-initials>-txc-project`
1. Click the **Configuration** tab, then click the name of the newly created stack (`secure-ai-stack`)
1. The new screen shows the list of components (our 4 DAs)
1. In the table, open the **options menu (⋮)** for the Code Engine configuration `agentic-ai-demo` and select **Edit**
1. On the Edit agentic-ai-demo page, click **Next** twice to go to the inputs page
1. We will link the input of the `agentic-ai-demo` to the output of the `watsonx-ai-saas-demo` DA. Hover over the **watsonx_project_id** input field and click on **Add a reference**
1. A new popup will open:
    - For **Source**, select `Configuration`
    - For **Name**, choose your `watsonx-ai-saas-demo`
    - Set **Category** to `Output`
    - For **Property**, select `watsonx_project_id`
    - Click **OK** to confirm the reference selection
    > **Note**: You may see an error "The reference can't be found." This is expected as the DA is not deployed yet.
1. Click **Done**, then click **Save** at the top right to save your configuration



### Wire Watsonx.ai with Key Protect

Next, let's connect the Watsonx.ai SaaS DA with the Key Protect DA to enable customer-managed encryption keys (where you own the key to the data, not IBM):

1. In the console, click **☰** in the top-left corner, then **Projects**
1. Select your project `<your-initials>-txc-project`
1. Click the **Configuration** tab, then click the name of the newly created stack (`secure-ai-stack`)
1. The screen shows the list of components (our 4 DAs)
1. In the table, open the **options menu (⋮)** for the Watsonx configuration `watsonx-ai-saas-demo` and select **Edit**
1. On the Edit watsonx-ai-saas-demo page, click **Next** twice to go to the inputs page
1. Toggle on **Optional inputs**
1. Set **enable_cos_kms_encryption** to `true` (towards the bottom of the list of optional inputs)
1. For the **cos_kms_crn** field, we need to reference the Key Protect instance. Hover over this field and click on **Add a reference**
1. A new popup will open:
    - For **Source**, select `Configuration`
    - For **Name**, choose `key-protect-demo`
    - Set **Category** to `Output`
    - For **Property**, select `kms_instance_crn`
    - Click **OK** to confirm the reference selection
1. Enter `cos-kms-key-demo` in the **cos_kms_new_key_name** field
1. Click **Done**, then click **Save** in the top-right corner of the page to save your changes

### Wire Observability with Key Protect

Finally, let's connect the Observability DA with the Key Protect DA to enable integrated key management:

1. In the console, click **☰** in the top-left corner, then **Projects**
1. Select your project `<your-initials>-txc-project`
1. Click the **Configuration** tab, then click the name of the newly created stack (`secure-ai-stack`)
1. The screen shows the list of components (our 4 DAs)
1. In the table, open the **options menu (⋮)** for the Observability configuration `observability-demo` and select **Edit**
1. On the Edit observability-demo page, click **Next** twice to go to the inputs page
1. For the **existing_kms_instance_crn** field, we need to reference the Key Protect instance. Hover over this field and click on **Add a reference**
1. A new popup will open:
    - For **Source**, select `Configuration`
    - For **Name**, choose `key-protect-demo`
    - Set **Category** to `Output`
    - For **Property**, select `kms_instance_crn`
    - Click **OK** to confirm the reference selection
1. Click **Done**, then click **Save** in the top-right corner of the page to save your changes

### Dependency Wiring Overview

Your components are now wired together with these dependencies:

| Deployment architecture | Depends On            | Input Field          | Output Source                      |
|-------------------------|------------------------|----------------------|-----------------------------------|
| `agentic-ai-demo`       | `watsonx-ai-saas-demo` | `watsonx_project_id` | `watsonx-ai-saas-demo.watsonx_project_id` |
| `watsonx-ai-saas-demo`  | `key-protect-demo`     | `cos_kms_crn`        | `key-protect-demo.kms_instance_crn` |
| `observability-demo`    | `key-protect-demo`     | `existing_kms_instance_crn` | `key-protect-demo.kms_instance_crn` |

## Step 4: Share the Stack in a Private Catalog

Now that you've created and configured your stack, you can share it with others through a private catalog:

### Add the Stack to a Private Catalog

1. In the console, click **☰** in the top-left corner, then **Projects**
1. Select your project `<your-initials>-txc-project`
1. Navigate to the **Configuration** tab
1. Open the menu (⋮) on the configuration row for the stack and click **Add to private catalog**
1. In the catalog details page:
   - Select your private catalog: `<your-initials>-txc-catalog`
   - Enter a product name: `Enterprise-Ready AI Risk Evaluation Platform`
   - Select category: `AI/Machine Learning`
   - Click **Next** and then **Add** to complete the process

> 📤 The stack can now be **shared and published** for organizational use, enabling teams to easily create new products based on the existing stack definition. This gives developers a one-click, secure, and compliant AI platform; and gives platform teams consistent, maintainable delivery at scale.

## Step 5: Optional - Deploy the Stack

You can optionally deploy the stack to verify that everything works correctly from an end-user perspective.

### Deploy the Stack from the Catalog

1. Click **Catalog** in the header bar at top of screen
1. Use the search bar and type: `Enterprise-Ready AI Risk Evaluation Platform`
1. Once it appears in the results, click on the stack
1. Review the details - you may click Components tab to confirm that the stack is made of the 4 deployable architectures, including our custom one.
1. Click **Configure and deploy**
1. Click **Add to existing** (we'll reuse the existing project for convenience in this lab)
1. Select your project `<your-initials>-txc-project`
1. Click **Add** to complete the process
1. Enter the required inputs:
   - API key: copy paste your existing IBM Cloud API key
   - prefix: `<your-initials>-stack` (to avoid a clash in naming with the previously deployed code engine instance in part 1 of this lab)
   - resource_group: `Default`
   - use_existing_resource_group: `true`
   - region: `us-south`
1. Click **Done** and then **Save** at the top left of the screen
1. After a few seconds, click the ***View stack configurations** button
1. Click the kebab (three dots) on the top right of the screen to expand the menu, and click **Validate and deploy** to start the deployment process
1. Monitor the deployment progress on the resulting page.

> **Note:** Project is now going to deploy the full infrasutructure stack to support the application, including deployment of observability capabilities to monitor the application, watsonx.ai to provide the AI capabilities, and the application itself.

## Business Value Delivered

This approach delivers significant business value:
- End users can deploy the AI application with its dependencies in just a few clicks
- The automation blueprint handles all the complex wiring between components
- Platform teams can maintain governance while enabling developer self-service
- The solution includes enterprise-grade security with Key Protect integration
- Observability is built in for monitoring and troubleshooting

---

▶️ **Next:** [Final Review and Cleanup](./07-final-review-cleanup.md)

