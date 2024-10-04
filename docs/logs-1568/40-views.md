# Learn about private and public views

In IBM Cloud Logs, you can configure public and private views.
- A **public view** is available to all users that have access to the IBM Cloud Logs instance. Any user with service role permissions can see them. Only users that have the `writer` or `manager` role can manage them in the instance.
- A **private view** is available to the user that creates the view in an IBM Cloud Logs instance. Only users that have the `writer` or `manager` role can manage private views in an instance.

You can use a view to see logs that match a specific filtering criteria. Views can be grouped into folders. View names must be unique within a folder.

## Creating a custom view

1. In the application, generate a log line with the message `My favorite colour is red`
   ![](images/log-line.png ':size=600')
1. Back in the Cloud Logs dashboard, in the left-hand navigation, click **Explore logs** > **Logs**. By default, the last view you had opened will be displayed. If no view was previously open, all views will be displayed.
   ![](images/explore-logs.png ':size=200')
1. Select the fields to be included in the view. By default, you can select *Applications*, *Subsystems*, and log *Severities*. For example, select the application that matches the namespace allocated to you.
1. Add additional filters. Select the subsystem `app-log-analysis`.
   ![](images/subsystem-filter-view.png ':size=300')
1. Select if you want your view to only include **Priority Logs** (those in the `Priority Insights` data pipeline or **All Logs**, that is, logs that are stored in your data bucket. Logs in the data bucket include logs collected through all the three data pipelines.
   ![](images/query-priority.png ':size=300')
1. Add a Lucene query `"My favorite colour is red"` to further filter your data.
   ![](images/view-query-app-1.png ':size=800')
1. Specify the time interval for the view, for example `Last 5 minutes`.
1. Save your view by clicking the three dots **...**
   1. Set the view name to `<your-username>-first-view`.
   2. Check **Save query and filters** to save the query and filter values you configured.
   3. If you want your view to be the default view, check **Set as default view**.
   4. Set the privacy of your view. Private views can only be seen by you. You can set a view as **Private** or **Shared**.
7. Click **Create**.

## Organizing views into folders

To create a folder and add saved views to the folder:
1. Click **All Views**.
2. Click the folder icon. Set the folder name to `<your-username>`, and click **Create**.
   ![](images/folder-views.png ':size=300')
3. Move the view you created in the previous section by dragging it to the folder. Make sure to select the icon of the view to drag it to a folder.

## Explore further

Create other views and explore the UI features such as:
- Selecting a field and including or excluding it in the query.
- Customizing the view UI, for example, by adding other fields.
- Viewing the log record in context by selecting the number associated to the record and clicking `View Surrounding Logs`.

⇨ [Continue to Templates - Find out what logs need your attention](50-templates.md)
