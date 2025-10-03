# Monitoring IBM Cloud Activity Tracker Event Routing

**Learning Objectives:**
- Understand how IBM Cloud Activity Tracker Event Routing collects and routes audit events for infrastructure, security and compliance monitoring
- Learn to navigate and interpret monitoring dashboards for complex service dependencies
- Practice creating alerts for critical infrastructure events to ensure operational reliability
- Explore data flow patterns between Activity Tracker, Metrics Routing, and monitoring services

In this section, you'll explore how to monitor IBM Cloud Activity Tracker Event Routing. This demonstrates how to monitor the health and performance of the underlying service that supports your applications.

## About IBM Cloud Activity Tracker Event Routing

IBM Cloud Activity Tracker Event Routing is a critical component that defines how auditing events are routed throughout your IBM Cloud account. These auditing events are essential for:
- **Security operations**: Tracking who did what and when across your infrastructure
- **Compliance requirements**: Meeting regulatory standards that require audit trails
- **Operational insights**: Understanding system usage patterns and potential issues

> **📋 Why This Matters:** Activity Tracker Event Routing is a core service in IBM Cloud that collects audit events and routes them to destinations. Audit events are required for security and compliance. Failure to collect and route auditing events can create security blind spots and compliance gaps.

## Monitoring IBM Cloud Activity Tracking Event Routing through IBM Cloud Monitoring

You can use IBM Cloud Monitoring to monitor IBM Cloud Activity Tracker Event Routing.

Activity Tracker Event Routing exposes the following metrics:

**Total number of events successfully sent to the storage target**

Successful events represent the number of auditing events that Activity Tracker Event Routing successfully delivered to target storage destinations. This is your baseline for normal operations.

**Total number of events that failed to send to the storage target**

Failed events indicate delivery problems. There are three root causes for failures:

  - Target configuration issues (incorrect credentials, wrong endpoints, etc.)
  - Upstream problems with the target storage destination (service outages, capacity limits)
  - Issues with the Activity Tracker Event Routing service itself

**Total number of events that are discarded**

Discarded events represent data loss - these are events that Activity Tracker Event Routing dropped because it couldn't deliver them for an extended period. If you see discarded events, immediately check and fix your target configuration.

**The target mode**

Target Mode is a boolean metric representing the configuration status:

- `1` indicates that valid targets are configured
- `0` indicates misconfigured or discarded targets requiring immediate attention

Let's look into how you can monitor IBM Cloud Activity Tracking Event Routing in IBM Cloud Monitoring!

## Step 1: Launch the Monitoring UI

Let's set up monitoring for these critical metrics:

1. In the IBM Cloud console, go to **Navigation Menu icon > Observability > Monitoring > Instances**.

    ![IBM Cloud console navigation to monitoring instances](images/30-12.png ':size=600')

2. For the **rag-cloud-monitoring** instance, click **Dashboard**. Then, select **Dashboards > IBM**.

    ![Monitoring dashboard selection](images/30-13.png ':size=600')

3. Select the **IBM Activity Tracker Event Routing Overview** predefined dashboard template.

    > **Note**: You cannot modify a dashboard template directly. However, you can copy the template and create a custom dashboard that you can then configure to meet your specific needs.

    ![Activity Tracker Event Routing dashboard template](images/30-14.png ':size=600')

> **💡 TIP:** Pay special attention to any spikes in failed or discarded events. These often indicate configuration changes or service disruptions that need immediate attention.


## Step 2: Explore your Deployment's Target Configuration

In the DA deployment, you have 2 targets configured:

- 1 target sends data to the IBM Cloud Logs instance: `rag-cloud-logs-target`
- 1 target sends data to the COS bucket: `rag-cos-target`

Take time to explore the **IBM Activity Tracker Event Routing Overview** predefined dashboard and familiarize yourself with the metrics patterns and continue to the next step to create an alert for when events fail to be sent to destinations.

The key metrics to monitor include:
- **Successful events**: Events successfully delivered to target destinations
- **Failed events**: Events that couldn't be delivered (indicating configuration or infrastructure issues)
- **Discarded events**: Events dropped after extended delivery failures (data loss indicator)
- **Target mode**: Boolean indicating whether targets are properly configured

> **💡 Critical monitoring points**: Monitor both targets for failed events and discarded events, and keep an eye on the Number of Misconfigured Targets metric. Any failures here mean you're losing audit data.

## Step 3: Create Proactive Alerts for Failed/Discarded Events

Creating alerts for failed/discarded events helps you:
- Detect configuration issues before they cause significant data loss
- Meet compliance requirements by ensuring audit data integrity
- Maintain operational visibility across your infrastructure

> **📋 Why This Matters:**  Failed or discarded events represent gaps in your audit trail, which can compromise security monitoring and compliance. Proactive alerting ensures you're notified immediately when data delivery issues occur, allowing for rapid response before significant data loss.

> **💡 TIP:** Adding alerts in Activity Tracking Event Routing helps ensure you maintain visibility into your audit data.

Let's set up an alert that will notify you when the threshold for failed/discarded events is exceeded:

### Step 1: Configure Email Notifications

First, you'll need to set up a notification channel so you can receive alerts when issues occur.

1. In the monitoring dashboard, go to **Settings**.

    ![Monitoring settings navigation](images/30-19-1.png ':size=600')

2. Select **Notification Channels**.

    ![Monitoring settings navigation](images/30-19-2.png ':size=600')

3. Choose the email notification channel.

    ![Monitoring settings navigation](images/30-19.png ':size=600')

4. Configure an email notification channel by adding the email address associated with your lab user ID **observe-XX@example.com**.

> **💡 TIP:** In production environments, use team distribution lists rather than personal emails to ensure alerts reach someone even during vacations or staff changes.

### Step 2: Create the Alert Rule

3. In the **IBM Activity Tracker Event Routing Overview** dashboard, navigate to the **Failed/Discarded events** widget and click **Create alert**.

    ![Failed/Discarded events widget with create alert option](images/30-15.png ':size=600')

4. Configure the alert by choosing the triggering condition with the following PromQL query:

    `topk(50,sum(sum_over_time(ibm_atracker_failed_events_by_target{}[10s])) by (ibm_atracker_target_type, ibm_atracker_reason_code)) / 10`

    This query calculates the rate of failed events over 10-second intervals and identifies the top 50 sources of failures by target type and reason code.

    ![Alert condition configuration](images/30-16.png ':size=600')

5. Change the name of the alert.

    ![Alert condition configuration](images/30-16-1.png ':size=600')

    Enter **[Observe-XX] Failed events**

    ![Alert condition configuration](images/30-16-2.png ':size=600')

6. Click **Create alert** to open the alert configuration wizard.

    ![Alert creation wizard](images/30-17.png ':size=600')

7. Review the alert configuration, ensure your notification channel is selected, and click **Save**.

    ![Final alert configuration review](images/30-18.png ':size=600')

To check the alert has been created, go to the **Alerts** section and select **Alerts**:

![Final alert configuration review](images/30-18-1.png ':size=600')

Then look for the alert you just created.

![Final alert configuration review](images/30-18-2.png ':size=600')



> **💡 TIP:** Consider creating different severity alerts for different thresholds. For example, a warning alert for any failures and a critical alert when failures exceed a certain percentage of total events.



⇨ [Continue to Monitoring IBM Cloud Metrics Routing](30-monitor-mrouter.md)
