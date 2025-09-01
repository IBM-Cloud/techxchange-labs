# Conclusion

Code Engine was developed by IBM with the goal of helping you create modern, source-centric, containerized, and serverless apps and jobs. The platform is designed to address the needs of developers who just want their code to run. Code Engine abstracts the operational burden of building, deploying, and managing workloads in Kubernetes so that developers can focus on what matters most to them: the source code.

## Capabilities

Code Engine provides the following capabilities to run your workloads.

| Capability | Description |
| --------- | ------------------- |
| Runs your workloads | Code Engine runs your HTTP-driven applications and your run-to-completion batch jobs.  |
| Fully managed service | Code Engine takes care of all the cluster management, including provisioning, configuring, scaling, and managing servers so you do not need to worry about the underlying infrastructure.  |
| Builds your code | Code Engine pulls your source code and creates the container image for you. Code Engine supports both Dockerfile and Cloud Native Buildpack. |
| Private workloads | Store your source code in private repositories and push your images to private registries and Code Engine can access them. |
| Fully integrated | Code Engine is fully integrated into IBM Cloud so that you can take advantage of the full catalog of IBM Cloud services. |
| Event-driven workloads | Extend the functionality of your applications with messages (events) from event producers. Your application can then react to those events and perform actions based on them. |
| Autoscales - even to zero | Code Engine automatically scales your workloads up and down, and even down to zero when no requests are active. You pay for only the resources that you consume. |
| Control access | Assign platform and services access permissions to your projects in IBM Cloud Identity and Access Management to control who can provision and manage resources in your IBM Cloud account. |
| Based on open source | Code Engine is built on a set of open source technologies such as Kubernetes, Knative, Istio, and Tekton, keeping your apps and jobs portable. |
| DDoS protection | Code Engine provides out-of-the-box DDoS protection for your application. Code Engine's DDoS protection is provided by Cloud Internet Services (CIS) at no additional cost to you. DDoS protection covers System Interconnection (OSI) Layer 3 and Layer 4 (TCP/IP) protocol attacks, but not Layer 7 (HTTP) attacks. See [DDoS protection](/docs/codeengine?topic=codeengine-secure#secure-ddos). |

To learn more about Code Engine workloads, see [Application workloads](https://cloud.ibm.com/docs/codeengine?topic=codeengine-ceapplications), [Batch job workloads](https://cloud.ibm.com/docs/codeengine?topic=codeengine-cebatchjobs), and [Function workloads](https://cloud.ibm.com/docs/codeengine?topic=codeengine-cefunctions).

## (Optional) Cleanup 🧹

1. Go to the list of projects at https://cloud.ibm.com/containers/serverless/projects
1. Delete your project by clicking on the Delete icon 🗑 showing on the right of the project.

   ?> Deleting your project also deletes all contained entities including apps and jobs as well as associated image builds, secrets, and configmaps.
   <br><br>
   When you delete a project, the project remains restorable for 7 days and then it is automatically and permanently deleted. You can manually delete restorable projects at any time. You can restore projects before they are automatically deleted. You cannot create a project with the same name in the same region until the restorable project no longer exists.”
1. Go to the Container Registry at https://cloud.ibm.com/registry/images and delete the image named after your username.