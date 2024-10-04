# Explore the TCO Optimizer

With IBM® Cloud Logs data pipelines and the TCO Optimizer, you can define the way logs are distributed across 3 distinct use cases. You can balance costs in the environment by using these pipelines. Configure this feature to avoid overpaying on lower value logs.

By defining the data pipeline based on the importance of the data to your business, the TCO Optimizer can help you improve real-time analysis and alerting and helps you manage costs.

How logs are associated to pipelines is determined by policies. Policies are applied on combinations of applications, subsystems, and log severity as logs are ingested. Logs are assigned to the appropriate TCO pipeline based on the policy content. The default policy for all logs is high priority.

Policies simplify assigning TCO pipelines and capture applicable logs on ingestion. Each policy creates new default values for the logs for the applicable policy. If policies conflict, the first policy that is listed on the TCO Optimizer page takes precedence.

The three TCO pipelines are:

- **Priority insights**

   Logs that require immediate access and full IBM Cloud Logs analysis capabilities. These logs are typically high-severity or business-critical logs that need to be analyzed or queried individually.

- **Analyze and alert**

   Logs that require processing and can be queried later if needed from an archive. These logs are typically logs used for monitoring and statistical analysis.

- **Store and search**

   Logs that need to be kept for compliance or post-processing reasons but can be maintained and queried from an archive.

![](images/tco-ov.png ':size=600')

The TCO Optimizer page shows the percentage of ingested data that is flowing to each pipeline after the configured policies are applied.

To be able to configure policies, you must have a data bucket associated with the Cloud Logs instance. The `Store and search` and `Analyze and alert` pipelines need the data bucket to store the data that is ingested into these data pipelines.

## Create a policy

Compete the following steps to access the TCO Optimizer and create a policy:

1. Click the **Data pipeline** icon > **TCO optimizer**.

   ![](images/tco-menu.png ':size=300')

2. Click **ADD NEW POLICY**. Enter a policy name.

3. Enter the policy details with the relevant applications, subsystems, and severity. Add more criteria as needed.

   Select `app-log-analysis` for the subsystem and your namespace as the application. Select all severities.

   Notice that logs received by Cloud Logs without a severity are treated as if their severity is `debug`.

   For applications and subsystems, criteria can be specified when the value matches one of: `All`, `Is`, `Is Not`, `Includes`, or `Starts With`.

4. Set the priority for the policy. The priority determines the data pipeline for logs that are matched by the policy.

   Choose **Medium** to select the `Analyze and alert` data pipeline.

   ![](images/tco-priority.png ':size=800')

5. Click **APPLY**.

   After you apply the policy, when you refresh the page, you can observe how the percentage of logs is now distributed between the `Priority Insights` data pipeline and the `Store and search` data pipeline.

## Try it!

Define a new policy in the IBM Cloud Logs instance, for example, define a policy for `ibm-audit-event` logs with severity `info` that sends these logs to the `Store and search` data pipeline.

1. Select the application name `ibm-audit-event`.

   ![](images/tco-1.png ':size=400')

2. Select the Severity `info`.

   ![](images/tco-2.png ':size=600')

3. Select the Priority `low` to set the `Store and search` data pipeline.

   ![](images/tco-3.png ':size=600')

4. Apply the policy

   ![](images/tco-4.png ':size=600')

After you apply the policy, when you refresh the page, you can observe how the percentage of logs is now distributed between the `Priority Insights` data pipeline and the `Store and search` data pipeline.

![](images/tco-5.png ':size=600')

⇨ [Continue to Conclusion](100-conclusion.md)
