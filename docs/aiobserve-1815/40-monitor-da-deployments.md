# Infrastructure Deployment Monitoring

**Learning Objectives:**
- Understand how to monitor complex infrastructure deployment lifecycles
- Learn to track deployment governance and approval workflows
- Practice correlating deployment events with infrastructure health
- Explore monitoring patterns for infrastructure-as-code deployments

In this section, you'll learn about features in IBM Cloud Logs, IBM Cloud Monitoring, and Activity Tracker for monitoring infrastructure project deployments.

![Infrastructure project deployment monitoring](images/40-1.png ':size=600')

## Infrastructure Deployment Monitoring Architecture

Modern infrastructure deployments involve multiple stages, approvals, and validations. Understanding how to monitor these processes is crucial for:
- **Deployment governance**: Tracking who approved and deployed what changes
- **Failure investigation**: Correlating deployment events with service issues
- **Compliance auditing**: Maintaining records of infrastructure changes
- **Performance tracking**: Understanding deployment impact on system performance

### About IBM Cloud Projects

[IBM Cloud Projects](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-understanding-projects) is a service that helps you deploy and manage infrastructure using [Infrastructure as Code (IaC)](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-understanding-projects#projects-key-terms) best practices. Projects provide a collaborative workspace where teams can:

- **Deploy [Deployable Architectures](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-understand-module-da)**: Pre-built, validated infrastructure blueprints that follow enterprise best practices
- **Manage environments**: Separate development, staging, and production deployments
- **Control approvals**: Implement governance workflows requiring validation and approval before deployment
- **Track changes**: Maintain complete audit trails of infrastructure modifications
- **Integrate with CI/CD**: Connect with existing development and deployment pipelines

The [RAG Pattern deployable architecture](https://cloud.ibm.com/catalog/7a4d68b4-cf8b-40cd-a3d1-f49aff526eb3/architecture/Retrieval_Augmented_Generation_Pattern-5fdd0045-30fc-4013-a8bc-6db9d5447a52-global) demonstrates enterprise deployment patterns where validation, approval, and monitoring workflows ensure reliable infrastructure changes. IBM Cloud Projects is the service used to run deployable architecture automation, including the RAG pattern in this lab environment.

> **💡 TIP:** While we use IBM Cloud Projects as an example, the techniques demonstrated apply to any service that exposes audit events, logs, and metrics - you'll just need to adapt the audit event names and metrics.

You can monitor project deployment activity through events such as:
- project.project.list
- project.project.read
- project.config.list
- project.config.read
- project.config.update
- project.config.validate
- project.config.approve
- project.config.deploy
- project.environment.list

For more information, see [Activity tracking events for a project](https://cloud.ibm.com/docs/secure-enterprise?topic=secure-enterprise-at_events).


## Cloud Logs TCO Optimizer

> **Note:** TCO stands for Total Cost of Ownership, which helps optimize your logging costs while maintaining access to the data you need.

**📋 In Cloud Logs, you have different data pipelines that you can configure through policies to monitor the data after ingestion. You must have an IBM Cloud Object Storage data bucket configured before creating TCO policies. For more information, see:**
- [TCO Optimizer](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-tco-data-pipelines)
- [Configuring the TCO Optimizer](https://cloud.ibm.com/docs/cloud-logs?topic=cloud-logs-tco-optimizer).

**The three TCO pipelines that you can configure are:**

- **Priority insights**: Logs that require immediate access and full IBM Cloud Logs analysis capabilities. These logs are typically high-severity or business-critical logs that need to be analyzed or queried individually.

    Data that you send through the Priority Insights data pipeline is stored in the backend and in the COS data bucket.

    Data retention for fast searches is set at the Cloud Logs instance level. You can choose from 7 days, 14 days, 30 days, 60 days, or 90 days.

    Data retention in the COS data bucket attached to the Cloud Logs instance is set by you. You manage the bucket and you can keep the data for as long as you need.

    > **Note:** Queries that you use to search data in Priority Insights (fast search), you can reuse them to query older data that meet that criteria and is stored in the COS data bucket as long as you keep data for the timestamp of your search.

- **Analyze and Alert**:

    Logs that require processing and can be queried later if needed from an archive. These logs are typically logs used for monitoring and statistical analysis.

    Data that you send through the Analyze and Alert data pipeline is stored in the COS data bucket only. You can use this data in searches, dashboards and to trigger alerts.

    Data retention in the COS data bucket attached to the Cloud Logs instance is set by you. You manage the bucket and you can keep the data for as long as you need.

- **Store and Search**:

    Logs that need to be kept for compliance or post-processing reasons but can be maintained and queried from an archive.

    Data that you send through the Store and Search data pipeline is stored in the COS data bucket only. You can use this data in searches only.

    Data retention in the COS data bucket attached to the Cloud Logs instance is set by you. You manage the bucket and you can keep the data for as long as you need.

> **💡 TIP:** Configure the TCO data pipelines based on the importance of the data to your business. The TCO Optimizer can help you improve real-time analysis and alerting, and can also help you manage costs.


## Searching data that is stored in the COS data bucket

In this section of the lab, you will search data that is stored in the COS bucket that is attached to the Cloud Logs instance.

Complete these steps to monitor data in the COS bucket:

1. Navigate to **Menu icon > Observability > Logging > Instances**.

    ![IBM Cloud UI](images/30-1-1.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

    ![IBM Cloud UI](images/30-1-2.png ':size=600')

3. Select **All logs** to search data stored in the bucket.

    ![IBM Cloud UI](images/30-1-2-1.png ':size=600')

4. Change the timestamp to the period that you are analyzing.

    ![IBM Cloud UI](images/30-1-2-2.png ':size=600')


## Step 1: Monitoring Infrastructure Project Deployments Using Query Searches

> **📋 Why This Matters:**  Search and filter techniques help you track deployment activities and troubleshoot issues. Understanding project lifecycle events is crucial for maintaining governance and identifying deployment problems.

Follow these steps to review project deployment events:

1. Navigate to **Menu icon > Observability > Logging > Instances**.

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

3. Change the Cloud to **Custom** and select the values with the information on the following image:

    ![IBM Cloud UI](images/30-1-2-3.png ':size=600')

4. Apply these filters to view only project deployment events:
    - For **Application**, select **ibm-audit-event**
    - For **Subsystems**, select **project:**

    ![](images/40-7.png ':size=600')

5. Try these specific queries to monitor different deployment activities:

    > **To identify configuration validation requests:**

    Set the custom timestamp to:

    ![](images/40-8-1.png ':size=600')

    ![](images/40-8-2.png ':size=600')

    Enter the Lucene query:

    ```
    action:"project.config.validate"
    ```

    ![](images/40-8.png ':size=600')

    > **To identify approval requests and who approved them:**

    ```
    action:"project.config.approve"
    ```

    ![](images/40-11.png ':size=600')

    > **To identify deployment requests and who initiated them:**

    ```
    action:"project.config.deploy"
    ```

    ![](images/40-9.png ':size=600')

    > **To identify configuration update requests:**

    Set the timestamp to:

    ![](images/40-2-1.png ':size=600')

    Enter the Lucene query:

    ```
    action:"project.config.update"
    ```

    ![](images/40-2.png ':size=600')

    > **To identify configuration update errors:**

    Set the timestamp to:

    ![](images/40-3-1.png ':size=600')

    Enter the Lucene query:

    ```
    action:"project.config.update" AND message:"-failure"
    ```

    ![](images/40-3.png ':size=600')



> **💡 TIP:** Save these queries as views for quick access. During deployment windows, have these views open to monitor progress in real time.


## Step 2: Monitoring Infrastructure Project Deployments Using Dashboards

> **📋 Why This Matters:**  Dashboards provide visual insights into your deployment activities. Learning to navigate and customize dashboards helps you quickly identify trends and anomalies in your infrastructure changes.

Follow these steps:

1. Navigate to **Menu icon > Observability > Logging > Instances**.

    ![](images/30-121.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Custom Dashboards**.

3. Select the **RAG DA Overview** dashboard to monitor deployment activity.

    ![](images/40-4.png ':size=600')

> **💡 TIP:** When monitoring critical deployments, set your dashboard refresh rate to a faster interval (e.g., 30 seconds) to get more timely updates.

### Creating a Custom Dashboard

To create your own deployment monitoring dashboard:

1. Navigate to **Menu icon > Observability > Logging > Instances**.

    ![](images/30-121.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Custom Dashboards**.

3. Click **New > Create New Dashboard**.

    ![](images/40-5.png ':size=600')

4. Drag widgets into your new dashboard.

5. Hover over **Save**, click **Save As Name**, enter a name for your dashboard, and click **Save**.

6. To manage your dashboard, hover over it in the dashboards panel, click the three dots, and select the desired action (Favorite, Set As Default, Rename, Delete, Save As, Export, or Copy URL).

> **💡 TIP:** Create focused dashboards for specific deployment types or environments. This makes it easier to monitor complex infrastructures without being overwhelmed by irrelevant data.



## Monitoring Trusted Profiles - Review Login Sessions

> **📋 Why This Matters:**  [Trusted profiles](https://cloud.ibm.com/docs/account?topic=account-create-trusted-profile&interface=ui) provide automated access to federated users. Monitoring these profiles helps you verify that only authorized entities are accessing your resources.

In this deployment, you'll find these trusted profiles:
- **rag-config-aggregator-trusted-profile** (created by Essential Security - App Configuration)
- **rag-workload-protection-trusted-profile** (created by Essential Security - Security and Compliance Center Workload Protection)

    ![](images/30-4.png ':size=600')

Follow these steps to review login sessions:

1. Navigate to **Menu icon > Observability > Logging > Instances > rag-cloud-logs**.

    ![](images/30-1.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

    ![](images/30-2.png ':size=600')

3. Apply these filters:
   - For **Application**, select **ibm-audit-event**
   - For **Subsystems**, select **iam-identity**

    ![](images/30-3.png ':size=600')

4. Run this query to view trusted profiles login events:
   ```
   action:"iam\-identity.assume\-profile.login"
   ```

    ![](images/30-5.png ':size=600')

5. Select an event to view identifying information:
   - `Initiator.authnId` and `Initiator.authnName`: Details of the authenticated user
   - `Initiator.id` and `Initiator.name`: Details of the profile being applied

6. Create a view for quick access:
   - Click **Unsaved view**
   - Enter a name
   - Select **Public**

    ![](images/30-6.png ':size=600')

> **💡 TIP:** Set up alerts for unusual trusted profile activity patterns, such as logins outside normal business hours or multiple failed access attempts, as these could indicate potential security issues.


⇨ [Continue to Monitoring Code Engine Projects and Applications](50-monitor-code-engine.md)
