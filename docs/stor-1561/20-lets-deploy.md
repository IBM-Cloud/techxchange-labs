# Lets Deploy! (20 min)




## Download user-data & SSH Key from COS

### Configure the object storage plugin.

Use the following command to view the current config of the cos plugin:

~~~
ibmcloud cos config list
~~~

set the crn download location for the object storage instance:

~~~
ibmcloud cos config crn --crn 705234dc-60f7-43fa-b7cd-43d2395a212a
ibmcloud cos config ddl -ddl /home/$USER
~~~

Confirm CRN has been set:

~~~
ibmcloud cos config list
~~~

Download a cloud init file that you will use later:

~~~
ibmcloud cos object-get --bucket tx-1561-2024 --key user-data --region us-south
~~~

You should get the following output, if you did not, please stop and speak to a proctor:

~~~
Successfully downloaded 'user-data' from bucket 'tx-1561-2024'
353 B downloaded.
~~~
![image](https://media.github.ibm.com/user/273685/files/56fc2050-f0de-45a2-b235-7d96e5c91675)

### In the IBM Cloud Shell we need to download our ssh key from COS.  We will do that via the IBM Cloud CLI, but first we need to prepare the directory:

~~~
mkdir -p ~/.ssh;
chmod 700 ~/.ssh
~~~

Set the new download location:
~~~
ibmcloud cos config ddl -ddl /home/$USER/.ssh
~~~

You will receive the following output:
~~~
Saving default download location...
OK
Successfully saved download location. New files will be downloaded to '/home/attendee_XX/.ssh'.
~~~

## Download private key and change permissions:
~~~
ibmcloud cos object-get --bucket tx-1561-2024 --key id_ed25519 --region us-south
ibmcloud cos object-get --bucket tx-1561-2024 --key id_ed25519.pub --region us-south
chmod 600 ~/.ssh/id_ed25519;
chmod 644 ~/.ssh/id_ed25519.pub
~~~


## Create a VSI and attach a Floating IP:
~~~
PRIMARY_VSI_ID=$(ibmcloud is instance-create $PRI_VSI_NAME $PRI_VPC_ID $ZONE $PROFILE $PRI_SN_ID --image $OS_IMAGE_ID --keys $EAST_SSH_KEY_ID --user-data @$USER_DATA_PATH  --output JSON | jq -r .id);
PRI_VNI_ID=$(ibmcloud is instance $PRIMARY_VSI_ID --output JSON | jq -r .primary_network_attachment.virtual_network_interface.id);
FIP1=$(ibmcloud is floating-ip-reserve $USER_NAME-fip --vni $PRI_VNI_ID --output JSON | jq -r .address)

~~~


Confirm tha your VSI has been provised and running.

~~~
ibmcloud is instance $PRIMARY_VSI_ID

~~~


~~~
Getting instance 0XXX_496bfa86-3845-XXX-XXX-d97002300e37 under account itz-enablement-043 as user txlab-03@example.com...
                                         
ID                                    0777_496bfa86-3845-4c82-83c8-d97002300e37   
Name                                  txlab-03-vsi   
CRN                                   crn:v1:bluemix:public:is:us-east-3:a/f54fa0ff98b74d0b9e1af82a3e50311f::instance:0777_496bfa86-3845-4c82-83c8-d97002300e37   
Status                                running   
Availability policy on host failure   restart   
Startable                             true   
Profile                               cx2-2x4   
Architecture                          amd64   
vCPU Manufacturer                     intel   
vCPUs                                 2   
Memory(GiB)                           4   
Bandwidth(Mbps)                       4000   
Volume bandwidth(Mbps)                1000   
Network bandwidth(Mbps)               3000   
Lifecycle Reasons                     Code   Message      
                                      -      -      

~~~




once it is running, lest comfirm that it is availne online via ping.

~~~
ping $FIP1

~~~
Once you get a response, 'CTRL+C' to exit.



Now that it is online and pingable, lets confirm that your website is up and running before we try and visit it.
This may about 2~3 min to complete.
~~~
curl -Is http://$FIP1

~~~
Re-run the command until you see the following output.  you are lookig for a HTTP/1.1 200 OK response.

~~~
txlab_XX@cloudshell:~$ curl -Is http://$FIP1
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Tue, 23 Jul 2024 15:53:53 GMT
Content-Type: text/html
Content-Length: 42347
Last-Modified: Fri, 07 Jun 2024 04:08:37 GMT
Connection: keep-alive
ETag: "666287c5-a56b"
Accept-Ranges: bytes
~~~



Retrieve floating IP of newly create VSI:
~~~
echo $FIP1

~~~

Visit your website you just built at the floating IP:

~~~
echo http://$FIP1
~~~



## Create 20G File Storage Share:
~~~
PRIMARY_SHARE_ID=$(ibmcloud is share-create --name $FILE_SHARE_NAME --zone $ZONE --profile dp2 --size 20  --output JSON | jq -r .id)
sleep 5
MOUNT_TARGET_ID=$(ibmcloud is share-mount-target-create $PRIMARY_SHARE_ID --subnet $PRI_SN_ID --output JSON | jq -r .id)
sleep 15
MOUNT_PATH=$(ibmcloud is share-mount-target $PRIMARY_SHARE_ID  $MOUNT_TARGET_ID  --output JSON | jq -e .mount_path)

~~~


View and take note of Mount Path (hint: you can always get the mount path from the UI):
~~~
echo $MOUNT_PATH
~~~

ssh into server using the floating IP in your list:
~~~
ssh -i ~/.ssh/id_ed25519 root@$FIP1
~~~

Create a new directory:
~~~
mkdir -p /mnt/nfs
~~~



Mount the NFS Share to newly created directory with the mount path listed above:
~~~
mount -t nfs4 -o sec=sys,nfsvers=4.1 <host_ip:/host_path> <local_path>

~~~ 
Example 'mount -t nfs4 -o sec=sys,nfsvers=4.1 10.240.64.4:/a1f046be_2121_46d5_8e83_f48887824639 /mnt/nfs'

Check that your mount was succesful. You should see a line at the bottom with the mounted file share
~~~
df -h

~~~

![image](https://media.github.ibm.com/user/273685/files/48ebc8b2-6097-4cb8-b1f4-8d0fb273e3da)


Now lets test access:
~~~
touch /mnt/nfs/test.file

~~~

Lets create a couple of test files to replicate. These two commands will take about 3~4 min to complete. 

~~~
dd if=/dev/zero of=/mnt/nfs/250M.file bs=1M count=250 &
dd if=/dev/zero of=/mnt/nfs/750M.file bs=1M count=750

~~~

You will have output similar to this:
![image](https://media.github.ibm.com/user/273685/files/ff02dfb1-865d-42e8-8030-83acde97c18f)

And by now, you should have a few files in your /mnt/nfs directory, let's list all files:
~~~
ls -lah /mnt/nfs
~~~

![image](https://media.github.ibm.com/user/273685/files/6fc1b286-508a-468b-8a82-7e5bec7ee384)



⇨ [Continue to Portal Time](30-portal-time.md)
