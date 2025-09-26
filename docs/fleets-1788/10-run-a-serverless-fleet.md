# Run a Serverless Fleet

In this section you will run a Serverless Fleet in just a few clicks. 

## Log in to IBM Cloud

1. Go to https://ibm.biz/1788-login
1. Enter the `Username` and `Password` provided for the lab.
1. Click **Sign in**.
  ![](images/10-login.png ':size=600')
1. Select the **Trusted Profile**
  ![](images/10-select-trusted-profile.png ':size=600')
1. You are now logged in IBM Cloud.
  ![](images/10-logged.png ':size=600')

In this lab, the project, VPC subnet, and persistent data stores have been pre-configured for you.
1. Navigate to the **Resource List**
  ![](images/10-select-resource-list.png ':size=600')
1. Filter the resource by **Resource Group**
  ![](images/10-filter-resources.png ':size=600')


## Run a Fleet

In this first example, you will run a very simple fleet with just a few clicks to understand the concepts of Tasks, Instances and Workers. 

1. Go to https://cloud.ibm.com/containers/serverless/overview
   * Alternatively, use the navigation menu to go to the Code Engine Overview page: **☰ > Containers > Serverless > Get started**.
1. Click **Start creating**.
  ![](images/10-landing.png ':size=600')
1. In the dropdown make sure you select your **project**, e.g. `fleetlab-user1--ce-project`
1. Select **Fleet**
  ![](images/10-select-project.png ':size=600')
1. Set the **Name** of the fleet to something unique like `<your-username>-helloworld-fleet`. 
   * As example `fleetlab-user1-helloworld-fleet`.
1. Review the **Code** section - 
   * **Container image reference** - This example fleet runs a pre-built sample image that is publicly available in the IBM Cloud Container Registry (`icr.io/codeengine/helloworld`). For your own workloads, you can use a custom container image or build directly from a source code repository. Because this example uses a public image, no registry access is required. (In other cases, you might need to configure a registry access secret.)
   * **Image start options** - Use these settings to override which command is executed within the container. In this example, we don't need to override the command and use the command in the *helloworld* image, which is simply printing a few log lines. 
1. In the **Tasks** section
   ![](images/10-select-tasks.png ':size=600')
   * Set the **Number of Tasks** to `100` - In this example, you will run the helloworld code 100 times by submitting it as multiple tasks. As you progress through the lab, you will explore additional methods for submitting tasks.
   * Set the **Task state store** to `fleet-task-store` - The task state store is used to persist task processing information. In this example, a persistent data store has already been pre-configured.
1. In the **Resources & Scaling** section:
   ![](images/10-select-scaling.png ':size=600')
   * **Instance resource** - Select `1 vCPU` and `2 GB` of memory for each instance that will process a task.
   * **Scaling Settings** - Set the *Maximum number of concurrent instances* to `10`
1. Review the remaining sections:
   * **Network placement** - You can configure the subnets and zones into which the fleet workers are deployed. This lab uses a pre-configured subnet in zone 1.
   * **Environment variables** - You can use these settings to inject configuration key-value pairs into your running code.
1. Click **Create**.


## Watch the Fleet Details

1. After a short time, **your fleet is running**. 
   ![](./images/10-fleet-pending-tasks.png ':size=600')
1. View the **Tasks** tab:
   * **Index** - Each task is assigned a task index ranging from 0 to {N - 1}, where N is the total number of tasks specified for the fleet. In this example, the task indices range from 0 to 99.
   * **Status** - A task can have one of the following statuses:
     * **Pending** - Task is waiting in the queue and has no associated instance. (No instance is started on behalf of this task.)
     * **Running** - The task has exactly one associated instance running. Running tasks show the worker identifier that they are running on.
     * **Succeeded** - The last instance started on behalf of this task ended successfully. 
     * **Failed** - The last instance started on behalf of this task failed and the fleet’s retry limit has been exhausted for this task.
     * **Cancelled** - The fleet has been cancelled by user action before this task could reach status succeeded or failed.
   * You can filter the tasks by clicking on the status or enter a search text
1. View the **Workers** tab:
   * Code Engine automatically identifies the optimal profiles and provisions the required number of fleet workers. In this example, two workers are provisioned with a total of 10 vCPUs, allowing 10 concurrent instances, each with 1 vCPU.
   * The list shows the worker, their profile and IP address in the selected subnet and zone.
   * At this point Code Engine charges the account for the CPU and Memory of the workers.
   * A fleet worker can have the following status:
     * **Pending** - The worker is being provisioned in the infrastructure
     * **Initializing** - The worker has been provisioned and fleet components are initilizing 
     * **Running** - The worker is running and processing tasks.
     * **Failed** - The worker could not be provisioned or the iniliziation failed.
    ![](./images/10-fleet-pending-workers.png ':size=600')
1. Review the **Configuration** tab to see the fleet details:
   * Click through the **Code**, **Tasks**, **Resources & Scaling** and **Network placement** sections
   ![](./images/10-fleet-details-code.png ':size=600')
1. Go back to the **Tasks** tab and click on the Status **Running** and **Successful** to filter the tasks
   * You can notice that 20 tasks are running and some tasks already succeeded.
   ![](./images/10-fleet-tasks-running.png ':size=600')
1. Review the **Workers** tab and notice that the workers are running. 
   ![](./images/10-fleet-workers-running.png ':size=600')
1. Wait until the workers are deleted
   * At this point Code Engine stopped charging the account.
   ![](./images/10-fleet-workers-deleted.png ':size=600')
1. Go back to the **Tasks** tab and notice that all tasks succeeded.
   ![](./images/10-fleet-tasks-successful.png ':size=600')
1. Click on **Fleets** in the top navigation. You see the list of fleets with an indication of their tasks and status.
   ![](./images/10-fleet-breadcrump.png ':size=600')
1. Wait until the Fleet has been finished and all tasks succeeded
   ![](images/10-fleet-complete.png ':size=600')
1. (optional) if this was too fast, repeat the steps and run with `500` tasks

?> **Congratulations!** You’ve successfully launched your first serverless fleet on IBM Cloud! Now, let’s move on to running a more realistic AI workload.


⇨ [Run a Serverless Fleet to process documents with Docling](20-docling.md)
