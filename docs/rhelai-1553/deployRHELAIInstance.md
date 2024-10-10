## Deploy the RHEL AI image on IBM Cloud


### 1. Create a VPC

Go to **Infrastructure -> Network-> VPCs**. Provide the name and take the defaults. Click **Create** to create a  virtual private cloud

![createVPC](images/createVPC.png)

<p>&nbsp;</p>

### 2. Create a RHEL AI instance

Go to **Infrastructure -> Compute -> Virtual server instances** . 

![createInstance](images/createInstance.png)

Click on **Create**. 

Provide the **Name**.

<p>&nbsp;</p>

Choose the custom image for RHEL AI in the **Image** section.
![chooseCustomImage](images/chooseCustomImage.png)

<p>&nbsp;</p>

Choose the Instance Profile (GPU) in the **Profile** section.

![gpuInstanceProfile](images/gpuInstanceProfile.png)

Choose the gx3-48x240x2l40s profile.

<p>&nbsp;</p>

Select / Create the ssh key
![selectSSHKey](images/selectSSHKey.png)

<p>&nbsp;</p>

Increase the size of the boot volume to **250G**


![increaseBootVolume](images/increaseBootVolume.png)

<p>&nbsp;</p>

Click **Create virtual server**

<p>&nbsp;</p>

### 3. See the Virtual server instance
Go to **Infrastructure -> Compute --> Virtual server instances**

![virtualServerInstance](images/virtualServerInstance.png)

<p>&nbsp;</p>

### 4. Set up a floating IP 
Click on the Virtual server instance and go into the **Networking** tab. Click on the **Actions** menu and choose Edit floating IPs 

![editFloatingIP](images/editFloatingIP.png)

Click on **Attach and Reserve new floating IP**  and attach it to the server.

The Virtual Server should show the FIP attached to it. Make note of this floating IP.

![instanceWithFloatingIP](images/instanceWithFloatingIP.png)



