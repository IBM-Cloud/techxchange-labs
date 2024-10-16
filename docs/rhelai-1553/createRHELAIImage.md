## Create a RHEL AI Image on IBM Cloud


> [!NOTE]
> **Steps 1 to 5** have already been ccompleted for the lab. You can review these steps. Start at **Step 6**.


### 1. Download the RHEL AI image

The Red Hat Enterprise AI (RHEL AI) image can be imported as a bring your own license (BYOL) from RedHat. It is available as a qcow2 image.

To download the RHEL AI image, go to https://developers.redhat.com/products/rhel-ai/download. 


### 2. Create a COS instance in your IBM Cloud account

Go to the **Catalog** and search for **Object Storage**

![searchObjectStorage](images/searchObjectStorage.png)

<p>&nbsp;</p>

Select the **Standard** plan
![selectCOSPlan](images/selectCOSPlan.png)

<p>&nbsp;</p>

Provide the **Service name** and click on **Create**

![configureCOS](images/configureCOS.png)


<p>&nbsp;</p>

Cloud Object Storage instance will be created

![provisionedCOS](images/provisionedCOS.png)


<p>&nbsp;</p>



### 3. Create a COS bucket

Create a custom bucket by clicking on **Create bucket** and choosing **Create a Custom Bucket**

![createCOSBucket](images/createCOSBucket.png)

![cosBucketCreated](images/cosBucketCreated.png)



### 4. Upload the rhel ai qcow2 image to the COS bucket

Click on **Upload** to upload the qcow2 image

![uploadqcow2](images/uploadqcow2.png)

<p>&nbsp;</p>

### 5. Add access to COS for the Image creation service. 

```
ibmcloud iam authorization-policy-create is cloud-object-storage Reader  --source-service-account <Account ID> --source-resource-type image
```

<p>&nbsp;</p>

### 6. Create a VPC image from the downloaded qcow2 image

Click on **Infrastructure -> Compute -> Images**  and click on **Create**.

![createRHELAIImage-1](images/createRHELAIImage-1.png)
![createRHELAIImage-2](images/createRHELAIImage-2.png)

Click on **Create custom image** to create the RHELAI image for VPC.

<p>&nbsp;</p>

### 7. Check the status of the created image 

Click on **Infrastructure -> Compute -> Images** 

![createRHELAIImage-1](images/createRHELAIImage-3.png)

<p>&nbsp;</p>
Click on the image to see the derails

![createRHELAIImage-2](images/createRHELAIImage-4.png)

Click on **Create custom image** to create the RHELAI image for VPC.