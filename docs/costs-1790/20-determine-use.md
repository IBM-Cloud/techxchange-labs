# Part 2: Determine use patterns

In this part of the lab, you’ll use IBM Cloud Monitoring (powered by Sysdig) to analyze how the deployed applications are using compute and storage resources over time. This analysis is foundational for identifying right-sizing opportunities and ensuring workloads are neither over-provisioned nor resource-constrained.

## Launch IBM Cloud Monitoring

1. From the IBM Cloud main menu (top left) select Observability->Monitoring
![monitoring menu](images/monitoring%20menu.png ':size=400')
1. Launch the 'lab 1790' IBM Cloud Monitoring instance by clicking on the 'dashboard' link.
![Launch dashboard](images/monitoring%20dashboard%20link.png ':size=600')

## Locate and Monitor the Cluster

1. Once in the Sysdig interface, select **Advisor** - kubernetes troubleshooting from the menu on left to get a view of the kubernetes (and openshift) clusters which are being monitored.
![Advisor menu](images/advisor-menu.png ':size=400')
1. Select our lab cluster based on the ID we found in part 1 and then click on the "astro-shop" project/namespace so that we can see the overall status of our commerce application.  The other namespaces are used by various services that secure, operate, and administer the openshift cluster - we aren't looking to optimize them at this time.
![Advisor dashboard](images/advisor-kub-dash.png ':size=600')
1. Explore this dashboard to see any trends or behavior of interest


## Analyze Resource Usage vs Requests and Limits

1. From the Dashboards menu on the left, select the "Pod Rightsizing & Workload Capacity" dashboard
![Rightsizing menu](images/pod-rightsizing-menu.png ':size=400')
1. Use the filters at the top to select the correct cluster and project/namespace (astro-shop).
![Rightsizing filters](images/rightsizing-filters.png ':size=600')
1. Explore the information provided.  Here is where we can see how the set of microservices that make up the astro-shop are using resources relative to what the cluster is configured to provide.
1. Note any services that don't have limits defined.  Services without limits are constrained by cluster default limits which may not be appropriate for the workload.  These cluster defaults are 1CPU / 8Gi RAM unless overridden to something else.
![unlimited workloads](images/unlimited-workloads.png ':size=600')
1. Ensure the timescale (at the bottom of the page) is set to a week or two so that you are looking at sufficient data to see cpu and memory trends.
![Monitoring timescale](images/timescale.png ':size=600')
1. Step through the list of astro-shop workloads using the filters at the top.  Look for any signs of services hitting memory limits and restarting.  Find any workloads with a lot more cpu or memory requested than used (and thus wasted capacity)
![Rightsizing filters](images/rightsizing-filters.png ':size=600')



### Identify CPU, Memory, and Ephemeral Storage Usage

- Use **Dashboards > Kubernetes Overview** or **Dashboards > Workload Resources**.
- Examine:
  - **Requested vs Actual CPU**
  - **Requested vs Actual Memory**
  - **Requested vs Actual Ephemeral Storage (if available)**

### Compare Against Defined Resource Limits

- Look for **Resource Limits** metrics under each deployment or pod:
  - CPU limits
  - Memory limits
  - Ephemeral storage limits

### Document Optimization Opportunities

While reviewing usage data:

- ✅ **Flag workloads with large gaps** between requested and actual usage.
  - These are often over-provisioned and may be good candidates for right-sizing.
- ⚠️ **Identify workloads consistently near or exceeding limits.**
  - These may need to be scaled up or have higher limits set to avoid performance degradation or restarts.
- Optional: Take screenshots or export metrics for reference in later lab sections.

## Summary

By the end of this step, you should have a good understanding of how each application is consuming resources relative to what has been allocated. This insight is essential for the next phase: applying FinOps and GreenOps strategies to optimize resource usage and reduce waste.
