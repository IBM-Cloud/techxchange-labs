# Monitoring your apps through dashboards

In IBM Cloud Logs, you can use dashboards to monitor related data through different types of data visualizations, also known as widgets.
- You can monitor your logs and metrics through the **Home dashboard**, a prefedined dashboard.
- You can create unlimited, personalized **custom dashboards** and group them in folders.

## Create a custom dashboard

Widgets can be organized into sections. Sections within a dashboard can be collapsed, expanded, and reordered.

Custom dashboard are comprised of widgets. You can add one or more widgets to a dashboard. Each widget supports a different data type: logs or metrics. The timeframe configured for the dashboard is applied to all the widgets.

When you save your dashboard, the dashboard is saved with the sections collapsed or expanded as you last displayed them. Widgets in expanded sections are loaded first when the dashboard is displayed.

Complete the following steps to create a custom dashboard:

1. Click the **Dashboard** icon > **Custom dashboards**.
   ![](images/custom-dashboards.png ':size=400')
1. Create a new dashboard by clicking **New** > **Create New Dashboard**.
   Click *New Dashboard* and set the name to `<your-username>`, as example `loglab-123`.
   ![](images/dashboard-1.png ':size=400')
1. Drag and drop a **Section** to create a section in your dashboard.
   Name your section by clicking on **New Section** and typing a section name.
   ![](images/dashboard-2.png ':size=400')
1. Drag and drop widgets into the section. For example, drag a line chart.
   * A data table represents the selected data in tabular format.
   * A line chart represents the selected data as a line graph over time.
   * A gauge represents the current value of a single data point.
   * A pie chart represents different values for a single data source type allowing you to see the proportional relationships to those values.
   * A vertical bar chart represents different values from one or more data sources as vertical bars. This visualization allows you to see relationships between values for the same data types originating from different data sources. By default, data is presented alphabetically by data column name.
   * Horizontal bar charts represent values from one or more data sources as horizontal bars.  By default, the data is presented in decending order of the value.

   For example, create a section and add a table.
   ![](images/dashboard-3.png ':size=800')

1. Configure a widget. Click the three dots icon and select **Edit**.

    ![](images/widget-3-dots.png ':size=300')

   1. Enter a name for the widget.
   1. In the *Load data from*, select **Priority Insights** to query the data that is indexed. Select **All logs** to query the data that is in the data bucket.
   1. In the *Source* section, select **Logs**.
   1. In the **Table type** choose **Aggregation**.
   1. Group by **Subsystem**.
   1. Choose a filter: **application**. Select the value **ibm-audit-event**.
   ![](images/dashboard-widget-config-1.png ':size=800')
   Make sure you select a time range for the data that is to be displayed.
   ![](images/sample-dashboard.png ':size=800')
1. Click **Save**.
1. In the dashboards panel, hover over your new dashboard and click the three dots. Click what you would like to do with your dashboard: **Favorite**, **Set As Default**, **Rename**, **Delete**, **Save As**, **Export**, or **Copy URL**.
   **Favorite** and **Set As Default** settings are unique for each user. All other settings apply across all team members.
   ![](images/dashboard-options.png ':size=300')

Modify the dashboard and add more widgets. Check out the different configuration options for the different widget types.

## Specify the dashboard timeframe

By default, custom dashboards show data from the last 15 minutes. This can be modified using the timeframe dropdown in the dashboard.

You can choose between different timeframes either by selecting one of the quick timeframes, or by using the **Custom** tab and selecting two dates between which you want to show data.

IBM Cloud Logs supports selecting a timeframe of up to 90 days for your custom dashboards. This lets you easily view metric widgets with long retention periods within your custom dashboards.

Try different timeframes.

![](images/timeframe-dashboard.png ':size=800')

## Add the dashboard to a folder

Complete the following steps to create a folder and add a dashboard.

1. In the *DASHBOARDS LIST*, select **New**, then click **Create folder**.
   ![](images/create-dashboard-folder.png ':size=400')
1. Drag the dashboard that you created into the new folder.

⇨ [Continue to Learn about alerts](70-alerts.md)
