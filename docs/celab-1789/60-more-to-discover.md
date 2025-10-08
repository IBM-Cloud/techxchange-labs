# More to discover

There are more capabilities built in Code Engine to help you build and deploy your applications. Several are highlighted below.

## Fleets

As artificial intelligence continues to grow and demand for cloud-based solutions increases, the ability to run large-scale, compute-intensive workloads both quickly and efficiently has become critical.

A fleet (also referred to as a serverless fleet) is a Code Engine compute resource that runs one or more instances of user code in parallel to process a large set of compute-intensive tasks.

Fleets can connect to Virtual Private Clouds (VPCs) to securely access user data and services. They provide single-tenant isolation, and support for GPU workloads.

A fleet automatically deploys and removes a collection of worker nodes on top of which instances of user code complete their associated tasks. Each worker hosts one or more instances and as soon as an instance finishes working on its task a new instance is started in its place to work on one of the pending tasks. This process continues until all tasks are finished.

The profiles and quantities of worker nodes can be automatically chosen by Code Engine to best match the instance resource and scaling parameters. Alternatively, users can require a specific worker profile to be used, for example one that contains a desired GPU capability. In those cases, Code Engine deploys only worker nodes with the user-specified profile and deploys them in the quantity required to match the instance resource and scaling settings.

Fleets offer the following advantages:

* Support for large-scale parallel computing tasks, with no limits on vCPU, memory, or task duration.
* Automatic, dynamic scaling—from a single task to millions of tasks.
* Consumption-based pricing: pay only for the resources you use, with no idle or fixed costs.
* Fully managed service—no infrastructure administration required.
* Broad machine type support, including GPU-enabled instances.
* Seamless integration with your VPC network.

## Batch jobs

A job in Code Engine runs one or more instances of your executable code. Unlike applications, which handle HTTP requests, jobs are designed to run one time and exit, such that the resources to run the job workload are freed up.

You can scale batch jobs by defining multiple instances. Workloads can be split into parallel tasks to reduce compute time. You can set the job to run with automatic retry to address failing workloads within a job instance. You can trigger batch jobs manually, programmatically, and by events, such as Object Storage events.

When you create a job, you can specify the workload configuration information that is used each time that the job is run.

Typical batch job workloads include,

* machine model training
* analyzing files, such as voice analysis or image recognition
* compressing or decompressing files
* archiving information

When you create a job, you can specify workload configuration information that is used each time that the job is run.

## Custom domains

Domain mappings provide the URL route to your Code Engine applications within a project. With Code Engine, these mappings are automatically created, by default, whenever you deploy an application. However, you can map your own custom domain to a Code Engine application to route requests from your custom URL to your application.

If you want to target your application with a domain that you own, you can use a custom domain mapping. When you set a custom domain mapping in Code Engine, you define a 1-to-1 mapping between your fully qualified domain name (FQDN) and a Code Engine application in your project.

You can configure custom domains from the **Domain mappings** page for your specific application.

![](images/60-custom-domains.png ':size=400')

To learn more about using custom domains, see [Configuring custom domain mappings for your app](https://cloud.ibm.com/docs/codeengine?topic=codeengine-domain-mappings).

## Subscribe to events

Oftentimes in distributed environments you want your applications or jobs to react to messages (events) that are generated from other components, which are usually called event producers. With Code Engine, your applications or jobs can receive events of interest by subscribing to event producers. Event information is received as POST HTTP requests for applications and as environment variables for jobs.

Code Engine supports the following types of event producers:
* **Cron** - The cron event producer is based on cron and generates an event at regular intervals. Use a cron event producer when an action needs to be taken at well-defined intervals or at specific times.
* **IBM Cloud Object Storage** - The Object Storage event producer generates events as changes are made to the objects in your object storage buckets. For example, as objects are added to a bucket, an application can receive an event and then perform an action based on that change, perhaps consuming that new object.
* **Kafka** - The Kafka event producer watches for new messages to appear in a Kafka instance. When you create a Code Engine Kafka subscription for a set of topics, your app or job receives a separate event for each new message that appears in one of the topics.

To learn more about subscriptions, see [Getting started with subscriptions](https://cloud.ibm.com/docs/codeengine?topic=codeengine-subscribing-events).

⇨ [Continue to Conclusion](70-conclusion.md)