# Run and monitor HPC workload

Let's burn some CPU cycles and see how LSF is starting dynamic compute nodes. Therefore, you will run a job with 10 tasks, where each tasks is running a scripts that uses `stress-ng` to utilize 1 vCPU for 10 min. This job submission will require 10 vCPUs in total.

The HPC cluster is configured with a default machine profile of bx2-4x16 and therefore, the scheduler will provision 3 new VSIs with 12 vCPU in total to satisfy the request and distribute the 10 tasks on 10 vCPUs. 2 vCPUs will remain idle and can be used by another users task.

The idle-timeout of the cluster is configured to be 10 min. So, after 20 min, the cluster will delete the dynamic compute nodes.

?> Note, that this is a shared cluster between all lab attendees. Therefore, it might be that the dynamic compute nodes are reused and not being newly provisioned or deleted.

### Steps

1. Show the application script which executed the *stress-ng* tool.
   ```
   cat /mnt/binaries/stress.sh
   ```
2. Submit 10 jobs with name *job-vcpu[1-10]* and remember the Job <ID> from the output, i.e. 1989

   ```
   bsub -J job-vcpu[1-10] -n 1 -R "span[ptile=1]" -R "select[family=balanced]" /mnt/binaries/stress.sh
   ```
   ![](./images/40-bsub.png ':size=600')
3. Let's understand what we just did:
   - **job-vcpu[1-10]** - launched 10 jobs with the name job-vcpu-1, job-vcpu-2,... 
   - **-n 1** - each job runs 1 task
   - **-R "span[ptile=1]"** - specify the resource requirements for each task to span 1 vCPU
   - **-R "select[family=balanced]"** - specify the machine family to be balanced with a 1:4 ratio between vCPU and memory, i.e. `bx2-4x16`
   - **/mnt/binaries/stress.sh** - the command to execute from the shared filesystem which get's mounted into each host
4. List the job and it's task.
   ```
   bjobs -W 1989
   ```
5. The output shows the 10 jobs, their status and their slot allocation:
    - `USER` the user column shows the user that submitted the job
    - `STAT` shows the status of the job and weather it's (1) pending `PEND` or (2) running `RUN` or (3) done `DONE`
   ![](./images/40-bjobs-detail.png ':size=600')
6. The LSF scheduler is now looking for a dynamic compute nodes that are satisfying the request of 10 vCPU, e.g. 10 x 1 VCPU. It requests 3 dynamic compute nodes, e.g. `Target: 3`
   ```
   badmin rc view
   ```
7. Navigate to [Virtual server instance for VPC](https://cloud.ibm.com/infrastructure/compute/vs) and notice that 3 dynamic nodes with 4 vCPU and 16 GB are provisioned, i.e. 3 x 4 = 12 vCPU.
   ![](images/40-dynamic-nodes.png ':size=600')
8. Watch the number of hosts in the cluster and observe how the new VSIs are joining the cluster (Close with `CTRL-C`)
   - Each row shows a host of the cluster.
   - `STATUS` shows if the host has slots available (`ok`) or if all slots are occupied (`closed`)
   - `MAX` column shows the number of slots. Since we have a `bx2-4x16`, each dynamic host has `4` slots
   - `NJOBS` how many jobs are running in the host
   - `RUN` how many slots are used
   ```
   watch -n 2 bhosts -w
   ```
   ![](./images/40-bhosts.png ':size=600')
9. (Optional) If it takes too long until the dynamic hosts join the cluster, you can jump to [Use Application Center UI](42-pac-workload)
10. Watch the progress of the job and repeat the command a couple of times.
    ```
    bjobs -A 1989
    ```
11. The jobs switching from pending into running.
   ![](./images/40-bjobs.png ':size=600')
12. The job will run for 10 min
13. Watch the load of the cluster
    ```
    lsload -aw | grep -v unavail | grep -v mgmt
    ```
14. The output will show you the load of the dynamic compute nodes. You can see the utilization in the `ut` column
   ![](./images/40-lsload.png ':size=600')
15. Launch an interactive job that shows `htop` on one of the hosts. (Exit with `q`). 
    ```
    bsub -Is -n 1 -R "select[family=balanced]" htop
    ```
    ![](images/40-htop2.png ':size=600')
16. Optionally, try to identify the host with the highest `ut` from the `lsload -aw` ouput and run the `htop` on that host using `-m <hostname>`.
    ```
    bsub -Is -n 1 -m hpc-demo-1-10-241-1-28 htop
    ```
17. Since we burn 10 vCPU you will notice that the utilization of 2 hosts is 100% (2 x 4 vCPU), while 1 host has a utilization of just 50% (1 x 2vCPU)
   ```
   HOST_NAME               status  r15s   r1m  r15m   ut    pg  ls    it   tmp   swp   mem   
   hpc-demo-1-10-241-1-29      ok   2.6   2.0   0.9  50%   0.0   0     7   78G    0M 14.6G
   hpc-demo-1-10-241-1-28      ok   4.0   4.0   1.7 100%   0.0   0     8   78G    0M 14.6G
   hpc-demo-1-10-241-1-27      ok   4.0   4.0   1.6 100%   0.0   0     7   78G    0M 14.6G
   ```
18. The dynamic compute nodes are deprovisioned after an idle time of 10min. So, let's continue to the next chapter to keep them busy...

