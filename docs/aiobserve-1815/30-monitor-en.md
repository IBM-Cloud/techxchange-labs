# Monitoring IBM Cloud Event Notifications Service Health


**Learning Objectives:**

- Understand how IBM Cloud services integrate with Event Notifications
- Explore data flow patterns between Activity Tracker, Metrics Routing, and monitoring services


In this section, you'll explore how to monitor IBM Cloud Event Notifications focusing on the integration between IBM Cloud Logs and IBM Cloud Event Notifications.

> **📋 Why This Matters:** Event Notifications is the critical service that delivers alerts from your monitoring systems to your operations teams. If Event Notifications fails, you won't receive alerts about system issues, creating operational blind spots that could lead to prolonged outages.

## About IBM Cloud Event Notifications

IBM Cloud Event Notifications is a routing service that provides information about critical events that occur in your IBM Cloud account or triggers automated actions by using webhooks. You can filter and route event notifications from IBM Cloud services like monitoring, to communication channels like email, SMS, and webhooks. For mroe information, see [What is Event Notifications?](https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-en-about).

You can integrate IBM Cloud Event Notifications with any of the following services that are deployed in the DA that is used through the lab:
- IBM Cloud Logs
- IBM Cloud Monitoring
- Security and Compliance
- Secrets Manager
- App Configuration
- IBM Cloud Projects
- Toolchain
- watsonx.data


## Understanding the integration between IBM Cloud Logs and IBM Cloud Event Notifications

In IBM Cloud Logs, you configure alerts that define the triggering conditions on filtered data on which you want to be notified. In IBM Cloud Event Notifications, you configure the destinations where you want to be notified for an alert and the conditions that define to which destination an event is routed. You can route events to one or more destinations based on conditions that you configure. You can notify to a service destination such as a webhook or PagerDuty, or to a human destination such as email or slack.

![Alerting in IBM Cloud Logs](images/30-51.png ':size=800')

When configuring alerts, you must differentiate three distinct layers:
- **Condition layer - IBM Cloud Logs**: Configures alerts based on filtered data and triggering conditions
- **Destination layer - Event Notifications**: Defines destinations (email, Slack, PagerDuty, webhooks) and routing rules
- **Notification layer -  Event Notifications (Delivery)**: Routes events to appropriate destinations

Topics are based on a publish and subscription model. The topic subscribes to event data based on conditions that you configure. The Event Notifications service handles the routing and delivering of alerts reliably to the correct destinations based on the subscriptions that you configure. The Cloud Logs service handles the triggering conditions based on the data.

> **💡 TIP:** You can monitor across the 3 layers by monitoring the logs and activity tracking events that are sent by the Event Notifications service. Activity tracking events provide information on the event trigered in Cloud Logs. Event Notification logs report on the success delivering the event to the destinations.

![Relationship of components that are required for alerting](images/30-50.png ':size=800')


## Monitoring Event Notifications

You can monitor IBM Cloud Event Notifications using multiple IBM Cloud services:

- **IBM Cloud Logs**:

    - Monitor platform logs for operational activities and troubleshooting For more information, see [Logging for Event Notifications](https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-logging).
    - Track activity events for administrative actions. For more information, see [Activity tracking events for Event notifications](https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-at_events).

- **IBM Cloud Monitoring**:

    - Monitor health and performance through platform metrics
    - Use predefined dashboards for comprehensive visibility

    For more details, see [Event Notifications Metrics](https://cloud.ibm.com/docs/event-notifications?topic=event-notifications-monitoring).

    > **💡 TIP: Monitoring across services deployed in the DA**  Multiple services can integrate with IBM Cloud Event Notifications. You can create a dashboard in IBM Cloud Monitoring to display the health and status of multiple critical services alongside Event Notifications metrics. This dashboard would provide a single view that you could use to verify that alerts are working properly across your core infrastructure services.


## Monitoring IBM Cloud Event Notifications through IBM Cloud Monitoring


IBM Cloud Monitoring provides the **Event Notifications** dashboard, which contains pre-defined panels monitoring various aspects.

Follow these steps to access this predefined dashboard:

1. Navigate to **Menu icon > Observability > Monitoring > Instances**.

2. For the **rag-cloud-monitoring** instance, click **Dashboard**, then **Dashboards > IBM**.

3. Select the **Event Notifications** dashboard template.

    ![Event Notifications monitoring dashboard](images/30-23.png ':size=600')

4. Explore the dashboard to understand the different metrics available for monitoring your database.


When you monitor Event Notification, pay attention to the following widgets:
- **Notifications Sent to Destinations**: Shows successful delivery rates
- **Failed Notifications**: Indicates delivery issues that need attention
- **Destination Health**: Shows the status of configured endpoints

> **💡 Customization TIP:** Copy the predefined template and remove widgets for destinations you don't use to create a focused monitoring view.



## Monitoring IBM Cloud Event Notifications through IBM Cloud Logs

Follow these steps to search Event Notifications logs and activity tracking data:

1. Navigate to **Menu icon > Observability > Logging > Instances > Cloud Logs**.

    ![IBM Cloud UI](images/30-1-1.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

    ![IBM Cloud UI](images/30-1-2.png ':size=600')

3. To monitor activity tracking events, apply these filters:

   - For **Application**, select **ibm-audit-event**.
   - For **Subsystems**, select entries that include **event-notifications:<InstanceID>**

   ![IBM Cloud Logs UI](images/30-1-5.png ':size=600')

4. To monitor platform logs that you can use to investigate abnormal activity and troubleshoot problems when sending notifications to your destinations, apply these filters:

   - For **Application**, select **ibm-platform-logs**.
   - For **Subsystems**, select entries that include **event-notifications:<InstanceID>**

   ![IBM Cloud Logs UI](images/30-1-6.png ':size=600')

> **💡 TIP:** You can create custom views to monitor CRUD operations and configuration changes by monitoring activity tracking events. You can create custom views to monitor and track notification failures and delivery latencies by monitoring platform logs.

Follow these steps to view some sample dashboards that can help you monitor the Event Notifications service for your DA:

1. Navigate to **Menu icon > Observability > Logging > Instances**.

2. For the **rag-cloud-logs** instance, click **Dashboard**.

    ![IBM Cloud UI](images/30-1-1.png ':size=600')

3. Select **IBM Cloud Logs menu icon > Dashboards > Custom Dashboards**.

    ![](images/30-121.png ':size=600')

4. Explore the following dashboards:

    - **Event Notifications IBM Cloud Management Overview** dashboard to understand resource management patterns

        ![](images/30-123.png ':size=600')

    - **Event Notifications - Send notifications** dashboard to understand delivery patterns

        ![](images/30-122.png ':size=600')


⇨ [Continue to Monitoring the DA project deployments](40-monitor-da-deployments.md)
