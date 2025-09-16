# Part 2: Determine Use Patterns

**Estimated time**: 20-25 minutes

## Learning Objectives
- Use IBM Cloud Monitoring to analyze resource usage patterns
- Identify over-provisioned and under-provisioned workloads
- Analyze resource requests versus actual usage
- Evaluate cluster capacity and sizing

In this part of the lab, you'll use IBM Cloud Monitoring (powered by Sysdig) to analyze how the deployed applications are using compute and storage resources over time. This analysis is foundational for identifying right-sizing opportunities and ensuring workloads are neither over-provisioned nor resource-constrained.

> **Key Concept**: In Kubernetes, **resource requests** specify the minimum amount of resources guaranteed to a container, while **resource limits** define the maximum amount it can use. Properly setting these values is crucial for both application performance and cluster efficiency.

## Launch IBM Cloud Monitoring

1. From the IBM Cloud main menu (top left) select Observability → Monitoring
   ![Monitoring menu navigation](images/monitoring%20menu.png ':size=400')

2. Launch the 'lab 1790' IBM Cloud Monitoring instance by clicking on the 'dashboard' link.
   ![Launch dashboard link](images/monitoring%20dashboard%20link.png ':size=600')

## Locate and Monitor the Cluster

1. Once in the Monitoring Dashboard interface, select **Advisor** - Kubernetes troubleshooting from the menu on left to get a view of the Kubernetes (and OpenShift) clusters which are being monitored.
   ![Advisor menu](images/advisor-menu.png ':size=400')

2. Select our lab cluster based on the ID (`d1qnn2ud0c1g6mtpkpbg`) we found in Part 1 and then click on the "astro-shop" project/namespace so that we can see the overall status of our commerce application. The other namespaces are used by various services that secure, operate, and administer the OpenShift cluster - we aren't looking to optimize them at this time.
   ![Advisor dashboard](images/advisor-kub-dash.png ':size=600')

3. Explore this dashboard to see any trends or behavior of interest. Look for any spikes in resource usage or potential issues that might indicate optimization opportunities.


## Analyze Resource Usage vs Requests and Limits

1. From the Dashboards menu on the left, select the "Pod Rightsizing & Workload Capacity" dashboard
   ![Rightsizing menu](images/pod-rightsizing-menu.png ':size=400')

2. Use the filters at the top to select the correct cluster and project/namespace (astro-shop).
   ![Rightsizing filters](images/rightsizing-filters.png ':size=600')

3. Explore the information provided. Here is where we can see how the set of microservices that make up the astro-shop are using resources relative to what the cluster is configured to provide.

4. Note any services that don't have limits defined. Services without limits are constrained by cluster default limits which may not be appropriate for the workload. These cluster defaults are 1CPU / 8Gi RAM unless overridden to something else.
   ![Unlimited workloads](images/unlimited-workloads.png ':size=600')

5. Ensure the timescale (at the bottom of the page) is set to a week or two so that you are looking at sufficient data to see CPU and memory trends.
   ![Monitoring timescale](images/timescale.png ':size=600')

6. Step through the list of astro-shop workloads using the filters at the top. Look for any signs of services hitting memory limits and restarting. Find any workloads with a lot more CPU or memory requested than used (and thus wasted capacity).
   ![Rightsizing filters](images/rightsizing-filters.png ':size=600')
### Example Analysis: Frontend Service

1. Let's look at the "frontend" deployment - this service renders the website and acts as an API gateway. It is clearly critical for the operation of our e-commerce application. We need to answer these questions:
   - How much CPU and RAM is it requesting?
   - What are the CPU and RAM limits set to?
   - Are we using the requested amounts?
   - Is the service getting near or hitting the limits?

2. Select "frontend" in the workload filter and look at the unused requested CPU and Memory
   ![Unused resources](images/front-end-unused.png ':size=600')

   **Observation**: We can see that the frontend is requesting a lot more resources than it typically uses - this is something to correct.

3. Look at the CPU and Memory limits vs used
   ![Resource Limits](images/front-end-limits.png ':size=600')

   **Observation**: We can also see that the frontend doesn't seem to have very bursty traffic (but double check over a week-long time frame) and isn't near to hitting its limits. We could probably lower the limits as well, but perhaps for the frontend we should leave the limits high just in case.

### Example Analysis: Product Catalog Service

1. Now have a look at the "product-catalog" service. This service is responsible for tracking inventory and which products are available. Select "product-catalog" in the workload filter (be sure to remove "frontend" so you can focus on the single service.)
   ![Unused resources](images/catalog-unused.png ':size=600')

   **Important**: Make sure to have a 12h or 24h time window so you can see there is some spiky load on this service. In fact, it is going way over its requested CPU and Memory during these bursts of load. Given that this load is infrequent, we may not want to raise the requested amounts to cover this.

2. Look at the limits section for the service (near the bottom)
   ![Resource Limits](images/catalog-limits.png ':size=600')

   **Observation**: Here we can see that the bursts of load are causing the service to hit its CPU limit and get close to its RAM limit. If we don't want to limit performance during bursts, we should raise the CPU limit and consider raising the Memory limit to avoid having the service get killed when it runs out of memory.

### Document Optimization Opportunities

1. Work your way through the remaining services in the astro-shop noting if there are any other changes that should be made.

2. Record (on paper or electronically) any changes you think should be made. Consider these aspects for each service:
   - Is the service over-provisioned (requesting more resources than needed)?
   - Is the service under-provisioned (hitting resource limits)?
   - Are there any services without defined limits that should have them?
   - Are there any services with unusual usage patterns that need special consideration?

## Analyze cluster sizing

1. From the Dashboards menu on the left, select the "Cluster Capacity Planning" dashboard. The section called "Total requests" adds up the amount of CPU and Memory requested by all of the services on the cluster.
   ![Cluster capacity planning](images/cluster-capacity.png ':size=600')

   Look to see if the cluster has sufficient capacity for all the requested resources, or perhaps has too much capacity.

2. Scroll down to the "Limit overcommit" section. This section tells us if we add up the limits for all of our services, would the cluster be overloaded?
   - If not, the cluster is definitely oversized.
   - If the cluster is limit over-committed, we need to consider if it is possible for all services to hit their limits at the same time. If not, it is likely ok if the cluster is slightly over-committed.

   ![Cluster limits overcommit](images/cluster-limit-overcommit.png ':size=600')

3. Record any adjustments you would make to the cluster size, considering:
   - Current CPU and memory utilization
   - Projected growth needs
   - High availability requirements
   - Cost optimization goals


## Summary

By the end of this step, you should have a good understanding of how each application is consuming resources relative to what has been allocated. You've analyzed:

- Resource usage patterns for key microservices
- Identified over-provisioned and under-provisioned workloads
- Evaluated overall cluster capacity and sizing

This insight is essential for the next phase: applying FinOps and GreenOps strategies to optimize resource usage and reduce waste. In the next section, you'll implement the changes you've identified to optimize both the application configurations and the cluster itself.
