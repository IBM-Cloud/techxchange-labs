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


### Add Watsonx.ai SaaS DA

In this step, we’ll add the `Cloud foundation for AI ops and governance with watsonx` Deployment Architecture from the public IBM Cloud Catalog. This will serve as the foundation for our AI sample application.

1. Navigate to the **Catalog** via the top menu, or go directly to the [Catalog page](https://cloud.ibm.com/catalog).
1. In the Catalog search bar, type `Cloud foundation for AI ops and governance with watsonx` and select it from the results.
1. Review the features and capabilities, and choose the product version `v1.9.38`.
1. Select the checkbox labeled `I have read and agree to the following license agreements` and click the **Configure and deploy** button.
1. Since you already have a project, make sure **Add to existing** in the left-hand menu is selected, then choose the `<your-initials>-txc-project` project from the dropdown list.
1. Change the configuration name to `watsonx-ai-saas-demo`, then click **Add**.


### Add your custom Code Engine DA

1. Navigate to the **Catalog** via the top menu, or go directly to the [Catalog page](https://cloud.ibm.com/catalog).
1. In the Catalog search bar, type `Loan Risk Evaluation with Watsonx AI Agents` and select it from the results.
1. Choose the correct version of the deployment architecture, then click **Configure and deploy** to proceed.
1. Make sure **Add to existing** is selected from the left menu.  Then, choose `<your-initials>-txc-project` from the dropdown. Update the configuration name if needed — in this case, we'll use `agentic-ai-demo`.
1. Click **Add** to continue.


## Step 2: Share the full solution as a stack

Now package the entire stack as a reusable solution for application teams:

### Create a Stack of Deployable Architectures

1. In the IBM Cloud console, click the **navigation menu (☰)** in the top-left corner, then select **Projects** from the menu - or go directly to [**Projects**](https://cloud.ibm.com/projects).
1. Type `<your-initials>-txc-project` in the search bar and click the matching result.
1. Navigate to the **Configuration** tab.
1. Click the checkbox next to the **Name** column header in the table to select all configurations.
1. In the newly opened bar above, click on **Stack** to start the process.
1. Enter the name `txc-stack-demo` in the field and click **Continue**.
1. On the new page, you can expose inputs from each **Deployment Architecture (DA)** as **global input variables**. This allows values to be shared across multiple DAs.  
For example, we'll expose a global input variable named **`prefix`**, which can be reused by all DAs as well as in any inputs that reference other DAs — such as **`watsonx_project_id`**.  
To do this:
   - Click on **agentic-ai-demo**, then go to **Required inputs**, and select **Stack level** for the `prefix` and `watsonx_project_id` input variables.
   - Click on **watsonx-ai-saas-demo**, then navigate to **Required inputs** and set `resource_group_name` to **Stack level**.  
     Next, go to **Optional inputs** and set `resource_prefix` to **Stack level** as well.
1. Click on **Review** in the left-hand navigation menu, and then click **Finish**.

### Set Stack-Level Variables

On the new page, you need to define the required **stack-level inputs**, as they are shared across all Deployment Architectures (DAs).

1. First, click the **Edit** for **Security** section to show the **ibmcloud_api_key** field.
1. Enter your API key value and click **Done**.
1. Next, click the **Edit** for **Inputs** section to show the **prefix**, **watsonx_project_id** and **resource_group_name** input fields.
1. Click the cross (✕) icon on the `Not set` bubble next to the **prefix** input field.
1. Enter the value `<your-initials>-txc-stack`.
1. We will link an input of the **agentic-ai-demo** DA to an output from the **watsonx-ai-saas-demo** DA. To do this, hover over the **watsonx_project_id** input field and click **Add a reference**.
1. A new popup will open.
    - For **Source**, select `Configuration`.
    - For **Name**, choose your `watsonx-ai-saas-demo`.
    - Set **Category** to `Output`.
    - For **Property**, select `watsonx_project_id`.
    - Click **OK** to confirm the reference selection.
1. To enter a **resource group**, click `Edit` inside the `resource_group_name` input field, then enter the name of a new or existing resource group. In our case we will use `txc-watson-rg`.
1. Toggle the **Optional inputs** section to display the **resource_prefix** field. This field will be linked to **prefix**, ensuring a single shared prefix value between both DAs.
1. Hover over the **resource_prefix** input field and click on **Add a reference**. A new popup will open.
    - For **Source**, select `Configuration`.
    - For **Name**, choose your `txc-stack-demo` stack.
    - Set **Category** to `Input`.
    - For **Property**, select `prefix`.
    - Click **OK** to confirm the reference selection.
1. Click **Done**, and then **Save** to confirm


### Dependency Wiring Overview

Your components are now wired together with this dependency:

| Deployment architecture | Depends On            | Input Field          | Output Source                      |
|-------------------------|------------------------|----------------------|-----------------------------------|
| `agentic-ai-demo`       | `watsonx-ai-saas-demo` | `watsonx_project_id` | `watsonx-ai-saas-demo.watsonx_project_id` |


### Share a Stack of Deployable Architectures

1. To share the stack with others, go back to the Projects page and select your project named `<your-initials>-txc-project`.
1. Navigate to the **Configuration** tab to continue.
1. Open the **options menu (⋮)** on the configuration row for the `txc-stack-demo` stack and click **Add to private catalog**.
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

> ⚠️ **Warning**:  
> To deploy the stack, you need to set the **API key** under the **Security** section.  
> Since the Deployment Architectures (DAs) are now part of the stack, make sure to **re-wire the `watsonx_project_id` input**.  
> The reference is reset due to the change in hierarchy.


## Business Value Delivered

This approach delivers significant business value:
- End users can deploy the AI application with its watsonx.ai dependency in just a few clicks
- The automation blueprint handles all the complex wiring between components
- Platform teams can maintain governance while enabling developer self-service
- The solution can be extended with additional enterprise services (as shown in the bonus content)

---

▶️ **Next:** [Final Review and Cleanup](./07-final-review-cleanup.md)
