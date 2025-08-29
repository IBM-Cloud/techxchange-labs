# AI Services Monitoring

**Learning Objectives:**
- Understand monitoring of Watson AI services in IBM Cloud using the IBM Cloud Observability suite

In this section, you'll learn how Watson AI services fit within the broader observability stack and how to monitor them effectively for any AI workload deployment.

## Watson AI Services Monitoring in an Enterprise Context

The Watsonx.ai SaaS with Assistant and Governance deployable architecture automates the deployment and setup of the IBM watsonx platform in your IBM Cloud account. This platform consists of several integrated services that provide AI capabilities to end users.

![](images/70-1.png ':size=800')

Monitoring Watson AI services alongside other components addresses several key challenges:

- **AI service performance**: Request processing, model inference timing, and resource utilization
- **Platform integration**: How AI services integrate with other services
- **Cross-service troubleshooting**: Correlating issues with underlying infrastructure and application problems
- **Operational visibility**: Monitoring lifecycle events


In this lab environment, the Watson AI components include:
- A Watson AI runtime instance: **rag-watson-machine-learning-instance**
- A Watson AI Studio instance: **rag-watson-studio-instance**
- A WatsonX Assistant instance: **rag-watsonx-assistant-instance**

![](images/70-2.png ':size=800')

## Monitoring Watson AI Services

You can monitor Watson AI services through:

- **IBM Cloud Logs**: Platform logs help investigate abnormal activity and troubleshoot problems. For more details, see [List of Watson AI services that generate platform logs](https://cloud.ibm.com/docs/logs-router?topic=logs-router-cloud_services#watson).

- **Activity Tracking**: Events that report activity on AI resources in IBM Cloud. For more details, see [Activity tracking events for Watson AI](https://cloud.ibm.com/docs/atracker?topic=atracker-cloud_services_atracker#watson_ai).

In this section, you'll focus on monitoring WatsonX Assistant, which lets you build conversational interfaces into applications, devices, or channels.

## Monitoring WatsonX Assistant Logs

WatsonX Assistant can log activity through webhooks when customers submit input. You can log:

- **Messages and responses**: Triggered when the assistant responds to customer input
- **Call detail records (CDRs)**: Triggered after each telephone call (for assistants using phone integration)

Follow these steps to search for WatsonX Assistant logs:

1. Navigate to **Menu icon > Observability > Logging > Instances > Cloud Logs**.

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

3. Apply these filters:
   - For **Application**, select **ibm-platform-logs**
   - For **Subsystems**, select entries that include **conversation:<InstanceID>** (in this lab, choose `conversation:e3ece125-d673-4702-a154-f5c8c2a3b817`)

You should see logs similar to this:

![](images/70-3.png ':size=800')

> **💡 TIP:** When monitoring AI assistant logs, look for patterns in user interactions that lead to failed responses. This can help identify gaps in your assistant's training that need to be addressed.

## Monitoring Watson Assistant Activity Tracking Events

Follow these steps to view activity events for Watson Assistant:

1. Navigate to **Menu icon > Observability > Logging > Instances > Cloud Logs**.

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

3. Apply these filters:
   - For **Application**, select **ibm-audit-event**
   - For **Subsystems**, select entries that include **conversation:<InstanceID>** (in this lab, choose `conversation:e3ece125-d673-4702-a154-f5c8c2a3b817`)

You can run targeted queries to monitor specific activities, such as which users made changes to the assistant or when critical configurations were modified.

> **💡 TIP:** For production AI systems, create views that track configuration changes to models and assistants. These are critical for both troubleshooting and compliance, as they help you understand when and why performance or behavior changes occurred.

For a complete list of available events, see [Activity tracking events watsonx Assistant](https://cloud.ibm.com/docs/watson-assistant?topic=watson-assistant-at-events).

3. Select the following filter options to view only Watson Assistance events:

    For the **Application**, select **ibm-audit-event**.

    For the **Subsystems**, select the entries that include **conversation:<InstanceID>**. In the lab, choose `conversation:e3ece125-d673-4702-a154-f5c8c2a3b817`.

You can monitor the activity reported by the service by running queries, for example, to narrow down the task or request that was made and by whom. For a full list of activity tracking actions, see [Activity tracking events watsonx Assistant](https://cloud.ibm.com/docs/watson-assistant?topic=watson-assistant-at-events).

⇨ [Continue to Conclusion](100-conclusion.md)
