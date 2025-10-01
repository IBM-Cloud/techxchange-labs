
# Understanding Infrastructure Requirements

Modern applications require secure, scalable, and observable cloud infrastructure to enable intelligent behavior, autonomous decision-making, and seamless interaction. IBM Cloud offers a robust foundation for deploying any application workload, with integrated services that meet enterprise-grade standards for security, compliance, and operational visibility.

## Sample Application: Loan Risk AI Agents

The **Loan Risk AI Agents sample application** serves as our example workload, but **the infrastructure patterns you'll learn apply to any modern application** - web apps, APIs, microservices, or AI workloads.

The application simulates a **bank loan processing workflow** using AI agents to evaluate risk and determine interest rates. The source code is available at [https://github.com/IBM/ai-agent-for-loan-risk](https://github.com/IBM/ai-agent-for-loan-risk).

> 💡 **Key Insight:** While we use an AI application as our example, the infrastructure automation techniques you'll learn are universal and apply to any containerized application your organization needs to deploy.

This example demonstrates common application requirements:

- **Containerized deployment** with scalable compute
- **External service integration** (AI models, databases, APIs)  
- **Secure secret management** for credentials
- **Enterprise monitoring and logging**

## Infrastructure Architecture

The deployment architecture uses these core components:

**Technology Stack & Infrastructure Services:**
- **Application**: Built using [LangGraph](https://github.com/langchain-ai/langgraph) and TypeScript/Node.js
- **Compute**: [IBM Cloud Code Engine](https://cloud.ibm.com/docs/codeengine?topic=codeengine-getting-started) - serverless platform for containerized workloads
- **AI Services**: [watsonx.ai](https://dataplatform.cloud.ibm.com/docs/content/wsj/getting-started/welcome-main.html?context=wx&audience=wdp) - foundation models for natural language processing
- **Storage**: [Cloud Object Storage (COS)](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage) - unstructured data storage
- **Observability**: [Monitoring](https://www.ibm.com/products/cloud-monitoring), [Logging](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-about-cl), and [Activity Tracker](https://cloud.ibm.com/docs/atracker?topic=atracker-getting-started) services integrated with all components

![IaC deployment architecture](./images/IaC_diag.svg)
*Note: The diagram shows all services integrated with Code Engine, including Observability services*

## Security and Compliance

Enterprise applications require comprehensive security and compliance capabilities:

- **Encryption**: [Key Protect](https://cloud.ibm.com/docs/key-protect?topic=key-protect-about) and [Secrets Manager](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-getting-started) for secure key and secret management
- **Audit Logging**: [Activity Tracker](https://cloud.ibm.com/docs/atracker?topic=atracker-getting-started) provides detailed compliance records
- **Compliance Monitoring**: [Security and Compliance Center](https://cloud.ibm.com/docs/security-compliance?topic=security-compliance-getting-started) evaluates configurations against industry standards

---

▶️ **Next:** [Developing Custom Automation (High-Code Approach)](./04-deploying-sample-agentic-ai-application.md)
