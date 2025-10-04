# Validating Observability Resources

**Learning Objectives:**

- Understand how observability services are architecturally connected in enterprise deployments
- Learn about IAM authorization patterns for cross-service integrations
- Explore how data flows between logging, monitoring, and storage services
- Practice validating observability service configurations

The RAG Pattern deployable architecture demonstrates a comprehensive observability stack that showcases enterprise-level monitoring architecture. By examining this deployment, you'll understand how to design and validate observability solutions for any complex infrastructure.



## Step 1: Verify IAM Authorizations

> **📋 Why This Matters:**  IAM authorizations are the foundation of your observability architecture. Without proper authorizations, your observability services cannot communicate with each other, breaking the data flow needed for effective monitoring.

Complete the following steps:

1. In the IBM Cloud console, click **Manage > Access (IAM)**, and select **Authorizations**.

2. Look for these key authorization types to understand the integration patterns:

    - Authorization with **Sender** role allowing Activity Tracker Event Routing to send data to Cloud Logs
    - Authorization with **Object Writer** role allowing Activity Tracker Event Routing to upload to COS buckets
    - Authorization with **Writer** roles allowing IBM Cloud Logs to upload to its data and metrics buckets
    - Authorization with **Event Source Manager, Viewer, Reader** roles allowing Cloud Logs to send notifications to Event Notifications service

> **💡 TIP:** If you ever need to troubleshoot missing data in your observability tools, always check authorizations first. Missing or incorrect authorizations are the most common cause of data flow problems.

## Step 2: Validate IBM Cloud Logs Resources

> **📋 Why This Matters:**  IBM Cloud Logs is the central repository for all your logging data. Validating its configuration ensures your logs are being properly collected and stored.

Complete the following steps:

1. In the IBM Cloud console, click the **Menu icon > Observability** to access the Observability dashboard.

    ![](images/20-1.png ':size=600')

2. Click **Logging > Instances**.
3. Locate and select the instance **rag-cloud-logs**.
4. Verify that under **Storage**, both the data bucket **rag-cloud-logs-data-bucket-xxxx** and the metrics bucket **rag-cloud-logs-metrics-bucket-xxxx** are properly attached.

    ![](images/20-2.png ':size=600')

5. Select **Dashboard** to launch the instance's UI.
6. Navigate to **Outbound integrations**.

    ![](images/20-3.png ':size=600')

7. Verify you have an integration to the Event Notifications instance.

    ![](images/20-4.png ':size=600')

> **💡 TIP:** In a production environment, regularly validate that your storage buckets have sufficient capacity and appropriate lifecycle policies to manage log growth.

## Step 3: Verify the Integration Between IBM Cloud Logs and IBM Event Notifications

> **📋 Why This Matters:**  This integration ensures critical alerts from your logs are properly routed to notification channels, so your team is promptly informed of important events.

First, check the Event Notifications configuration:

1. In the IBM Cloud console, click the **Menu icon > Developer Tools** and locate the Event Notifications instance **rag-base-event-notifications**. Leave the logs tab open and navigate to the previous tab before proceeding.

    ![](images/20-5.png ':size=600')

2. Select the instance and navigate to **Sources**.

    ![](images/20-6.png ':size=600')

3. Verify a source exists with the name **IBM Cloud Logs - Cloud Logs Id**.

Now create a test topic and subscription:

4. Select **Topics** and click **Create**.

5. Enter a unique topic name, such as **CloudLogsInstance-test-student-N** (replace N with your student number).

    ![](images/20-7.png ':size=600')

6. Select the Cloud Logs source and set the Event type to **Test Event**.

7. Click **Add a condition > Save source**.

    ![](images/20-8.png ':size=600')

8. Click **Create**.

    ![](images/20-9.png ':size=600')

9. Select **Subscriptions** in the left menu, click **Create**, and create a subscription by entering a unique name like **Test-integration-student-N**.

10. Select your topic and choose the email destination.

    ![](images/20-10.png ':size=600')

11. Click **Add notification payload** and configure as shown:

    ![](images/20-11.png ':size=600')

