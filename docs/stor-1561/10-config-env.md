## Login in to IBM Cloud Portal (3 min)

### Retrieve the credentials to use for authentication

### Log in

1. Go to https://ibm.biz/TX24-1561 and enter your credentials:
![image](https://media.github.ibm.com/user/273685/files/4e514ef1-1227-4ef2-ab09-a5111d277687)



2. Click the cloud shell icon (top right) to open the IBM Cloud Shell (it will open in a new tab.)
![image](https://media.github.ibm.com/user/273685/files/b9a517b6-8f98-46a7-b3b1-ae14d132d776)
![image](https://media.github.ibm.com/user/273685/files/d88bc538-92a1-460c-8eeb-2416f6b8c3f9)


The CLI portion of this lab uses session variables that may not persist if you logout or close your terminal.  If you lose your cloud shell, you may have to re-initialize these variables and download the ssh key again. 


## Set Session Variables
Copy and paste the following in your IBM Cloud Shell, then press enter:


~~~
export USER_NAME=${USER//_/-}
export PRI_VSI_NAME=$USER_NAME-vsi
export SEC_VSI_NAME=$USER_NAME-vsi
export FILE_SHARE_NAME=$USER_NAME-share

export REGION=us-east
export ZONE=us-east-3
export SEC_REGION=us-south
export SEC_ZONE=us-south-3
export PRI_VPC_ID=r014-b9e60bf4-53db-487a-a04f-20de0faeba4b
export SEC_VPC_ID=r006-c70475d4-f4ba-45f3-951b-00b784a57535
export PRI_SN_ID=0777-9fd31223-d13f-4f68-b0c8-b7e6b17be0bb
export SEC__SN_ID=0737-a3e24682-2ad7-4a5c-b014-2c9ab929f89b
export PROFILE=cx2-2x4
export OS_IMAGE_ID=r014-934534f7-b4f3-480c-835c-c7a3989e13b6
export ED_KEY_PATH=~/.ssh/id_ed25519.pub
export EAST_SSH_KEY_ID=r014-e58e8095-76af-4ba9-a6c7-2dfa4eada2e2
export SOUTH_SSH_KEY_ID=r006-f28e6e04-9504-44cd-8f37-53db9ed346a3
export USER_DATA_PATH=~/user-data
~~~
![image](https://media.github.ibm.com/user/273685/files/baa658b3-1be8-4c26-a00f-db2ee4b24acf)


Verify user and target:

~~~
ibmcloud target
~~~

You should get an output that look like this:

~~~
API endpoint:     https://cloud.ibm.com
Region:           us-east
User:             email@ibm.com
Account:          itz-enablement-043 (f54fa0ff98b74d0b9e1af82a3e50311f) <-> 2620658
~~~

If the region is not us-east, you need to change the target by typing the following:

~~~
ibmcloud target -r us-east
~~~

This should change your region for you:

![image](https://media.github.ibm.com/user/273685/files/1271f2e3-f10c-4129-9e3e-b8f22615f224)


⇨ [Continue to Deployment](20-lets-deploy.md)
 
