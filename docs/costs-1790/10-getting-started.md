# Part 1: Getting Situated

**Estimated time**: 15-20 minutes

## Learning Objectives
- Explore the IBM Cloud environment provisioned for this lab
- Understand the OpenShift (ROKS) cluster configuration
- Identify the applications running on the cluster
- Verify that monitoring is properly configured

Before we begin analyzing cost and sustainability metrics, it's essential to understand the environment that has been provisioned. In this section, you'll explore the deployed resources on IBM Cloud, verify the configuration of the OpenShift (ROKS) cluster, identify the applications running, and confirm that IBM Cloud Monitoring is active and collecting data. This baseline will provide the necessary context for the optimization work to come.

## Log in to IBM Cloud

1. Go to [https://ibm.biz/1970-login](https://ibm.biz/1970-login) in your browser.
2. Enter the `Username` and `Password` provided for the lab.
3. Click **Sign in**.
   ![Login screen](images/10-login.png ':size=600')
4. You are now logged in to IBM Cloud.
   ![Logged in view](images/10-logged.png ':size=600')

## View Project that Deployed ROKS

1. From the IBM Cloud dashboard, open **Projects**
   ![Main menu navigation](images/main%20menu.png ':size=400')

2. Click on the `Lab 1790` project used to deploy the cluster and other resources for the lab.
   ![Project list view](images/project-list.png ':size=600')

3. Click on the `Configurations` tab and then click on the overflow menu (three dots) next to the "cluster-and-monitoring" configuration. Select **Edit**.
   ![Configuration list](images/config-list.png ':size=600')

4. Review the deployment configuration to understand the components provisioned—such as the Red Hat OpenShift cluster, VPC networking, and monitoring. Open the inputs section to find important details like the worker machine type and number of workers per pool. You can also click on the "optional inputs" toggle to see additional configuration options.
   ![Configuration details](images/cluster-and-monitoring.png ':size=600')

5. Take note of the number of pool workers per zone, the number of zones, and the pool machine type as these inputs have a significant impact on the size and cost of the cluster.

6. This configuration is based on a reusable deployable architecture for [Landing zone for containerized applications with OpenShift](https://cloud.ibm.com/catalog/architecture/deploy-arch-ibm-slz-ocp-95fccffc-ae3b-42df-b6d9-80be5914d852-global) which is a great way to deploy a secure cluster.


## Survey account via the Resource List

1. Open the **Resource List** from the IBM Cloud main menu (top left in the header)
   ![Main menu navigation](images/main%20menu.png ':size=400')

2. Open up the containers, network, storage, and observability categories
   ![Resource list view](images/resource%20list.png ':size=600')

3. Identify key resources deployed for the lab, including:
   - The Lab-1790 OpenShift cluster
   - VPC and associated subnets
   - Load balancers and block storage
   - IBM Cloud Monitoring instance

4. This gives you a quick inventory of all cloud assets tied to the environment, which will be important when analyzing costs and optimization opportunities.

## View Cluster Configuration via Service Details

1. Click on the **Lab1790-openshift** cluster in the resource list to view the cluster details, including:
   - Cluster version and status
   - Number of worker nodes
   - Worker node types (e.g., `bx2.8x32`)
   - Node pools and zones
  ![Cluster in resource list](images/cluster%20in%20rex.png ':size=600')

2. Understanding these details helps in identifying opportunities for cost optimization or right-sizing. These details should match the project configuration we viewed earlier.

3. Finally, take note of the Cluster ID displayed in the cluster details `d1qnn2ud0c1g6mtpkpbg` as we will use that ID to identify this cluster later in the monitoring tools.

   ![Service details for cluster](images/cluster%20details.png ':size=600')


## Determine What Apps Are Running

1. Click the **OpenShift web console** button
   ![Open console button](images/cluster%20open%20console.png ':size=600')

2. Navigate to **Deployments** to view all deployed apps and services on the cluster
   ![OpenShift deployment view](images/os%20deployments.png ':size=600')

3. Select the **astro-shop** project from the project filter at the top left to filter to only the business-related apps
   - Have a look through the list to get a sense of the microservices deployed, such as e-commerce frontends, microservices, or analytics pipelines.

4. For each microservice listed in the deployments view, you can inspect the CPU and Memory limits by clicking on its name and then scrolling down to the containers section where you can see the settings for resource limits.
   ![Resource limits view](images/resource-limits.png ':size=600')

5. Under Networking → Routes, observe the URL for the astro-shop front end.
   ![OpenShift routes](images/os%20routes.png ':size=600')

6. Click through the link (you may have to click past some warnings as the Astroshop uses HTTP and not HTTPS) and view the example e-commerce application we are optimizing.
   ![Astroshop interface](images/astroshop.png ':size=600')

## Confirm IBM Cloud Monitoring Is Active

1. Return to the IBM Cloud resource list via the main menu
   ![Main menu navigation](images/main%20menu.png ':size=400')

2. Find the **IBM Cloud Monitoring** instance in the `Observability` section.

3. Click on the **Dashboard** link to open the monitoring dashboard.
   ![Cloud monitoring dashboard link](images/monitoring%20dashboard%20link.png ':size=600')

4. Click on Advisor → Overview → Clusters to view the cluster overview.
   ![Monitoring clusters view](images/cluster%20overview.png ':size=400')

5. If you see the lab cluster ID (should match the cluster ID we saw earlier on the cluster service details page - `d1qnn2ud0c1g6mtpkpbg`), then you know:
   - The monitoring agent is installed on the correct OpenShift cluster
   - Metrics are being collected

6. Then go to Advisor → Overview → Namespaces to see high-level information about the various namespaces (projects) running on the cluster. You can filter down to "astro-shop" to see only the namespace containing our business applications.
   ![Monitoring namespaces view](images/monitoring%20namespace%20overview.png ':size=600')

## Summary

In this section, you've:
- Logged into IBM Cloud and explored the lab environment
- Examined the OpenShift cluster configuration and resources
- Identified the running applications and their resource settings
- Verified that monitoring is properly configured

Now that you understand the environment, you're ready to analyze resource usage patterns and identify optimization opportunities in the next section.
