# Managing alerts in the Incidents page

You can use the Incidents page to view the status of alerts that are triggered within a specific timeframe. You can also drill-down into the data for further analysis.

- You can view all the alerts which are currently triggered or those triggered within a specific time frame.
- You can organize incidents by alert definition.
- You can search alerts by name.
- You can filter alerts by type, severity, or other chosen parameters.
- You can select and modify incident status.
- You can drill-down into any triggered event to view its contextual information and underlying data.
- You can view alerts in chronological order.

## Checking whether your alert has triggered

1. Go to the Incidents page.
   ![](images/incidents-1.png ':size=300')
   The Incidents page opens and you can see if the alert that you configured has been triggered.
   ![](images/incidents-2.png ':size=800')
2. Identify your alert, and change the status to **Acknowledge**.
   * Incidents may have one of three statuses: TRIGGERED, ACKNOWLEDGED, or RESOLVED.
   * The status of an incident can be changed automatically or you can change it manually.
   * Once a triggered alert is resolved, the status of the original incident automatically changes to RESOLVED. If you have activated the Notify When Resolved settings in your alert, a new resolve event is sent.
   * Once resolved, an incident is closed. If the alert is then triggered, a new incident is opened.
   * To manually change the status, click on a TRIGGERED status, then choose to ACKNOWLEDGE or RESOLVE an incident. Doing so automatically sets you as the assignee.
   ![](images/incidents-3.png ':size=600')
3. Click on the alert, and explore the details and log records that triggered the alert.
   ![](images/incidents-4.png ':size=600')

Triggered alerts are presented in your Incidents page according to the **Group By** tags and **Notifications** that are set in your alert definition.

The Incidents page presents all of the individual permutations for all key-value tags that are selected in the **Group By** conditions defined in your alert. For example, update your alert definition and enter a group by subsystemName.

![](images/incidents-5.png ':size=600')

Then, back in the Incidents page, select Group by tags:

![](images/incidents-6.png ':size=600')

The Group By feature allows you to group alerts by one or more key-value tags that are aggregated into a histogram. An alert is triggered whenever the condition threshold is met for a specific aggregated key within a specified timeframe.

You will get to the following page:

![](images/incidents-7.png ':size=600')

Take time to explore the page.

⇨ [Explore the TCO Optimizer](30-tco.md)
