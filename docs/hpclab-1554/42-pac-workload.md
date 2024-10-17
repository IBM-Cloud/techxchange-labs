# Use Application Center Web UI

[IBM Spectrum LSF Application Center](https://www.ibm.com/docs/en/slac/10.1.0) provides a flexible, easy to use interface for cluster users and administrators. Available as an add-on module to IBM Spectrum LSF, IBM Spectrum LSF Application Center enables users to interact with intuitive, self-documenting standardized interfaces.

The application center can be optionally enabled in the deployable architecture of IBM Cloud HPC. The application center will be installed on the management node. LDAP can be enabled optionally. Let's explore...


### Steps

1. Open the [LSF Application Center](https://ibm.biz/1554-appcenter)
   - Press **Accept** when a certificate warning pops up since the demo environment is using a floating IP to access the Application Center.
2. Login with your username and password
   ![](./images/42-pac-login.png ':size=600')
3. Navigate to **Workloads** to see the submitted jobs in pending (yellow) or running (green) state
   ![](./images/42-pac-workloads-pending.png ':size=600')
4. Click on the link in the job **ID** column to open the **Summary** view
   ![](./images/42-pac-workloads-summary.png ':size=600')
5. Click on the link in the job **Name** column or click on **Jobs** to list the individual tasks of the job
   ![](./images/42-pac-workloads-jobs.png ':size=600')
6. Review the resources and dynamic compute nodes by clicking on **Resources**
   ![](./images/42-pac-workloads-dashboard.png ':size=600')
7. Let's have a look:
   - Under the **Cluster** section the administrator sees an overview of the hosts in the cluster and their states
   - Under the **Workload** section the administrator has an overview of the running and pending and completed workload in the cluster
   - Under the **CPU**, **Memory**, **Local Disk** section the administrator can play with thresholds and see the number of hosts below/above the threshold  
   - Under the **User License** and **User Sessions** section, the administrator can observe the number of active users
8. Navigate to **Hosts** to view the list of hosts that joined the cluster
   ![](./images/42-pac-workloads-hosts.png ':size=600')
9. The **Hosts** view complements the list of [Virtual server instance for VPC](https://cloud.ibm.com/infrastructure/compute/vs). It shows
   - the status from a workload perspective (full, ok)
   - the number of available slots vs the number of slots in use
   - the CPU and Memory usage
10. Going back to **Workloads** the job should be either still running
   ![](./images/42-pac-workloads-running.png ':size=600')
11. Wait for the jobs to complete
   ![](./images/42-pac-workloads-done.png ':size=600')
11. (Optionally) Go back to [Run and monitor HPC workload](40-hpc-workload) and continue with step 10.
12. If the job is still running and you're done with all sections, you can also kill the job and continue with exploring Queues
   ![](./images/42-pac-workloads-kill.png ':size=600')


?> **Congratulations!** You just explored the LSF Application Center from a User's and Administrator's point of view!
