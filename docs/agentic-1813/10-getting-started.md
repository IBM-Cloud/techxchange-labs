# Lab Overview and Objectives

## Your Role: Platform Engineer

In this hands-on lab, you'll step into the role of a **platform engineer** tasked with creating automation that deploys the full infrastructure to run agentic AI applications. Your organization needs standardized, secure, and reusable infrastructure patterns that development teams can leverage without requiring deep infrastructure knowledge.

You'll work with a concrete example: the **[Loan Risk AI Agents sample application](https://github.com/IBM/ai-agent-for-loan-risk)** - a realistic AI-powered banking application that simulates loan processing workflows using intelligent agents to evaluate risk and determine interest rates. Your task is to build automation that can securely build, deploy, and run this application in a reliable, observable, and compliant manner. While this specific application serves as your automation target, the infrastructure patterns and techniques you'll develop apply universally to any modern application your organization needs to deploy, whether it's web applications, APIs, microservices, or other AI workloads.

## Platform Engineering Challenge

As a platform engineer, you're tasked with balancing multiple organizational needs: creating reusable automation that doesn't require deep infrastructure expertise, ensuring workloads meet security and compliance requirements, providing no-code deployment options for self-service capabilities, and maintaining governance with enterprise-grade patterns that scale. This lab teaches practical approaches to address these challenges through infrastructure automation.

## Infrastructure as Code with Deployable Architectures

Modern platform engineering relies on **Infrastructure as Code (IaC)** to create consistent, repeatable deployments. IBM Cloud takes this further with **[deployable architectures](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-understand-module-da#what-is-da)** - pre-validated infrastructure patterns that combine Terraform automation with governance, compliance, and no-code deployment capabilities.

Think of deployable architectures as "infrastructure blueprints" that package your Terraform code along with input validation, security scanning, and user-friendly interfaces. This transforms complex infrastructure automation into deployable solutions that any team member can use through a simple web interface. IBM provides a comprehensive library of [pre-built deployable architectures](https://cloud.ibm.com/catalog?category=solution&provider=IBM) that you'll leverage in this lab, including:

- [Cloud automation for Observability](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-observability-a3137d28-79e0-479d-8a24-758ebd5a0eab-global) for enterprise security and monitoring
- [Cloud foundation for AI ops and governance with watsonx](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-watsonx-ai-saas-e8ad6597-8c1a-466a-8bb7-243a109daaa8-global) for AI model services
- [Cloud Automation for Key Protect](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/deploy-arch-ibm-kms-2cad4789-fa90-4886-9c9e-857081c273ee-global) for encryption key management

> 💡 **Tip:** Deployable architectures bridge the gap between complex infrastructure code and user-friendly deployment experiences, enabling both technical and non-technical team members to deploy infrastructure consistently.

This lab demonstrates **two complementary approaches** to creating these deployable architectures:

### 1. High-Code Approach: Custom Terraform Development

You'll build infrastructure automation to deploy the Loan Risk AI Agents sample application by writing custom Terraform configurations using pre-built [terraform-ibm-modules](https://github.com/terraform-ibm-modules), creating Code Engine deployment with container build automation, integrating security patterns with secrets management, and testing and validating the infrastructure locally. **This Terraform automation then gets packaged into your own custom deployable architecture** and published to [private catalog](https://cloud.ibm.com/docs/account?topic=account-restrict-by-user) for organizational reuse.

### 2. Low-Code Approach: Composing Existing Solutions

You'll extend your custom deployable architecture with additional capabilities by combining your packaged solution with existing deployable architectures from the [IBM Cloud catalog](https://cloud.ibm.com/catalog?category=solution), integrating watsonx.ai services for AI model inference and governance, adding security and observability services for enterprise compliance, configuring multiple deployable architectures together using [IBM Cloud Projects](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-setup-project), and creating a complete solution package ready for development teams.

Both approaches serve different needs in your platform engineering toolkit and can be used together to create comprehensive solutions.

## Lab Workflow and Learning Objectives

Throughout this lab, you'll follow a realistic platform engineering workflow:

1. **Develop and Test**: Create Terraform configurations using [terraform-ibm-modules](https://github.com/terraform-ibm-modules)
2. **Validate Infrastructure**: Ensure the infrastructure works as expected before publishing
3. **Publish to Catalog**: Make reusable deployable architectures available organization-wide
4. **Test Deployment Experience**: Validate the catalog-based deployment workflow
5. **Compose Solutions**: Integrate with other deployable architectures to create complete stacks
6. **Package for Distribution**: Create ready-to-use solution bundles for development teams

By the end of this lab, you'll have mastered both high-code and low-code approaches to platform engineering, enabling you to scale infrastructure deployment across your organization effectively.

---

▶️ **Next:** [Prerequisites and Setup Requirements](./01-prerequisites-and-setup.md)
