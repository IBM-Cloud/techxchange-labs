# Monitoring Observability services

In IBM Cloud, you'll find these key Observability services:

- **[IBM Cloud Logs](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-getting-started)**: Scalable logging service for real-time insights on IBM Cloud services, infrastructure, and applications
- **[IBM Cloud Activity Tracker Event Routing](https://cloud.ibm.com/docs/atracker?topic=atracker-getting-started)**: Configures routing of audit events in your IBM Cloud account
- **[IBM Cloud Logs Routing](https://cloud.ibm.com/docs/logs-router?topic=logs-router-getting-started)**: Configures routing of platform logs from IBM Cloud services
- **[IBM Cloud Metrics Routing](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-getting-started)**: Configures routing of platform metrics from IBM Cloud services
- **[IBM Cloud Monitoring](https://cloud.ibm.com/docs/monitoring?topic=monitoring-getting-started)**: Cloud-native monitoring system for full-stack telemetry

> **💡 TIP:** When working with these services in your own environments, establish a consistent naming convention for instances. This makes it much easier to identify related resources across a complex architecture.


## Observability Architecture Overview

The RAG Pattern deployable architecture demonstrates a comprehensive observability stack that showcases enterprise-level monitoring architecture. By examining this deployment, you'll understand how to design and validate observability solutions for any complex infrastructure.

As part of the deployment, the **Essential Security - Logging Monitoring Activity Tracker** component is deployed. This component creates a fully integrated observability stack with the following elements:

![Observability architecture overview](images/setup.png ':size=800')

### Data Storage Layer
[Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-getting-started-cloud-object-storage) instance **rag-observability-cos** with three specialized buckets:

- **rag-at-events-cos-bucket-xxxx**: Stores all auditing events for compliance
- **rag-cloud-logs-data-bucket-xxxx**: Attached to IBM Cloud Logs for account platform data collection
- **rag-cloud-logs-metrics-bucket-xxxx**: Attached to IBM Cloud Logs for metrics generated from collected logs

### Core Observability Services

- **[IBM Cloud Logs](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-getting-started)** instance: **rag-cloud-logs** - Centralized log management and analysis
- **[IBM Cloud Monitoring](https://cloud.ibm.com/docs/monitoring?topic=monitoring-getting-started)** instance: **rag-cloud-monitoring** - Real-time metrics and monitoring

### Data Routing and Flow

- **[Activity Tracker Event Routing](https://cloud.ibm.com/docs/atracker?topic=atracker-getting-started)** configuration with targets to Cloud Logs and COS storage
- **[Metrics Routing](https://cloud.ibm.com/docs/metrics-router?topic=metrics-router-getting-started)** configuration sending platform metrics to the Monitoring instance
- **[Logs Routing](https://cloud.ibm.com/docs/logs-router?topic=logs-router-getting-started)** configuration sending platform logs to the Cloud Logs instance

### Security and Authorization Layer
Service-to-service authentication configurations allowing communication between services

> **💡 TIP:** Understanding these components and their relationships is crucial for troubleshooting observability issues in your own environments. Pay special attention to the authorization patterns as they're often the source of integration problems.

<details>
<summary>📋 Detailed Resource Checklist (Expand for Reference)</summary>

**Data Storage Layer:**
- [ ] Creates a Cloud Object Storage instance **rag-observability-cos**.
  - [ ] Creates the bucket **rag-at-events-cos-bucket-xxxx** to send all auditing events for compliance.
  - [ ] Creates the bucket **rag-cloud-logs-data-bucket-xxxx** that is attached to the IBM Cloud Logs instance and collects the account platform data that you can use to monitor the environment.
  - [ ] Creates the bucket **rag-cloud-logs-metrics-bucket-xxxx** that is attached to the IBM Cloud Logs instance and collects metrics that are generated from the logs that are collected.

**Core Observability Services:**
- [ ] Configures an instance of IBM Cloud Logs. The name of the instance is **rag-cloud-logs**.
- [ ] Configures an instance of IBM Cloud Monitoring. The name of the instance is **rag-cloud-monitoring**.

**Data Routing and Flow:**
- [ ] Configures IBM Cloud Activity Tracker Event Routing in the account.
  - [ ] Creates a target (destination) to the Cloud Logs instance **rag-cloud-logs**, and a route that sends all auditing events that are generated in the account to the instance.
  - [ ] Creates a target (destination) to the bucket **rag-cos-target**
- [ ] Configures IBM Cloud Metrics Routing in the account. Creates a target to the Monitoring instance **rag-cloud-monitoring**, and a route that sends all platform metrics that are genereated in the account to the instance.

**Security and Authorization Layer:**
- [ ] Creates IAM authorizations by using the service ID that you configure in the DA initial configuration.
  - [ ] Authorization with **Sender** role to allow the Activity Tracker Event Routing service to send data to the Cloud Logs instance *rag-cloud-logs*.
  - [ ] Authorization with **Object Writer** role to allow the Activity Tracker Event Routing to upload objects to the COS bucket *rag-at-events-cos-bucket-xxxx*.
  - [ ] Authorization with **Writer** role to allow the IBM Cloud Logs instance *rag-cloud-logs* to upload objects to the bucket *rag-cloud-logs-data-bucket-xxxx.
  - [ ] Authorization with **Writer** role to allow the IBM Cloud Logs instance *rag-cloud-logs* to upload objects to the bucket *rag-cloud-logs-metrics-bucket-xxxx.
  - [ ] Authorization with **Event Source Manager, Viewer, and Reader** roles to allow the IBM Cloud Logs instance *rag-cloud-logs* to send event notifications to the IBM Cloud Event Notifications service instance *rag-base-event-notifications*. The *rag-base-event-notifications* instance is created through the *Essential Security - Event Notifications* component.
- [ ] Creates an outbound integration in the Cloud Logs instance **rag-cloud-logs** to connect the Cloud Logs instance with the Event Notifications instance *rag-base-event-notifications*.

</details>


## Understanding Platform Monitoring Architecture

Platform monitoring in IBM Cloud follows a layered approach:

- `Data layer`: Focuses on the data that is generated by IBM Cloud services.

    - **Metrics data**: Each IBM Cloud service exposes operational metrics for monitoring on performance and health
    - **Activity tracking events**: Each IBM Cloud service exposes activity tracking events for monitoring infrastructure, security and compliance
    - **Logs data**: Each IBM Cloud service exposes operational logs for monitoring infrastructure, services and applications

- `Data Routing layer`: Focuses on the collection and routing of the data that is generated in the data layer by IBM Cloud services to your custom destinations.

    - **Metrics data**: The Metrics Routing service delivers platform metrics to Monitoring instances
    - **Logs data**: The Logs Routing service delivers platform logs to Cloud Logs instances
    - **Activity tracking events**: The Activity Tracker Event routing service delivers audit events to Cloud Logs instances

- `Data Visualization, analysis and alerting layer`: Focuses on the management of the data for troubleshooting, compliance and alerting.

    - **User-layer Visualization**: Visualization of metrics, logs, and activity tracking events through dashboards and views
    - **User-layer Alerting**: Alerting layer that transforms raw metrics, logs, and/or activity tracking events into actionable insights
    - **Cross-service correlation**: Ability to correlate events and metrics across multiple services

This approach ensures you can monitor everything from individual service performance to overall system health.

> **💡 TIP:** When troubleshooting complex issues, work backwards through this layered approach. First check if dashboards and views show the expected data, then verify the routing services are working, and finally confirm that services are generating the expected telemetry data.




⇨ [Continue to Validating Observability Resources](20-validate-observability-resources.md)
