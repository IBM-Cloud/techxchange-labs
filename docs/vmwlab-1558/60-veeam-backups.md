# Configure Veeam Backups

IBM Cloud for VMware Cloud Foundation (VCF) as a Service includes an optional Veeam service to backup virtual machines. In this exercise we will configure a backup job to protect our Petclinic application. 
For more information, please refer to the Veeam Documentation.

## Access Veeam Console
1.	To access the Veeam console, select **More**,  then select Data protection with **Veeam (A)**.

   ![](images/60-veeam-console.jpg ':size=400') 

Please allow time for the Veeam console to load.

   ![](images/60-veeam-console-2.png ':size=400') 

For all intensive purposes, this is a standard Veeam installation with all of the usual features.

## Configure a backup job
Backup’s may be configured at the Virtual Machine, group of Virtual Machines or for specific applications such as SQL Server which reside within a virtual machine. Backup jobs are stored on Block Storage specifically reserved for this task, however, for long term storage offloading to cheaper storage such as Cloud Object Storage is also possible.

This example is the simplest example, we will not touch Guest File indexing or application processing.

1.	From the Veeam console select **Create (A)**, enter a **job name (B)**, select a **repository (C)** then click **Next (D)**.
 
    ![](images/60-veeam-backup-job.jpg ':size=400') 
2.	Select **ADD (A)** then navigate to and select your **Virtual Data Center (B)**, click on **OK (C)**.
    ![](images/60-veeam-backup-job-2.jpg ':size=400') 
3.	Click **Next**.
4.	Click **Next**.
5.	Modify the Job Schedule as required, this is not essential however, when complete click **Next**.

    ![](images/60-veeam-backup-job-3.png ':size=400') 

6.	Click **Next**. The job is now complete. 

7.	To start the job, select the relevant job and click **Start (A)**. While the job is running observe the **Status (B)** changing.

     ![](images/60-veeam-backup-job-4.jpg ':size=400') 
 
8.	From the **Dashboard**, review information such as **Protected (A)** and overall usage status on each **backup repository (B)**.
 
     ![](images/60-veeam-backup-job-console.jpg ':size=400') 

9. **We are now all protected !!!**

## Long term backup retention
Dedicated long term backup repositories are chosen for long term storage of backups. Storage of this nature is often lower performing, however, significantly cheaper than short term storage. 
Creating a scale-out repository of this sort requires the creation of a support ticket, please review the documentation to assess the process -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-veeam-adding-sobr.