12. Add your email address to recipients:

    ![](images/20-12.png ':size=600')

13. Click **Add**, then **Create**.

    ![](images/20-13.png ':size=600')

> **💡 TIP:** Check your spam folder if you don't receive the invitation email. You must accept the invitation before receiving any notifications.

Now test the integration:

14. Return to IBM Cloud Logs UI and edit the outbound integration.

    ![](images/20-13-1.png ':size=600')

15. Click **Test** and verify that you receive the test event email.

    ![](images/20-13-1.png ':size=600')

> **💡 TIP:** When setting up notification channels in your own environment, consider using group distribution lists rather than individual emails to ensure alerts reach your team even when specific individuals are unavailable.

## Step 4: Verify the IBM Cloud Monitoring Resources

> **📋 Why This Matters:**  IBM Cloud Monitoring is the central repository for all metrics. Validating its configuration ensures your metrics are being properly collected and stored. Metrics report on the performance and health of your infrastructure over time.

Complete the following steps:

1. In the IBM Cloud console, click the **Menu icon > Observability**.

2. Select **Monitoring > Instances**.

    ![](images/20-14.png ':size=600')

3. Locate the instance **rag-cloud-monitoring** and select **Dashboard**.

4. Navigate to **Dashboards > IBM**.

    ![](images/20-15.png ':size=600')

5. Check the list of predefined templates. Pre-defined dashboard templates are available for IBM Cloud services that generate platform metrics. For example, check that you see the **Activity Tracker Event Routing - Overview**, **Event Notifications**, **Secrets Manager**, **Code Engine**, **Key Protect**, and **Metrics Routing**.

> **💡 TIP:** Bookmark the most frequently used dashboards for quick access during incident response. This saves precious time when troubleshooting urgent issues.


## Step 5: Verify the IBM Cloud Activity Tracker Event Routing Resources

> **📋 Why This Matters:**  Activity Tracker Event Routing is a core service in IBM Cloud that collects audit events and routes them to destinations. Audit events are required for security and compliance. Failed event routing means lost audit data, which can create security blind spots and compliance gaps.

Complete the following steps:

1. In the IBM Cloud console, click the **Menu icon > Observability**.

2. Select **Activity Tracker**.

    ![](images/20-16.png ':size=600')

3. Check the **Targets** tab to confirm you have two targets configured:
   - Target to the Cloud Logs instance **rag-cloud-logs**
   - Target to the bucket **rag-cos-target**

    ![](images/20-17.png ':size=600')

4. Check the **Routes** tab to confirm you have two routes configured:

    ![](images/20-18.png ':size=600')

   - Route sending all activity tracking events to Cloud Logs
   - Route sending all activity tracking events to the COS target

    ![](images/20-19.png ':size=600')

> **💡 TIP:** Multiple targets provide redundancy for critical audit data. If one destination becomes unavailable, you still have a copy of your audit trail elsewhere.

## Step 6: Verify IBM Cloud Metrics Routing Resources

> **📋 Why This Matters:**  IBM Cloud Metrics Routing is a core service in IBM Cloud that collects and routes platform metrics from IBM Cloud services to IBM Cloud Monitoring instances. Metrics report on the performance and health of your infrastructure over time. If Metrics Routing fails, you lose visibility into the health and performance of your entire infrastructure.

Complete the following steps:

1. In the IBM Cloud console, click the **Menu icon > Observability**.

2. Select **Monitoring > Routing**.

    ![](images/20-20.png ':size=600')

3. Under **Targets**, verify you have a target to the Monitoring instance **rag-cloud-monitoring**.

    ![](images/20-21.png ':size=600')

4. Under **Routes**, verify you have one route configured.

    ![](images/20-22.png ':size=600')

> **💡 TIP:** In your own environment, document the specific metrics being routed and their importance to your applications. This helps team members understand what they're monitoring and why it matters.

## Next

You have verified the resources related to the observability stack deployed through the DA, following best practices, and created through the observability deployable architecture.

⇨ [Continue to Monitoring IBM Cloud Activity Tracker Event Routing](30-monitor-atracker.md)
