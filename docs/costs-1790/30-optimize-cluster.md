# Part 3: Optimize Apps & Cluster

**Estimated time**: 15-20 minutes

## Learning Objectives
- Apply the resource optimization insights from your analysis
- Update application deployment configurations with appropriate resource settings
- Optimize cluster size based on workload requirements
- Create merge requests to implement your changes

## Optimize OpenShift App Deployment Configuration

In OpenShift/Kubernetes, the deployment configuration can include a requested amount for a resource (e.g., CPU, Memory) and a limit for those resources. Kubernetes guarantees the requested amount of CPU and Memory for each component and will automatically restart any component that hits the specified resource limits.

Ideally, we tune the requested amount to something close, but just above typical use for each microservice. This ensures that Kubernetes allocates enough of the resource for the application to support its typical workload. We don't want to request too much as that may prevent other workloads from accessing extra resources in a burst scenario. We want to set the limits to a value high enough to address any likely burst scenario, but not so high that a microservice with a memory leak or other bug is able to consume too much of the cluster and starve other workloads that need burst capacity.

> **Best Practice**: For production workloads, set resource requests at approximately 1.5x the observed average usage, and set limits at 2-3x the average usage (depending on how bursty the workload is).

### Update Application Resource Settings

1. Navigate to the Git repo where we have stored the cluster configuration for workload limits (in deployment.yaml): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
   ![GitLab repository](images/gitlab.png ':size=600')

2. Login to GitLab, by clicking **Sign in** at the top right so that we can make changes.
   ![GitLab sign in](images/gitlab-signin-png.png ':size=600')

3. Open the deployment.yaml file in the GitLab editor by clicking on the file name, pressing the edit button, and select "edit single file". Make changes to update the limits to the new values you have figured out earlier for each of the workloads.
   ![GitLab edit file](images/gitlab-edit.png ':size=600')

4. Start the commit process for the changes by pressing the commit button on the top left. Be sure to select "commit to a new branch" and "Create a merge request for this change". In GitLab, a "pull request" is called a "merge request". We can later review the merge requests before adopting the changes. Hit the "Commit changes" button.
   ![GitLab commit changes](images/gitlab-commit.png ':size=600')

5. Enter a commit description which explains why you made the changes ("frontend was over-provisioned", "product-catalog needs higher CPU limits for burst traffic", etc.) and then hit the "Create Merge Request" button.
   ![New merge request](images/new-merge-request.png ':size=600')


## Optimize OpenShift Cluster Size

We created the cluster using a deployable architecture (DA) and IBM Cloud Project, so we will update the project's configuration of the DA to adjust the cluster size. This configuration is stored in Git as a JSON file (and also available through the project UI).

### Calculating Optimal Cluster Size

We determine the ideal cluster size by:

1. Adding up all of the requested resources for all workloads on the cluster (including base services like gateways, proxies, monitoring, etc.)
2. Adding some buffer for burst workloads (typically 20-30%)
3. Calculating the total amount of CPU and memory required

The amount of CPU and Memory available to the cluster is determined by:
- The size of each node - typically written something like bx2.8x32 (8 CPU cores, 32GB RAM)
- The number of zones (for high availability)
- The number of nodes per zone

For example, a 3-zone cluster with 6 nodes per zone and bx2.8x32 nodes would have 3 × 6 × 8 = 144 CPU cores available.

> **Important**: A single pod cannot use more than a single node's resources, so you can't set request or limit values above 8 CPU cores and 32GB RAM on a bx2.8x32 node.

Some useful options for node size could be bx2.4x16, mx2.4x32, cx2.8x16, bx2.16x64.  A full list of available worker node sizes is available in the [documentation for VPC based clusters in Dallas](https://cloud.ibm.com/docs/openshift?topic=openshift-vpc-flavors).

### Updating Cluster Configuration

Edit the project-config.json file to update the size of the cluster, making it larger or smaller as needed for optimal performance and efficiency. In this case, we have a fixed number of zones for high availability (3) and will adjust the size of the nodes in the cluster and the number of nodes in each zone.

- If we have workloads where a single pod requires a lot of CPU or memory, then we may want to increase the size of the nodes.
- If we need lots of instances of smaller pods, we may want to increase the number of nodes.
- Alternatively, we may wish to scale down using the same logic.

1. Navigate back to the home page of the Git repo where we have stored the cluster configuration for workload limits (in project-config.json): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
   ![GitLab repository](images/gitlab.png ':size=600')

2. Open the project-config.json file in the GitLab editor by clicking on the file name, pressing the edit button, and select "edit single file". Make changes to update the machine_type and number of workers per zone as needed.
   ![GitLab edit config](images/gitlab-edit-config.png ':size=600')

3. Start the commit process for the changes by pressing the commit button on the top left. Be sure to select "commit to a new branch" and "Create a merge request for this change". In GitLab, a "pull request" is a "merge request". We can later review the merge requests before adopting the changes. Hit the "Commit changes" button.
   ![GitLab commit changes](images/gitlab-commit-2.png ':size=600')

4. Enter a commit message which explains why you made the changes ("Reduced cluster size to match actual workload requirements" or "Optimized node size for better resource utilization") and then hit the "Create Merge Request" button.
   ![New merge request](images/new-merge-request.png ':size=600')

## Summary

In this section, you've:
- Updated application deployment configurations with optimized resource requests and limits
- Adjusted the cluster size based on your workload analysis
- Created merge requests to implement your changes

These optimizations will help reduce costs and improve resource utilization. In the next section, we'll explore how these changes impact the environmental footprint of your cloud resources.
