# Getting started

In this lab, you will get a chance to learn and explore the IBM Cloud Logs service.

The lab setup includes an instance of IBM Cloud Logs that you will use to explore some of its features. Platform data, platform logs and auditing events are collected automatically. Logs generated by a Kubernetes cluster are also available. A logging agent is deployed on the Kubernetes cluster to collect and send logs to the IBM Cloud Logs instance. In addition, you will find the `app-log-analysis` app deployed in multiple namespaces. Each namespace is allocated to a student. You can use this app to generate your own logs.

![](images/setup.png ':size=600')

## Log in to IBM Cloud

1. Go to https://ibm.biz/1568-invite
1. Enter the `Username` and `Password` provided for the lab.
1. Click **Sign in**.
  ![](images/10-login.png ':size=600')
1. You are now logged in IBM Cloud.
  ![](images/10-logged.png ':size=600')

## Launch the IBM Cloud Logs UI

You launch the IBM Cloud Logs UI from the IBM Cloud console within the context of an instance.

1. Go to https://cloud.ibm.com/observability/logging
   * Alternatively, use the navigation menu: ☰ > Observability > Logging > Instances.
1. Click the **Cloud Logs** tab. The list of instances that are available on IBM Cloud is displayed.
1. Click **Open dashboard** for your instance.
1. The UI opens in a new browser tab.

⇨ [Explore the Cloud Logs UI](20-logs-ui.md)
