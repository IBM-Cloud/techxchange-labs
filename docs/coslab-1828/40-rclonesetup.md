# Rclone IBM Cloud Object Storage Replication Guide

## Overview

This guide demonstrates how to configure and use Rclone to replicate objects between IBM Cloud Object Storage (COS) buckets using IBM Cloud's private network for enhanced security and reduced data transfer costs.

## Prerequisites

### IBM Cloud Account Requirements

- Active IBM Cloud account
- Two COS instances (source and destination)
- Two buckets (source and destination) in the same or different COS instances
- IBM Cloud API key with appropriate permissions

### Software Requirements

- Rclone installed on your local machine or cloud server
- Access to IBM Cloud private network (if running outside IBM Cloud)
- IBM Cloud CLI (optional, for service credential management)

## Login to IBM Cloud using the credentials provided

1. Open a Notepad in your machine
2. Log in to the [IBM Cloud Console] https://cloud.ibm.com/authorize/techxchange_2024/TkQjwl2TOB 
3. Navigate to **Manage > Access (IAM) > API keys**.
4. Click **Create an IBM Cloud API key**.
5. Enter a **name** and **description** for your key.
6. Choose what action IBM Cloud should take if the key is leaked (Disable, Delete, or None).
7. Click **Create**.
8. Once the key appears:
    - Click **Show** to reveal the API key.
    - Use **Copy** to put the key on your Notepad/clipboard.
    - Optionally, use **Download** to save the key as a file.

> **Note:** The API key is only available to copy or download at the moment of creation. Lost keys cannot be retrieved; you must create a new one if needed.



## Step 1: Create ICOS Service Instances

