# Publishing Your Automation to the Catalog

As a platform engineer, you've successfully developed and tested your Terraform automation locally. Now you're ready to **make this automation available to your organization** by publishing it as a deployable architecture in IBM Cloud's private catalog.

## Platform Engineering Value

Publishing your automation to a private catalog transforms your tested Terraform code into something much more powerful:

**No-Code Deployment**: Development teams can now deploy complex infrastructure without any Terraform knowledge, simply by filling out a form-based interface. This enables true self-service capabilities where teams can deploy infrastructure independently while following your established patterns.

**Shared Automation**: Your work becomes reusable across multiple teams and projects, while you maintain governance by controlling access and maintaining standards for infrastructure deployments across the organization.

> 💡 **Key Transition:** This step represents the transition from **custom development** (what you just completed) to **organizational distribution** (making it available for others).

## Testing the Full Workflow

In this section, you'll:

1. **Publish your automation** to the private catalog as a deployable architecture
2. **Test the deployable architecture** by deploying it through the catalog
3. **Validate the end-user experience** that development teams will have

You'll be testing the same infrastructure again, but this time through the deployable architecture interface. This dual-deployment validates both your Terraform code and the catalog-based user experience.

## Step 1: Create a private catalog

To organize and manage your deployable architectures, you'll first need to create a private catalog. A private catalog allows you to control access and curate the infrastructure components available within your organization.

1. In the IBM Cloud console, from the top navigation bar, click **Manage**, then select [**Catalogs**](https://cloud.ibm.com/content-mgmt/overview) from the dropdown menu
1. From the left-hand navigation menu, select **Private catalogs**
1. Click **Create** to add a new private catalog
1. Fill in the **Name** field with `txc-catalog` and select the `Default` **resource group**. Under Select a template, choose **No products for now** — you'll add a product in the next steps. Then, click **Create**

> 💡 **Tip:** You can always view your catalog by clicking **Manage** in the top navigation bar, selecting **Catalogs**, and then choosing **Private catalogs**.

## Step 2: Add your deployable architecture to the private catalog

After creating a new private catalog, you can onboard your deployable architecture. In this step, you'll add the **Loan Risk AI Agents sample application** to the catalog as a Terraform-based deployable architecture, making it available for deployment within IBM Cloud projects.

### Understanding the Catalog Metadata

When developing a custom Deployable Architecture (DA), the product repository must include an `ibm_catalog.json` file. This file provides the necessary metadata and input variable definitions required by IBM Cloud to correctly process and deploy the product. 

In a real-world scenario, this file would be created alongside your Terraform files in your source repository, and both would be packaged together during your CI/CD release process (e.g., GitHub releases, GitLab releases). The `ibm_catalog.json` would typically contain:

```json
{
  "products": [
    {
      "name": "ai-agent-for-loan-risk",
      "label": "Demo: TechXchange Custom IaC for Agentic AI",
      "product_kind": "solution",
      "tags": ["ai", "agentic", "code-engine", "terraform"],
      "keywords": ["ai", "agent", "loan", "risk", "code-engine"],
      "short_description": "Deploy an AI agent for loan risk assessment using IBM Cloud Code Engine",
      "long_description": "This deployable architecture demonstrates how to deploy an agentic AI application for loan risk assessment using IBM Cloud Code Engine, Terraform, and watsonx.ai services.",
      "provider_name": "IBM",
      "offering_docs_url": "https://github.com/IBM/ai-agent-for-loan-risk",
      "support_url": "https://github.com/IBM/ai-agent-for-loan-risk/issues",
      "flavors": [
        {
          "label": "Code Engine application",
          "name": "standard",
          "install_type": "fullstack",
          "working_directory": ".",
          "compliance": {},
          "iam_permissions": [
            {
              "role_crns": ["crn:v1:bluemix:public:iam::::role:Administrator"],
              "service_name": "codeengine"
            }
          ],
          "architecture": {
            "diagrams": [
              {
                "diagram": {
                  "url": "https://raw.githubusercontent.com/IBM/ai-agent-for-loan-risk/main/reference-architecture/IaC_diag.svg"
                },
                "description": "Architecture diagram showing the deployment of AI agent using Code Engine"
              }
            ]
          }
        }
      ]
    }
  ]
}
```

> 📝 **Note:** For this lab, you don't need to create this file manually. The provided package already contains both the Terraform configuration you built in the previous section and the required `ibm_catalog.json` metadata file. For more information about the catalog schema, refer to the [IBM Cloud Catalog schema documentation](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-manifest-values).

### Adding the Product to Your Catalog

Now add the product to your catalog:

1. Go to the [private catalog page](https://cloud.ibm.com/content-mgmt/catalogs) and select catalog named `txc-catalog`.
1. Once inside, click **Add product** to begin adding your customized deployable architecture (DA).
1. Choose **Deployable architecture** as the product type, and select **Terraform** as the delivery method
1. Choose **Public repository** (if using a private repo, ensure the system has access via credentials or IBM Cloud Secrets Manager)
1. In the **Source URL** field, enter: `https://github.com/IBM/ai-agent-for-loan-risk/archive/refs/heads/main.tar.gz`

> 💡 **Package Contents:** This tar.gz file contains the complete Terraform automation you built in the previous section, along with the required `ibm_catalog.json` metadata file. In a real-world scenario, this package would typically be generated by your source control release process (e.g., [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) or [GitLab releases](https://docs.gitlab.com/ee/user/project/releases/)), but for this lab we provide a pre-built package to simplify the process.

6. Choose the **variation** `Code Engine application`, and set the **Software version** to `1.0.0`
7. Click **Add product** to complete the process
8. Click on the **Step 3 - Configure the deployment** tab, then click **Import input variables** to add all inputs to your deployment architecture

## Step 3: Make the deployable architecture available

After the product is added to a catalog, its version is initially in a draft state. To make it available for deployment, you'll set it to **pre-release** status.

To access your product version:

1. Go to the [private catalog page](https://cloud.ibm.com/content-mgmt/catalogs) and select catalog named `txc-catalog`.
1. On the new page, in the **Products** table, click on our deployable architecture (DA) - `Demo: TechXchange Custom IaC for Agentic AI`.

To make the deployable architecture available:

1. Go to **Versions** in the left navigation panel
1. Click the **option menu (⋮)** next to the draft version and select **Set as pre-release**
1. Follow the prompts to make the version available for deployment

Your deployable architecture is now available in the catalog for no-code deployment by other users.

## Platform Engineering Milestone

Congratulations! You've successfully completed the **high-code approach** to creating deployable architectures. You have:

- **Developed custom Terraform automation** using terraform-ibm-modules
- **Tested the automation locally** to ensure reliability
- **Published to your organization's catalog** for reuse
- **Made complex infrastructure accessible** via no-code deployment

## What's Next: Low-Code Approach

Now you'll learn the **second approach** to building comprehensive solutions: the **low-code approach**. Instead of writing Terraform code, you'll compose existing deployable architectures from IBM Cloud's catalog to create integrated solution stacks.

This demonstrates how platform engineers can combine both approaches:

- **High-code** for custom components (like your AI application)
- **Low-code** for integrating with established services (like watsonx.ai and security services)

Together, these approaches enable you to create comprehensive platform solutions efficiently.

---

▶️ **Next:** [Complete Solution Stack with Low-Code Composition](./06-advanced-security-and-monitoring.md)
