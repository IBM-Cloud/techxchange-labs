# Templates - Find the logs that need your attention

IBM Cloud Logs learns from the logs that are ingested through the Priority Insights and Analyze and Alert data pipelines. Similar logs are  grouped into templates to help you determine the logs requiring your attention and others that might not.

## How are templates generated from logs

As data is ingested, automatic log aggregation groups log entries into a narrow set of patterns by using machine learning. Each log that is received by IBM Cloud Logs is analyzed for constant log variable data.

Log aggregation is based on repetitive log activity over a 24-hour period or over 100 K logs.

First, metadata fields are analyzed and used for log aggregation and definition of a branch. The metadata fields that are always used are:

- Application name
- Subsystem name
- Severity

Then, the following fields are also used for log aggregation and definition of a template:

- text
- message
- msg
- log
- innerMessage

When log aggregation processes all ingested data, the logs that match a template must have an identical JSON structure. Any small variation of the JSON fields will result in a different template being created.


## Launch the templates page

Log aggregation results can be found as templates in the Templates tab in the Logs page. To access the Templates tab, complete the following steps:

1. In the navigation, click the **Explore logs > Logs templates**.
   ![](images/log-templates.png ':size=400')
   In the Logs view, you can also click the Templates tab to open the template view.
   ![](images/template-0.png ':size=600')
1. Filter data for the application `ibm-audit-event`. This application name groups auditing events that are generated in the account.
   ![](images/template-audit-1.png ':size=600')
1. Expand a log line and select the value of the `action` field.
   ![](images/message-log-line.png ':size=400')
   The field visualization opens in a new window and shows the data for that value.
   ![](images/field-visualization.png ':size=400')
1. Select the field `action`. Then select **Show graph for key**.
   ![](images/show-graph-for-key.png ':size=400')
   The field visualization with top values is displayed.
   ![](images/field-visulaization-field.png ':size=400')
1. Select the three dots to view the raw log, copy the permalink to quickly access the log at a later time.
   ![](images/three-dots.png ':size=300')
   Explore the options.
   ![](images/three-dots-options.png ':size=300')

## View the logs that are associated with a template

From the Templates page, scroll to the right, hover over the column **First seen**.

![](images/template-3.png ':size=300')

Then, click the magnifying glass icon to open a view that shows the logs that are associated with the template.

⇨ [Continue to Learn about dashboards](60-dashboards.md)
