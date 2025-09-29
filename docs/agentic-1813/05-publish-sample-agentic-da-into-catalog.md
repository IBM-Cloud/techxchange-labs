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
1. Fill in the **Name** field with `<your-initials>-txc-catalog` and select the `Default` **resource group**. Under Select a template, choose **No products for now** — you'll add a product in the next steps. Then, click **Create**

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
      "name": "deploy-arch-ibm-ai-agent-code-engine",
      "label": "Loan Risk Evaluation with Watsonx AI Agents",
      "product_kind": "solution",
      "tags": [
        "ibm_created",
        "integration",
        "terraform",
        "solution"
      ],
      "keywords": [
        "code engine",
        "IaC",
        "infrastructure as code",
        "terraform",
        "solution",
        "agentic ai",
        "watsonx",
        "loan risk"
      ],
      "short_description": "Provisions the Loan Risk AI Agents sample application on IBM Cloud Code Engine using a serverless architecture",
      "long_description": "Configures a serverless IBM Cloud Code Engine project to deploy the Loan Risk AI Agents sample application designed as a proof of concept (PoC) for adopting agentic AI in enterprise workflows.\n\nThe application showcases a bank loan processing workflow in the financial industry, demonstrating how LLMs can drive reasoning and actions—moving beyond traditional rule-based approaches. It uses IBM Cloud services including watsonx.ai for inferencing and retrieval-augmented generation (RAG), and watsonx Assistant/Orchestrate for conversational interactions.",
      "offering_docs_url": "https://github.com/IBM/agentic-iac-lab-materials/blob/main/agentic-solution/README.md",
      "features": [
        {
          "title": "Automated provisioning with Terraform",
          "description": "Uses Infrastructure as Code (IaC) to provision all required IBM Cloud resources, including [Code Engine](https://www.ibm.com/products/code-engine), [Container Registry](https://www.ibm.com/products/container-registry), and associated configurations—ensuring consistency and repeatability."
        },
        {
          "title": "End-to-end deployment of Loan Risk AI Agents",
          "description": "Deploys a complete [agentic AI sample application](https://github.com/IBM/ai-agent-for-loan-risk) that demonstrates LLM-based decision-making for loan processing workflows using watsonx.ai and watsonx Assistant."
        },
        {
          "title": "Secure API key and secret management",
          "description": "Creates [Code Engine secrets](https://cloud.ibm.com/docs/codeengine?topic=codeengine-secret) to securely store sensitive information such as IBM Cloud API keys and registry credentials, used during the container build and deployment process."
        },
        {
          "title": "Source-to-image build pipeline",
          "description": "Builds container images directly from source code using Code Engine’s integrated build feature, and pushes the image to IBM Cloud Container Registry."
        }
      ],
      "flavors": [
        {
          "label": "Code Engine Application",
          "name": "ce-ai-application",
          "working_directory": "agentic-solution",
          "licenses": [],
          "compliance": {},
          "iam_permissions": [
            {
              "role_crns": [
                "crn:v1:bluemix:public:iam::::role:Viewer"
              ],
              "service_name": "Resource group only",
              "notes": "Viewer access is required in the resource group you want to provision in."
            },
            {
              "role_crns": [
                "crn:v1:bluemix:public:iam::::serviceRole:Writer",
                "crn:v1:bluemix:public:iam::::role:Editor"
              ],
              "service_name": "codeengine",
              "notes": "Required to create and manage Code Engine resources."
            },
            {
              "role_crns": [
                "crn:v1:bluemix:public:iam::::serviceRole:Writer",
                "crn:v1:bluemix:public:iam::::role:Editor"
              ],
              "service_name": "container-registry",
              "notes": "Required to create and manage Container Registry namespaces."
            }
          ],
          "architecture": {
            "features": [
              {
                "title": " ",
                "description": "Ideal for users deploying the Loan Risk AI Agents app on Code Engine without managing infrastructure."
              },
              {
                "title": " ",
                "description": "Uses Terraform to automate setup of projects, secrets, builds, and AI service integration."
              },
              {
                "title": " ",
                "description": "Runs a loan risk analysis app using watsonx.ai, Assistant, RAG, and orchestration logic."
              }
            ],
            "diagrams": [
              {
                "diagram": {
                  "url": "https://raw.github.com/IBM/agentic-iac-lab-materials/refs/heads/main/agentic-solution/reference-architecture/ce-app-da.svg",
                  "caption": "IBM Cloud Code Engine application solution.",
                  "type": "image/svg+xml"
                },
                "description": "The architecture of this solution uses Terraform to provision IBM Cloud resources, enabling deployment of the Loan Risk AI Agents application on Code Engine, with container builds pushed to Container Registry and managed secrets for authentication."
              }
            ]
          },
          "configuration": [
            [
              {
                "key": "ibmcloud_api_key"
              },
              {
                "key": "watsonx_ai_api_key"
              },
              {
                "key": "container_registry_api_key"
              },
              {
                "key": "watsonx_project_id",
                "type": "string",
                "description": "Watsonx project ID.",
                "required": true
              },
              {
                "key": "prefix"
              }
            ]
          ],
          "install_type": "fullstack",
          "terraform_version": "1.10.0"
        }
      ]
    }
  ]
}
```

> 📝 **Note:** For this lab, you don't need to create this file manually. [The provided package](https://github.com/IBM/agentic-iac-lab-materials/releases/tag/v1.0.0) already contains both the Terraform configuration you built in the previous section and the required [`ibm_catalog.json`](https://github.com/IBM/agentic-iac-lab-materials/blob/main/ibm_catalog.json) metadata file. For more information about the catalog schema, refer to the [IBM Cloud Catalog schema documentation](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-manifest-values).

### Adding the Product to Your Catalog

Now add the product to your catalog:

1. Go to the [private catalog page](https://cloud.ibm.com/content-mgmt/catalogs) and select the catalog named `<your-initials>-txc-catalog`
1. Once inside, click **Add product** to begin adding your customized deployable architecture (DA)
1. Choose **Deployable architecture** as the product type, and select **Terraform** as the delivery method
1. Choose **Public repository** (if using a private repo, ensure the system has access via credentials or IBM Cloud Secrets Manager)
1. In the **Source URL** field, enter: `https://github.com/IBM/agentic-iac-lab-materials/archive/refs/tags/v1.0.0.tar.gz`

