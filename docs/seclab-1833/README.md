# Monitor and safeguard the security and compliance posture of generative and agentic AI workloads

Securing AI workloads means hardening their posture through policy, control, runtime monitoring and real-time detection. It starts with full visibility into all AI components, especially unsanctioned “shadow AI” deployments, and extends to continuous risk management. A layered approach that combines visibility, posture management and behavioral detection serves as the foundation for securing AI on IBM Cloud.

Security and Compliance Center Workload Protection (SCC+WP) provides organizations visibility into policy-driven posture enforcement and real-time threat detection. Users can easily identify vulnerabilities, check compliance, block runtime threats, and respond to incidents. In this lab we will do exercises on a smaller subset of features in SCC+WP that focus on AI workloads.

In the IBM Cloud account used in this lab, we have the following resources pre-provisioned:
- One virtual server instance (name: ai-workload-vsi)
- One RedHat OpenShift (Kubernetes) cluster (name: ai-workload-in-toronto)
- One Security and Compliance Center Workload Protection (SCC+WP) instance (name: SCC-WP-Instance)

Also,
- AI workload is deployed and running on the virtual server instance and the cluster 
- SCC+WP routinely scans the account, collects and reports data

Above resources are shared by all students. Students should complete the exercises in this lab-guide to build a basic understanding of SCC+WP and its capabilities for enforcing security and compliance for AI workloads.


<!--
⇨ [It's time to jump right in!](10-getting-started.md)
-->
