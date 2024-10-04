# Triggering alerts on your data

IBM Cloud Logs alerts allow for timely detection of anomalies, proactive incident response, improved mean time to resolution (MTTR), reduced manual monitoring effort, customization, and flexibility. Powered by machine learning, alerting proactively notifies teams of potential problems, correlates incidents, and provides root cause analysis.

Once an alert is triggered and processed, the system sends notifications to the designated users or teams. Notifications can be delivered through various channels such as email, Slack, SMS, or integrated incident management platforms. If the situation remains unresolved, the alert can be escalated to higher-level teams or individuals.


## How does alerting works

Check out this high-level workflow of how alerts are generated, triggered, and delivered to users.

![](images/alert-ov.png ':size=600')

1. An alert is configured. The alert defines the rules that specify the conditions under which an alert should be triggered. For instance, they might set a rule to alert when the CPU usage exceeds a certain threshold or when specific error messages appear in the logs.
2. Data is sent to the IBM Cloud Logs instance. Data that is collected, is analyzed against the defined alert rules.
3. An alert is triggered when the monitored data meets the conditions specified in the alert rules. This could be a sudden spike in error rates, high latency, low resource availability, or any other predefined anomaly.
4. If you configured your alert to aggregate multiple similar alerts into a single notification, an aggregated notification is generated to prevent overwhelming users with redundant notifications. Also, it may remove duplicate (deduplicate) alerts to avoid sending users repetitive information.
5. Notifications can be delivered through various channels such as email, Slack, SMS, or integrated incident management platforms. If the situation remains unresolved, the alert can be escalated to higher-level teams or individuals. IBM Cloud Logs integrates with IBM Cloud Event Notifications to trigger alerts to your destinations. (Event Notifications is out of the scope of this lab.)
6. When the recipients of the alert acknowledge the alert and take appropriate actions to address the issue, the alert is marked resolved in IBM Cloud Logs.
7. You can monitor alerts that are triggered and their status through the Incidents page. Throughout the alerting process, IBM Cloud Logs continuously monitors the system’s status. It can keep track of acknowledgment status, resolution time, and other metrics to generate reports and help with post-incident analysis and improvement.

## Alert types

IBM Cloud Logs provides the following types of alerts that you can configure.

![](images/alert-1.png ':size=600')

*Standard* alerts are alerts that are triggered by changes to your logs. Triggered by crossing a set quantity threshold of specific logs, this feature allows you to monitor system performance, get notified when changes occur, and pinpoint potential causes. These alerts are useful when trying to measure the number of occurrences of a particular incident.

*Time relative* alerts automatically detect abnormal behavior in your system. Alerts are triggered when a fixed ratio reaches a set threshold compared to a past time frame. You can use time relative alerts to receive automatic alerts about changes in your system’s security, operations, or business behaviors over time and to compare between behaviors across different time periods

*Unique count* alerts trigger on the number of unique values inside a selected key that matches a specific search criteria. That is, the cardinality of a specific key matched to a search.

*Ratio* alerts can be used to calculate a ratio between two log queries and trigger an alert when the ratio reaches a set threshold.

*New value* alerts are triggered by the first occurrence of a new value within a time interval. All values are tested against a list that is dynamically created while the alert is active. The alert is set by a specific query that identifies a subset of logs (if needed), and is defined with a key to track for new values within the wanted interval. This alert can help you automatically detect possible abnormal behavior within your system.

*Flow* alerts are designed to notify you when any combination of alert events occurs in a specific sequence within a defined time frame. For example, to be notified of an increase in HTTP error rate caused by high CPU utilization, a flow alert can be configured to trigger when a high CPU utilization alert is followed by a high HTTP error rate alert within a defined time frame.

## Create an alert

Let's create an alert based on data that you generate by using the `app-log-analysis` application.

1. Define the criteria that you want to apply to filter logs and trigger an alert. For example, you can choose by message log level, or by words that you include in the message and appear in more than 1 log record.

   In IBM Cloud Logs, message log level is found in the field `coralogix.metadata.severity`. This field must be set to a number: 1 for Debug, 2 for Verbose, 3 for Info, 4 for Warn, 5 for Error, 6 for Critical. If a log does not specify a value, 1 (Debug) is assigned when the log is ingested by IBM Cloud Logs.

   Test you search query in a Logs view. For example, generate log records with different log levels, and text such as : "My favorite colour is red". Use and repeat colours to have a variety of log lines. You can use a Lucene search query as follows: `kubernetes.labels.run:"app-log-analysis" AND message.keyword:/.*red.*/`
2. Go to the **Alert Management** section.
   ![](images/alert-2.png ':size=300')
   Create an alert. Slect **New alert**.
   ![](images/alert-3.png ':size=800')
3. Enter the details of the alert. Enter a name, a severity, and a label.
   ![](images/alert-4.png ':size=600')
4. Select the **Standard alert**. Enter the the triggering condition in the Query section. Select the subsystem `app-log-analysis` and as application your namespace.
   ![](images/alert-5.png ':size=600')
   Select all severities.
   ![](images/alert-7.png ':size=600')
   Change the condition to more that 1 log in 5 minutes.
   ![](images/alert-6.png ':size=600')
5. Click **Create alert**.

Generate data by using the application `app-log-analysis` so the alert triggers based on ypur condition. If you use the sample message, send messages with different colours, and repeat the red color so the alert triggers.

⇨ [Continue to Incident management to monitor your alert](80-incident.md)
