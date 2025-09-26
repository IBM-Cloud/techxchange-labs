# Simplify and optimize large-scale parallel computation with Serverless Fleets

As artificial intelligence continues to grow and demand for cloud-based solutions increases, the ability to run large-scale, compute-intensive workloads both quickly and efficiently has become critical.

In this hands-on lab, you will deploy your first Serverless Fleet on IBM Code Engine—IBM’s strategic container platform designed to handle large-scale, compute-intensive workloads.

Using both the intuitive graphical user interface and the command line, you will be guided step by step through the process. With just three clicks, you will have a Serverless Fleet up and running on IBM Cloud.

![](./images/readme-lab-architecture.png ':size=600')

## Key differentiators of Fleets

Fleets offer the following advantages:
1.	Support for large-scale parallel computing tasks, with no limits on vCPU, memory, or task duration.
2.	Automatic, dynamic scaling—from a single task to millions of tasks.
3.	Consumption-based pricing: pay only for the resources you use, with no idle or fixed costs.
4.	Fully managed service—no infrastructure administration required.
5.	Broad machine type support, including GPU-enabled instances.
6.	Seamless integration with your VPC network.


## What is a fleet

![](./images/readme-concept.png ':size=800')

A fleet (also referred to as a serverless fleet) is a Code Engine compute resource that runs one or more instances of user code in parallel to process a large set of compute-intensive tasks.

Fleets can connect to Virtual Private Clouds (VPCs) to securely access user data and services. They provide single-tenant isolation, and support for GPU workloads.

A fleet automatically deploys and removes a collection of worker nodes on top of which instances of user code complete their associated tasks. Each worker hosts one or more instances and as soon as an instance finishes working on its task a new instance is started in its place to work on one of the pending tasks. This process continues until all tasks are finished.

The profiles and quantities of worker nodes can be automatically chosen by Code Engine to best match the instance resource and scaling parameters. Alternatively, users can require a specific worker profile to be used, for example one that contains a desired GPU capability. In those cases, Code Engine deploys only worker nodes with the user-specified profile and deploys them in the quantity required to match the instance resource and scaling settings.

Like applications, jobs, and functions, fleets run within a Code Engine project. A project is a grouping of Code Engine resources within a specific IBM Cloud region. Projects are used to organize resources and manage access to entities such as configmaps, secrets, and persistent data stores.


⇨ [OK, time to jump in and run a Serverless Fleet yourself!](./10-run-a-serverless-fleet.md)
