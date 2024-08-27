# Logging and monitoring

Code Engine integrates seamlessly with IBM Cloud Logs and Monitoring services.

## View the logs for your application

When you work with Code Engine apps, jobs, or builds in the console with logging enabled, logs are forwarded to an IBM Cloud Logs service where they are indexed, enabling full-text search through all generated messages and convenient querying based on specific fields.

1. Go to the **Observability > Logging instances** section at https://cloud.ibm.com/observability/logging.
1. Select the **Cloud Logs** tab.
1. Click **Open dashboard** on the existing Cloud Logs instance.
1. From the left toolbar, click the second icon <span class="material-icons">tune</span> then select **Logs**.
1. Change the time horizon on the top right to **Last 30 minutes**.
1. Type your username in the search field to only show logs related to your application.
   ![](images/50-view-logs.png ':size=600')

?> Cloud Logs gives you many options to create your own views, to define alerts and to extract insights from your application logs..

## View monitoring data for your application

You can use the IBM Cloud Monitoring service to monitor your Code Engine workloads. Code Engine forwards selected information about your workloads to Monitoring so that you can monitor specific metrics such as requests, revisions, and duration.

1. From the **Overview** page for the application, use the drop down menu and click **Monitoring**.
   ![](images/50-launch-monitoring.png ':size=400')
1. When you launch monitoring, the Code Engine monitoring dashboard opens. This dashboard is pre-configured with your Code Engine project.
   ![](images/50-monitoring.png ':size=400')
1. See the metrics on the Code Engine monitoring dashboard for your application. This dashboard includes a variety of metrics such as:
   * Number of concurrent requests per application
   * Total number of HTTP requests per application and revision
   * Number of job runs and their status

?> In addition to the pre-configured Code Engine monitoring dashboard, you can also [create your own custom dashboards](https://cloud.ibm.com/docs/codeengine?topic=codeengine-monitor-custom) to match your needs.

⇨ [Continue to Functions](50-logging-and-monitoring.md)