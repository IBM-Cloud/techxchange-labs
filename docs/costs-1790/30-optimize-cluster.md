# Part 3: Optimize apps & cluster

## Optimize Openshift app deployment configuration

In Openshift/Kubernetes the deployment configuration can include a requested amount for a resource (e.g. CPU, Memory) and a limit for those resources.  Kubernetes guarantees the requested amount of CPU and Memory for each component and will automatically restart any component that hits the specified resource limits.

Ideally, we tune the requested amount to something close, but just above typical use for each microservice.  This ensures that kubernetes allocates enough of the resource for the application to support its typical workload.  We don't want to request too much as that may prevent other workloads from accessing extra resources in a burst scenario.  We want to set the limits to a value high enough to address any likely burst scenario, but not so high that a microservice with a memory leak or other bug is able to consume too much of the cluster and starve other workloads that need burst capacity.

1. Navigate to the git repo where we have stored the cluster configuration for workload limits (in deployment.yaml): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
![gitlab repo](images/gitlab.png ':size=600')

1. Sign in to gitlab so that we can make changes.
![gitlab signin](images/gitlab-signin-png.png ':size=600')

1. Open the deployment.yaml file in the gitlab editor by clicking on the file name, pressing the edit button, and select "edit single file".  Make changes to update the limits to the new values you have figured out earlier for each of the workloads.
![gitlab edit](images/gitlab-edit.png ':size=600')

1. Start the commit process for the changes by pressing the commit button on the top left.  Be sure to select "commit to a new branch" and "Create a merge request for this change".  In gitlab a "pull request" is a "merge request".  We can later review the merge requests before adopting the changes.  Hit the "Commit changes" button.
![gitlab commit](images/gitlab-commit.png ':size=600')

1. Enter a commit description which explains why you made the changes ("xyz was over capacity", "not enough memory for jkl" for example) and then hit the "Create Merge Request" button.
![new commit](images/new-merge-request.png ':size=600')


## Optimize Openshift Cluster size

We created the cluster using a deployable architecture (DA) and IBM Cloud Project, so we will update the project's configuration of the DA to adjust the cluster size.  This configuration is stored in git as a json file.

We determine the ideal cluster size by adding up all of the requested resources for all workloads on the cluster (including base services like gateways, proxies, monitoring, etc) and adding some buffer for burst workloads.  This will give us a total amount of CPU and memory required.  The amount of CPU and Memory available to the cluster is a function of the size of each node - typically written something like 8x32 (8 CPU cores, by 32GB RAM) - and the number zones, and the number of nodes per zone.  A 3 zone cluster with 6 nodes per zone and bx2.8x32 nodes would have 3 * 6 * 8 = 144 CPU cores available.  Note that a single pod cannot use more than a single node's resources, so you can't set request or limit values above 8 CPU cores and 32GB RAM on a bx2.8x32 node.

Edit the project-config.json file to update the size of the cluster, making it larger or smaller as needed for optimal performance and efficiency. In this case we have a fixed number of zones for high availability (3) and will adjust the size of the nodes in the cluster and the number of nodes in each zone. If we have workloads where a single pod requires a lot of CPU or memory, then we may want to increase the size of the nodes.  If we need lots of instances of smaller pods, we may want to increase the number of nodes.  Alternatively, we may which to scale down using the same logic.

1. Navigate back to the home page of the git repo where we have stored the cluster configuration for workload limits (in project-config.json): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
![gitlab repo](images/gitlab.png ':size=600')

1. Open the project-config.json file in the gitlab editor by clicking on the file name, pressing the edit button, and select "edit single file".  Make changes to update the machine_type and number of workers per zone as needed.  You can find the list of available machine types in the [documentation](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles&interface=ui).
![gitlab edit config](images/gitlab-edit-config.png ':size=600')

1. Start the commit process for the changes by pressing the commit button on the top left.  Be sure to select "commit to a new branch" and "Create a merge request for this change".  In gitlab a "pull request" is a "merge request".  We can later review the merge requests before adopting the changes. Hit the "Commit changes" button.
![gitlab commit](images/gitlab-commit-2.png ':size=600')

1. Enter a commit message which explains why you made the changes ("cluster was larger than needed" for example) and then hit the "Create Merge Request" button.
![new commit](images/new-merge-request.png ':size=600')
