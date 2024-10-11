# Submit your first job

Let's submit the first job. This job will run interactively and `echo "Hello World"`.

LSF will schedule the job on any available dynamic compute node. If no dynamic compute node is available LSF will automtically provision a new compute node in IBM Cloud VPC. Since this is a shared cluster between all lab attendees it might be that the dynamic compute nodes are reused. This can be observed when the job returns with "Hello World" immediately.

An interactive job will connect to the remote host and execute the command "as if" it's executed in the local shell. This will allow users to interactively communicate with the command executable via standard input and output.

### Steps
1. Submit your first interactive job to execute `echo "Hello World"`
   ``` 
   bsub -Is echo "Hello World"
   ```
2. Wait until the job is dispatched and prints the result:
   ```
   Job <928> is submitted to default queue <interactive>.
   <<Waiting for dispatch ...>>
   <<Starting on hpc-demo-1-10-241-0-57>>
   Hello World
   ```
3. Navigate to [Virtual Server Instance for VPC](https://cloud.ibm.com/vpc-ext/compute/vs)
4. You can see one or multiple dynamic compute nodes 
   ![](./images/30-first-vsi.png ':size=600')
5. The job did not specify any resource requirements and there got dispatched on any of the compute nodes. 
6. Remember your job ID <928> and view the job details
   ```
   bjobs -w 928
   ```
7. In the output you can see the list of jobs, the hosts and queue
   ![](./images/30-bjobs.png ':size=600')
8. Look at the job details.
   ```
   bhist -l 928
   ```
9. The output show the time it took to dispatch and run the job in seconds.
   ![](./images/30-bhist.png ':size=600')

10. Finally you can list the view the provisioned compute hosts, you should see 1 or more additional host.
   - `closed_full` means, that the host is full or has been closed by the administrator
   - `ok` means, that the host has free slots available
   ```
   bhosts
   ```
   ![](./images/30-bhosts.png ':size=600')
11. Optionally, run a job to execute any other linux command on a dynamic compute node, e.g. `cat /proc/cpuinfo` or `htop` or `top` or `ls /mnt`, e.g.
   ``` 
   bsub -Is cat /proc/cpuinfo
   ```

   

?> **Congratulations!** You just submitted your first job in the IBM Cloud HPC environment!