### Source Instance 
1. Navigate to [IBM Cloud Catalog](https://cloud.ibm.com/catalog).  
2. Search for **Object Storage**.  
3. Click **Object Storage**.  
4. Configure:
   - Service name: `my-coslab-xx`  (xx is your lab number)
   - Resource group: *coslab-1828-lab*  
5. Click **Create**.  

---

### Generate IBM Cloud COS HMAC Credentials

1. Go to IBM Cloud Console → Object Storage
2. Select your COS instance (`my-coslab-xx`)
3. Go to **Service credentials** → Click **New credential**
4. Under Create Credentials 
   - Name: `cred-coslab-xx`  
   - Role: `Writer`  
   - Select Service ID (Optional): `Auto Generated`  
   - Include HMAC Credential: `On`  
5. Select Add

Expand the Service Credentials to see the access_key_id, secret_access_key and resource_instance_id which will be need for the next step to configure rclone ( copy these to a Notepad)

---

## Step 2 : Create Buckets

### Source Bucket (Chennai 01)
1. Navigate to `my-coslab-xx`.  
2. Click **Create bucket**.  
3. Configure:
   - Bucket name: `source-bucket-coslab-xx`  
   - Resiliency: `Single data center`  
   - Location: `Chennai 01`  
   - Storage class: `Standard` 
4. Click **Create bucket**.  

### Upload data to Source Bucket (Chennai 01)
1. Navigate to `source-bucket-coslab-xx`
2. Click **Upload**
3. Upload any file.

### Destination Bucket (US-South)
1. Navigate to `my-coslab-xx`.  
2. Click **Create bucket**.  
3. Configure:
   - Bucket name: `destination-bucket-coslab-xx`  
   - Resiliency: `Regional`  
   - Location: `us-south`  
   - Storage class: `Standard`  
4. Click **Create bucket**.  



---

## Step 3 : Login to VPC VSI Using Private SSH Key in IBM Cloud Shell

Follow these steps to securely download, configure, and use your private SSH key in IBM Cloud Shell.

### Download the SSH Private Key
- From **Hamburger Menu -> Select Resource List->Storage → vsi-prv-keys → coslab-keys**  
- Download the file named **coslab-xx.prv** (xx is your lab number given)

### Open the Private Key on Your Local Machine
- Open the downloaded file (**coslab-xx.prv**) in a text editor.  
- Copy the *entire* contents, including:

```

-----BEGIN OPENSSH PRIVATE KEY-----
...
-----END OPENSSH PRIVATE KEY-----

```

> **Never share your private key with anyone.**

### Create a Key File in IBM Cloud Shell
Open Cloud Shell from IBM Cloud
Create a new file in IBM Cloud Shell using `nano`:

```

nano ~/my_vpc_key

```

### Paste the Private Key
- Paste the copied private key contents into the file.  
- Save and exit:  
  *Press `Ctrl+X`, then `Y`, then `Enter` to confirm the filename.*

### Set Secure Permissions
SSH requires strict permissions on the private key file:

```

chmod 600 ~/my_vpc_key

```

### Next Steps: Connect With The Key

Test SSH connectivity to your server using the custom key file:

```

ssh -i ~/my_vpc_key root@<hostIP>


hostIP is found from
Infrastructure -> Compute -> Virtual server instances (make sure region is Dallas(us-south))
Click on coslab-vsi-xx (where xx is the lab number)
Click Networking tab
Take note of Floating IP address

Answer yes when prompted
```

- Replace `<host>` with the server's IP address or hostname.[web:2]
- If the key is accepted, you will be authenticated without a password prompt.

---

*Your SSH private key is now ready for secure use within IBM Cloud Shell. If you encounter permission errors, verify your key file permissions and try again.*


## Step 4: Install Rclone

### Linux/macOS

From IBM Cloud Shell,  install rclone on the VSI
```


# Using package manager (Linux)

sudo apt-get install rclone     \# Ubuntu/Debian
sudo yum install rclone         \# RHEL/CentOS

# Or download directly

curl -O https://downloads.rclone.org/rclone-current-linux-amd64.zip
unzip rclone-current-linux-amd64.zip
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone

```

### Windows

Download from: [https://rclone.org/downloads/](https://rclone.org/downloads/)

## Step 4: Configure IBM Cloud COS Endpoints

Identify your COS endpoints:

- **Public endpoint:** `s3.{region}.cloud-object-storage.appdomain.cloud`
- **Private endpoint:** `s3.private.{region}.cloud-object-storage.appdomain.cloud`

Replace `{region}` with your actual region (e.g., `us-south`, `eu-de`, etc.)

## Step 5: Create Rclone Configuration


### Configure Rclone

Go back to Cloud Shell from IBM Cloud, make sure you are still logged into the VSI.
```

rclone config

```

Follow the interactive setup:

```

n) New remote
name> ibm-coslab-xx-source
Storage> s3
provider> IBMCOS
env_auth> false
access_key_id> YOUR_SOURCE_HMAC_ACCESS_KEY
secret_access_key> YOUR_SOURCE_HMAC_SECRET_KEY
region> 1 (Use this if unsure)
endpoint> s3.direct.che01.cloud-object-storage.appdomain.cloud
location_constraint> che01-standard
acl> private(1)
ibm_api_key> 
ibm_resource_instance_id> 
Edit advanced config> n

```
```
Keep this "ibm-coslab-xx-source" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
Type y
```


Repeat for destination bucket:

```

n) New remote
name> ibm-coslab-xx-destination
Storage> s3
provider> IBMCOS
env_auth> false
access_key_id> YOUR_SOURCE_HMAC_ACCESS_KEY
secret_access_key> YOUR_SOURCE_HMAC_SECRET_KEY
region> 1 (Use this if unsure)
endpoint> s3.direct.us-south.cloud-object-storage.appdomain.cloud
location_constraint> us-south-standard
acl> private(1)
ibm_api_key> 
ibm_resource_instance_id> 
Edit advanced config> n

```
```
Keep this "ibm-coslab-xx-destination" remote?
y) Yes this is OK (default)
e) Edit this remote
d) Delete this remote
Type y
```

q) Quit config

## Step 6: Verify Network Connectivity

### Test Private Network Connection

```


# Test connectivity to private endpoints

ping s3.direct.us-south.cloud-object-storage.appdomain.cloud

```

### Verify Rclone Configuration

```


# List buckets to verify configuration

rclone lsd ibm-coslab-xx-source:  ( Note: Make sure you use ":" after the rclone confiq name)
rclone lsd ibm-coslab-xx-destination:  ( Note: Make sure you use ":" after the rclone confiq name)

```

## Step 7: Perform Initial Replication

### Dry Run (Recommended First)

```

rclone copy --dry-run --progress ibm-coslab-xx-source:source-bucket-coslab-xx ibm-coslab-xx-destination:destination-bucket-coslab-xx


```

### Actual Replication

```

rclone copy --progress --transfers 16 --checkers 32 ibm-coslab-xx-source:source-bucket-coslab-xx ibm-coslab-xx-destination:destination-bucket-coslab-xx


```

### (Optional) Advanced Options for Large Datasets

```

rclone copy --progress \
--transfers 16 \
--checkers 32 \
--s3-chunk-size 64M \
--s3-upload-concurrency 8 \
--s3-disable-checksum \
--low-level-retries 10 \
--retries 10 \
ibm-coslab-xx-source:source-bucket-coslab-xx \
ibm-coslab-xx-destination:destination-bucket-coslab-xx

```


## Step 8: Monitoring and Validation

### Verify Transfer Completion

```


# Check file counts

rclone size ibm-coslab-xx-source:source-bucket-coslab-xx
rclone size ibm-coslab-xx-destination:destination-bucket-coslab-xx

# Compare checksums

rclone check ibm-coslab-xx-source:source-bucket-coslab-xx ibm-coslab-xx-destination:destination-bucket-coslab-xx
```

### Monitor Transfer Speed

```


# Use --stats flag for detailed monitoring

rclone sync --progress --stats 30s \
ibm-coslab-xx-source:source-bucket-coslab-xx \
ibm-coslab-xx-destination:destination-bucket-coslab-xx

```

## Step 9: Troubleshooting Common Issues

### Network Issues

```


# Check DNS resolution

nslookup s3.private.us-south.cloud-object-storage.appdomain.cloud
nslookup s3.direct.us-south.cloud-object-storage.appdomain.cloud

```

### Permission Issues

```


# Verify credentials work

rclone lsd ibm-coslab-xx-source: --dump auth

```

### Performance Optimization

```


# Adjust based on network bandwidth

--transfers 32       \# Increase for high bandwidth
--checkers 64        \# Increase for many small files
--s3-chunk-size 128M \# Increase for large files

```

## Security Considerations

1. **Private Network:** Ensure all traffic uses IBM Cloud private endpoints
2. **HMAC Credentials:** Use minimal required permissions
3. **Encryption:** Enable server-side encryption for sensitive data
4. **Access Control:** Regularly review and rotate credentials



## Cleanup

Remove temporary files and secure credentials:

```
Clear rclone configuration if needed
rclone config delete ibm-coslab-xx-source
rclone config delete ibm-coslab-xx-destination

Remove sensitive information from shell history
history -c

```
⇨ [Replication](50-replication.md)
