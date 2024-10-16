
# Return to previous portal tab

![image](https://media.github.ibm.com/user/273685/files/f5e513dd-537d-4ae0-8023-d3cb761215fa)

## Navigate to Infrastructure
1. Click top left hamburger menu
![image](https://media.github.ibm.com/user/273685/files/17750bc9-24d6-44d2-8ab9-8b4077f219a6)


3. Scroll down to **Infrastructure**
4. Click the Pin next to Infrastructure to pin the menu option to the top.
5. Choose **Virtual Server Instances** within the **Infrastructure** menu. This will take you to the VSI lising.
![image](https://media.github.ibm.com/user/273685/files/b2c1b86d-192e-435a-8618-a8d5090f83fd)
7. If you are not in the **Washinton DC** region, please change it via the drop dowm at the top of the list.
![image](https://media.github.ibm.com/user/273685/files/76791086-6a20-4097-9fa9-9b9e8c41a16a)

9. Click on your VSI Name.
![image](https://media.github.ibm.com/user/273685/files/687f6023-a917-4c9d-ace1-c91012a8a313)


## Create snapshot of Boot Volume

1. Scroll down to the secton that says **Storage Volumes**
2. Click on the Boot Volume Name
![image](https://media.github.ibm.com/user/273685/files/aea97dea-f367-4804-b5b3-20670edece67)

4. Click **Snapshots and backups** tab across top of screen
5. Click blue **Create +** button on right.
![image](https://media.github.ibm.com/user/273685/files/30524efb-1edd-43ea-89c5-2477b1a73697)


7. Choose the following options on this create snapshot page

>Location: pre-selected<br>
>Snapshot Type: Single volume<br>
>Name: vm-snapshot-your-lastname<br>
>Optional Configurations: check the **Copy snapshot to different region**<br>

Hint: you might want to use a unique name to easily find your snapshot later.
  
![image](https://media.github.ibm.com/user/273685/files/9dc48afc-2452-4ad1-a20a-e68e4d76b917)
  
6. This will reveal a new blue create button.  
7. Click create and a slide out will appear on the right.

>Snapshot Name: Pre-filled<br>
>Geography: North America<br>
>Region: Dallas<br>
>Encryption: Inherit from parent resource<br>

![image](https://media.github.ibm.com/user/273685/files/1d9c8d4c-b22b-48f2-b6bb-a12f63a3256e)


8. Click Create
9. Then click "Create block storage snapshot"

![image](https://media.github.ibm.com/user/273685/files/f32bb7de-bcd4-46dc-ae6b-349c93f4292d)


### This will effectively create a point in time copy of the data of your boot volume, and then, the snapshot will be offloaded to COS. In parallel, the snapshot is being copied to us-south.
  
You should be on the list of Block Storage Snapshot list.
Look for your snapshot in the list and click on the name:
![image](https://media.github.ibm.com/user/273685/files/ad6af4d4-9bd8-4e6d-bfbc-64bde6a3b418)


On the bottom right of this page, you will see the "Remote Copies" section. If the Snapshot Status says "Pending", that's because the data is being transferred from the source region to the destination region. When the status says "Stable", you can continue.

![image](https://media.github.ibm.com/user/273685/files/1a364b54-74cf-492c-b234-287185531081)


## Data is protected!
  Now that you have protected your VPC Block Storage volume with a snapshot and copied the snapshot to a different MZR, let's re-create the deployment in Dallas by restoring the snapshot to a new VSI.

  
Go to the "Block storage snapshots" section and make sure you are on the Dallas MZR, if you're still on WDC, select Dallas from the drop down:
 ![image](https://media.github.ibm.com/user/273685/files/93d6c88b-ba96-464f-9677-ed1b550ae1f0)

Once you are in Dallas, you will see the list of all the snapshots in that specific MZR, click on your snapshot name:
  ![image](https://media.github.ibm.com/user/273685/files/973a2af1-4799-46d0-b324-a83a779ca65f)

Click on "Actions" and select "Create volume", this will bring a new panel on the right hand side:
![image](https://media.github.ibm.com/user/273685/files/7981ebca-7938-4da6-bdc6-2259c338d6f5)

  You will need to select the "Attach volume to a virtual server" checkbox, then select the "Attach new volume to a new virtual server" option, which will display a button that will take you to the VSI provisioning page, click on it:
  ![image](https://media.github.ibm.com/user/273685/files/391a7868-2ede-4c83-a049-00478caf207b)

Input a name for your new VSI, your snapshot will be pre-selected as the image for this VSI, select the "student-key" on the SSH keys section, you can select one of the pre-defined VPCs available, or you can create your own VPC. Once all the required values are filled in, you will be able to create a new VSI from your snapshot, click "Create virtual server":
  ![image](https://media.github.ibm.com/user/273685/files/25d85ca0-10e4-457a-a283-acf48f955560)

  You should now be able to see your new VSI on the VSI list:
  ![image](https://media.github.ibm.com/user/273685/files/782d5145-5c3b-4435-9274-9a3fa3b6cfd7)

  You will now need to assign a new floating IP, in order to do that, click on your VSI name to go to the VSI details page.
  
  Once on the details page, go to the bottom of the page to reserve a new floating IP, click on the overflow menu of your vNIC (the three dots), select "Edit floating IPs" and that will bring a new panel:

  ![image](https://media.github.ibm.com/user/273685/files/bf2c850a-c897-4701-b23f-5eec9ea60457)

  Click on the "Attach" button, and then "Reserve new floating IP", give it a name and the click "Reserve":
  ![image](https://media.github.ibm.com/user/273685/files/d475a4e4-e491-4af8-8ebc-23884667492b)

  Your new floating IP address is ready and associated to your vNIC:
  ![image](https://media.github.ibm.com/user/273685/files/a1b486ef-a9a1-4bd6-bb54-5fc2b0ffc4a3)

  Now you have to allow traffic from the web to reach your IP, click on your security group information icon and take note of your security group name:
![image](https://media.github.ibm.com/user/273685/files/c8d8807c-aa43-47ed-b3b9-cbd94da57f62)

  In this example, my security group is called "acquire-dispatch-denial-facility", go to your security groups section on the left hand side, find your security group and click on its name:
  ![image](https://media.github.ibm.com/user/273685/files/65bd192f-4df8-40dd-b48e-9336a39ee5f8)

  Once you are on your security group, you will need to create an inbound TCP rule to allow traffic from port 80
  ![image](https://media.github.ibm.com/user/273685/files/2aef4361-e2ad-4062-ac5c-9f3a97fcda19)

  Your security group should look like this:
![image](https://media.github.ibm.com/user/273685/files/cf7bb104-ef3d-4ddc-9d7f-f35b8bddedc1)

  Now go back to your VSI list page, click on your floating IP to copy it to your clipboard so that you can verify your server is up and running. (Hint: paste the IP on your browser and hit enter, you should see the demo dashboard).
  
  
## Let's now protect file storage
  Now that your VPC Block Storage volume is protected, let's protect your file share. We will use replication to protect our data in a different availability zone within the same MZR (Tip: you could replicate to a different MZR if needed, this is useful on data migration use cases.)

  Go to the "File storage shares" section within Infrastructure and make sure you are on the WDC MZR, then select your file share to go into the file share details page (Hint: it will have your user as part of the file share name). 
  
  Once you are on the file share details page, scroll down to the replication section, since replication hasn't been setup, go ahead an click on "Create replica", which will open a new tab to provision the replica:
  ![image](https://media.github.ibm.com/user/273685/files/9e64fcd4-6e28-458f-ae2a-37138c7dce74)

This provisioning page will show your source file share details, a target AZ (different than the source) will already be selected, you can change this selection to different AZ or even a different MZR at this stage. For this exercise, I'm going to leave WDC1 (source file share was created in WDC3):
![image](https://media.github.ibm.com/user/273685/files/b13214d1-c7e7-4018-b98a-16b9d4416980)

Add a name to your replica share, you can optionally add it to a resource group and add tags. You will also need to select the number of IOPS, since this is a replica, let's set it to the minimum of 100 for now.

You could also add mount targets at this stage, but we won't do it just yet. Let's go to Sync frequency, this will set up how often replication will happen. You can select a predefined frequency (hourly, daily, weekly, monthly), or you can add a CRON expression. 

For this exercise, let's replicate hourly at 30 minutes pat the hour. Select hourly and start time = 30, once ready, click on create file share:
![image](https://media.github.ibm.com/user/273685/files/3a6cc5ca-b49f-4f24-8277-7fee86a14c09)

This will create a replica of your file share in WDC1 and you should be able to see your newly created replica on your file share list (if you created the replica in a different MZR, you will have to select that MZR so that the replica is shown on the list).

This effectively created the replica in a different AZ and will sync the information every hour at 30 minutes past the hour.



  ## Have time left over?
  
  After the conclusion, you can go to the optional activities section, where we will learn how to create backup policies for your block storage snapshots.
 


⇨ [Continue to Conclusion](40-conclusion.md)
