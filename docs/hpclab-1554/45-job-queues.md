# Job Queues

In this section you will learn about job queues and priority between jobs. Therefore, we have configured LSF to apply a quota of 16 vCPU slots to every user. Remember, the default profile for dynamic compute nodes is `bx2-4x16`, i.e. a `balanced` machine profile with 4 vCPU and 16GB memory. Having a quota of 16 vCPUs will result in 4 dynamic compute nodes.

LSF has a set of default queues and each queue has its priority. We will use the `normal` queue with priority `30`. In order to fill the queue we will submit a job with more tasks that can be processed on the quota. Those tasks will be queued in the normal queue and we will watch the process.

To demonstrate the priority, we will submit a second job with a single task on the `priority` queue with priority `43` which will get executed with higher priority, e.g. will finish before the other queue has drained. The default policy of the priority queue is **non-preemptive** which will running jobs finish and **not** disrupt it. This default behaviour can be changed to ensure the priority jobs gets dispatched immediately.

The steps will trigger the job via CLI and watch the queue progress in the Application Center UI.

### Steps

1. Make sure your Cloud Shell and Application Center UI are open and the sessions are active, 
   - for cloud shell login with these steps [steps](20-explore?id=login-to-the-hpc-environment) 
   - for application center login with these [steps](42-pac-workload?id=steps)
2. List the default queues and notice the `normal` and `priority` queue with their priority
   ```
   bqueues
   ```
   ![](./images/45-bqueues.png ':size=600')
2. Check out your limits:
   ```
   blimits -c
   ```
   ![](./images/45-blimits.png ':size=600')
3. Submit a job with 100 tasks. This time we only stress for 1 minute 
   ```
   bsub -J job-vcpu[1-100] -n 1 -R "span[ptile=1]" -R "select[family=balanced]" /mnt/binaries/stress_1m.sh 
   ```
   ![](./images/45-bsub-normal.png ':size=600')
4. Show the queues again and observe the 100 tasks queueing up in the `normal` queue
   ```
   watch -n 2 bqueues 
   ```
5. Wait until the jobs are running which will take a few minutes depending on the dynamic nodes availability. You will notice that only batches of 16 tasks are running at a time. That's because the users have a quota of 16 vCPUs. 
   ![](./images/45-bqueues-normal.png ':size=600')
6. Submit the 32 jobs with higher priority to the `priority` queue.
   ```
   bsub -q priority -J priority-job-vcpu[1-32] -n 1 -R "span[ptile=1]" -R "select[family=balanced]" /mnt/binaries/stress_1m.sh
   ```
   ![](./images/45-bsub-priority.png ':size=600')
7. List the job queues again and notice the tasks in the `normal` and `priority` queue
    ```
    bqueues
    ```
    ![](./images/45-bqueue-priority-pending.png ':size=600')
    ![](./images/45-bqueue-priority-running.png ':size=600')
8. Monitor the job progress and pay attention to the pending (`PEND`), completed (`DONE`) and running (`RUN`) columns.
    - The priority job is **not** dispatched immediately because by default it's **non-preemptive** (queues can be configured to be preemptive)
    - The LSF scheduler will let the running tasks in the normal queue complete first
    - Once a running task of the normal queue is freeing up the CPU, the task from the priority queue get scheduled while the tasks in the normal queue need to wait
9. Navigate to the **Workloads** view in the Application Center UI
    ![](./images/45-pac-workloads.png ':size=600')
10. 16 out of the 32 priority jobs are running while the normal job is pending. The view is updating automatically, but you can manually press the refresh button.
    ![](./images/45-pac-refresh.png ':size=600')
11. Navigate to Workload **By Queue** in the Application Center and review the progress and wait until the priority job is done and the normal job is running again.
    ![](./images/45-pac-queue-1.png ':size=600')
    ![](./images/45-pac-queue-2.png ':size=600')
12. Navigate back to **Workload** and observe the status of the jobs. The priority job is done (gray) while the normal job is partially complete (gray), pending (yellow) and running (green) 
    ![](./images/45-pac-workloads-2.png ':size=600')
13. Click on the Summary of the normal job to review it's details.
    ![](./images/45-pac-workloads-3.png ':size=600')


?> Wow, if this was quite complex, repeat the steps if you like.