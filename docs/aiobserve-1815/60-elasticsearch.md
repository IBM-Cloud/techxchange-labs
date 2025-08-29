# Database Service Monitoring

**Learning Objectives:**
- Understand database monitoring within a comprehensive infrastructure stack
- Learn to correlate database-level events with platform-level infrastructure metrics
- Practice monitoring databases and their resource consumption patterns
- Explore how databases integrate with enterprise monitoring architectures

In this section, you'll examine how IBM Cloud Databases for Elasticsearch fits within the broader observability stack. You'll learn monitoring strategies that you can apply to any database deployment.

## IBM Cloud Databases for Elasticsearch in Enterprise Context

Elasticsearch is a robust search-capable database well-suited for machine learning features in enterprise environments. For more information, see [Elasticsearch, machine learning, and AI](https://cloud.ibm.com/docs/databases-for-elasticsearch?topic=databases-for-elasticsearch-es-ml-ai).

Understanding how to monitor databases alongside other services addresses key observability challenges:

- **Database performance**: Resource utilization, connection patterns, and query performance
- **Platform integration**: How databases integrate with AI services
- **Cross-service troubleshooting**: Correlating database issues with underlying infrastructure
- **Operational visibility**: Monitoring lifecycle events

> **💡 TIP:** Database monitoring is often the key to identifying application performance issues. When users report slowness, checking database metrics first can quickly narrow down whether the problem is in your application code or the database layer.

## Monitoring IBM Cloud Databases for Elasticsearch

You can monitor Elasticsearch using multiple IBM Cloud services:

- **IBM Cloud Logs**:
    - Monitor platform logs for operational activities and troubleshooting
    - Track activity events for administrative actions. See [Activity tracking events for Cloud Databases](https://cloud.ibm.com/docs/databases-for-elasticsearch?topic=databases-for-elasticsearch-at_events).

- **IBM Cloud Monitoring**:
    - Monitor health and performance through platform metrics
    - Use predefined dashboards for comprehensive visibility

For more details, see [Elasticsearch Metrics](https://cloud.ibm.com/docs/databases-for-elasticsearch?topic=databases-for-elasticsearch-monitoring#metrics-by-plan-elasticsearch).

## Step 1: Monitoring Deployment Status through IBM Cloud Logs

You can track important administrative activities in your Elasticsearch instance through events such as:

- databases-for-elasticsearch.deployment-task.list
- databases-for-elasticsearch.deployment-user-connection.list
- databases-for-elasticsearch.deployment-capability.read
- databases-for-elasticsearch.deployment-group-autoscaling.read
- databases-for-elasticsearch.deployment-group.list
- databases-for-elasticsearch.deployment.read
- databases-for-elasticsearch.deployment-point-in-time-recovery-data.list
- databases-for-elasticsearch.deployment-ip-address.list
- databases-for-elasticsearch.deployment-database-connection.bulkdelete
- databases-for-elasticsearch.deployment-user.update
- databases-for-elasticsearch.deployment-backup.create
- databases-for-elasticsearch.deployment-backup.list

Follow these steps to search for Elasticsearch activity:

1. Navigate to **Menu icon > Observability > Logging > Instances > Cloud Logs**.

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

3. Apply these filters:
   - For **Application**, select **ibm-audit-event**
   - For **Subsystems**, select entries that include **databases-for-elasticsearch:<InstanceID>**

    ![](images/60-1.png ':size=200')

4. Try these queries to monitor the database:

   **Check for deployment warnings or errors:**
   ```
   serviceName:"databases\-for\-elasticsearch" AND coralogix.metadata.severity:("Error" OR "Critical")
   ```

    ![](images/60-3.png ':size=600')

5. Use **Show graph for key** to visualize the actions reporting errors:

    ![](images/60-4.png ':size=600')

    You should see a graph similar to this:

    ![](images/60-5.png ':size=600')

> **💡 TIP:** After administrative actions like scaling or maintenance, use these queries to verify the operations completed successfully. Look for any errors that might indicate configuration issues.

## Monitoring Database Logs through IBM Cloud Logs

Platform logs help you investigate abnormal activity and troubleshoot problems in your database instance.

Follow these steps:

1. Navigate to **Menu icon > Observability > Logging > Instances > Cloud Logs**.

2. For the **rag-cloud-logs** instance, click **Dashboard**, then **Explore Logs > Logs**.

3. Apply these filters:
   - For **Application**, select **ibm-platform-logs**
   - For **Subsystems**, select entries that include **databases-for-elasticsearch:<InstanceID>**

    ![](images/60-7.png ':size=200')

4. Explore the logs to identify patterns, warnings, and errors:

    ![](images/60-6.png ':size=600')

> **💡 TIP:** Database logs often contain valuable information about query performance. Look for slow queries and frequent operations to identify optimization opportunities in your applications.

## Monitoring Database Health in IBM Cloud Monitoring

IBM Cloud Monitoring provides the **Databases for Elasticsearch - Overview** dashboard, which contains pre-defined panels monitoring various aspects of your database.

Follow these steps to access this dashboard:

1. Navigate to **Menu icon > Observability > Monitoring > Instances**.

    ![](images/30-12.png ':size=600')

2. For the **rag-cloud-monitoring** instance, click **Dashboard**, then **Dashboards > IBM**.

    ![](images/30-13.png ':size=600')

3. Select the **Databases for Elasticsearch - Overview** dashboard template:

    ![](images/60-2.png ':size=600')

4. Explore the dashboard to understand the different metrics available for monitoring your database.

> **💡 TIP:** Pay special attention to memory usage, disk utilization, and IOPS metrics. These are often early indicators of performance issues. Create alerts for these metrics to proactively address potential problems before they affect your applications.



⇨ [Continue to AI Services Monitoring](70-monitoring-watsonx.md)
