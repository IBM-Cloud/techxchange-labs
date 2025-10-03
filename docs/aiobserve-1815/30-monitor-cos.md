# Monitoring Cloud Object Storage (COS) Health and Status


**Learning Objectives:**

- Understand how IBM Cloud services integrate with Cloud Object Storage
- Explore data flow patterns between Activity Tracker, Metrics Routing, and monitoring services


In this section, you'll explore how to monitor IBM Cloud Object Storage, focusing on the integration with IBM Cloud Logs.

> **📋 Why This Matters:** Your architecture relies on COS buckets for data storage and event handling. Failed uploads or access issues can break critical data flows and compromise audit trails.


## About IBM Cloud Object Storage

IBM Cloud Object Storage is a highly available, durable, and secure platform for storing unstructured data. Unstructured data (sometimes called binary or "blob" data) refers to data that is not highly structured in the manner of a database. For more information, see [About Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-about-cloud-object-storage).

You can integrate IBM Cloud Object Storage with some of the following services that are deployed through the deployable architecture:
- IBM Cloud Logs
- IBM Event Notifications

These services send critical data to the buckets configured for each service.

## Understanding Your COS Infrastructure in the DA

In the DA deployment, you can find two COS instances:
- **rag-base-event-notifications-cos**
- **rag-observability-cos**

> **Note:** These instances are visible under Storage in the resource list at https://cloud.ibm.com/resources

With these critical buckets:
- **rag-cloud-logs-data-bucket-xxxx**: Stores logs that you collect from your infrastructure, services, and applications, as well as activity tracking data (audit data).
- **rag-base-event-notifications-bucket-xxxx**: Stores failed events that you can use later to troubleshoot problems
- **rag-cloud-logs-metrics-bucket-xxxx**: Stores metrics generated from logs that you can use to add an additional level of monitoring based on you log data.



## Monitoring IBM Cloud Object Storage

To monitor IBM Cloud Object Storage, you must monitor the service instance and the buckets, that are the resources that other IBM Cloud services use to store and read data.

You can monitor IBM Cloud Object Storage using multiple IBM Cloud services:

- **IBM Cloud Logs**:

    - Track activity events for administrative actions. For more information, see [Activity tracking events for IBM Cloud Object Storage](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-at-events).

- **IBM Cloud Monitoring**:

    - Monitor health and performance through platform metrics
    - Use predefined dashboards for comprehensive visibility

    For more details, see [IBM Cloud Object Storage Metrics](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-mm-cos-integration&interface=ui).

    > **💡 TIP: Monitoring across services deployed in the DA**  Multiple services can integrate with IBM Cloud Object Storage. You can create a dashboard in IBM Cloud Monitoring to display the health and status of multiple critical services alongside IBM Cloud Object Storage metrics. This dashboard would provide a single view that you could use to verify that alerts are working properly across your core infrastructure services.


## Monitoring IBM Cloud Object Storage through IBM Cloud Monitoring

IBM Cloud Monitoring provides multiple dashboards, which contains pre-defined panels monitoring various aspects.

Follow these steps to access this predefined dashboard:

1. Navigate to **Menu icon > Observability > Monitoring > Instances**.

2. For the **rag-cloud-monitoring** instance, click **Dashboard**, then **Dashboards > IBM**.

3. Explore the following dashboards to understand the different metrics available for monitoring buckets in IBM Cloud Object Storage.

    **IBM COS Bucket**: Displays metrics for individual buckets

    ![IBM COS Bucket dashboard template](images/30-22.png ':size=600')

    **IBM COS Account Summary**: Shows aggregated metrics across your COS account

    ![IBM COS Account Summary dashboard template](images/30-21.png ':size=600')

> **💡 Customization TIP:** Copy the predefined template and remove widgets for destinations you don't use to create a focused monitoring view.

## Monitoring IBM Cloud Object Storage through IBM Cloud Logs

Follow these steps to search IBM Cloud Object Storage activity tracking data:

1. In the IBM Cloud console, navigate to **Menu icon > Observability > Logging > Instances > rag-cloud-logs**.

    ![IBM Cloud UI](images/30-1-1.png ':size=600')

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

    ![IBM Cloud UI](images/30-1-2.png ':size=600')

3. Apply these filters:
   - For **Application**, select **ibm-audit-event**.
   - For **Subsystems**, select entries that include **cloud-object-storage:<InstanceID>**

    ![IBM Cloud Logs UI](images/30-1-3.png ':size=600')

4. Run queries to filter data based on custom search criteria.

    For example, run the following query `reason.reasonCode.numeric:[200 TO *] AND serviceName:"cloud-object-storage"` to filter logs:

    ![IBM Cloud Logs UI](images/30-1-4.png ':size=600')

Other query examples that you might want to monitor in your environments:

- Filter server errors: `reason.reasonCode.numeric:[500 TO *] AND serviceName:"cloud-object-storage"`
- Unauthorized access: `reason.reasonCode:("403" OR "401") AND serviceName:"cloud-object-storage"`
- Bucket deletion requests: `action.keyword:/cloud-object-storage.bucket.delete.*/`
- Failed uploads: `action:"cloud-object-storage.object.create" AND NOT reason.reasonCode:"200"`

> **💡 TIP:** You can create custom views to monitor CRUD operations and configuration changes. Save these queries as views for quick access during troubleshooting sessions.



⇨ [Continue to Monitoring Event Notifications Service Health](30-monitor-en.md)