> 💡 **Package Contents:** This tar.gz file contains the complete Terraform automation you built in the previous section, along with the required `ibm_catalog.json` metadata file. In a real-world scenario, this package would typically be generated by your source control release process (e.g., [GitHub releases](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) or [GitLab releases](https://docs.gitlab.com/ee/user/project/releases/)), but for this lab we provide a pre-built package to simplify the process.

6. Choose the **variation** `Code Engine application`, and set the **Software version** to `1.0.0`
7. Click **Add product** to complete the process
8. On the new screen, click **Versions** in the left-hand menu.
9. In the table, click on your version labeled `1.0.0`.
10. In the **Configure version** section, click the **Step 3 - Configure the deployment** tab, then click **Import input variables** to add all inputs (e.g., `ibmcloud_api_key`, `watsonx_ai_api_key`, `watsonx_project_id`, `prefix`, `container_registry_api_key`) to your deployment architecture

## Step 3: Make the deployable architecture available

After the product is added to a catalog, its version is initially in a draft state. To make it available for deployment, you'll set it to **pre-release** status.

To access your product version:

1. Go to the [private catalog page](https://cloud.ibm.com/content-mgmt/catalogs) and select the catalog named `<your-initials>-txc-catalog`
1. On the new page, in the **Products** table, click on our deployable architecture (DA) - `Loan Risk Evaluation with Watsonx AI Agents`

To make the deployable architecture available:

1. Go to **Versions** in the left navigation panel
1. Click the **option menu (⋮)** next to the draft version and select **Ready to pre-release**
1. Follow the prompts to make the version available for deployment

Your deployable architecture is now available in the catalog for no-code deployment by other users.

## Step 4: Find your deployable architecture in the IBM Cloud Catalog

To verify that your deployable architecture has been successfully added:

1. Go to the [IBM Cloud Catalog](https://cloud.ibm.com/catalog)
1. Use the search bar and type: `Loan Risk Evaluation with Watsonx AI Agents`
1. Once it appears in the results, **click on the deployable architecture**.
1. From there, you can **review the details and deploy it directly** from the catalog.

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
