# IBM Cloud Object Storage: Cross-Region Replication Lab

## 🎯 Objective
This lab demonstrates how to configure **cross-region replication** for IBM Cloud Object Storage (ICOS) buckets using the IBM Cloud web interface, ensuring:
- ✅ Data redundancy  
- ✅ High availability  
- ✅ Disaster recovery readiness  

---

## 📋 Prerequisites
- IBM Cloud account with **Administrator** platform access  
- Two ICOS service instances in **different regions**  
- Source and destination buckets  
- Basic understanding of **IBM Cloud IAM policies**  

---

## Step 1: Create ICOS Service Instances

### Source Instance (us-south / Dallas)
1. Navigate to [IBM Cloud Catalog](https://cloud.ibm.com/catalog).  
2. Search for **Cloud Object Storage**.  
3. Click **Cloud Object Storage**.  
4. Configure:
   - Service name: `my-coslab-xx-source`  
   - Resource group: *select your resource group*  
5. Click **Create**.

### Destination Instance (eu-de / Frankfurt)
Repeat above steps with:
- Service name: `my-coslab-xx-destination`  
- Resource group: *same or another group*  

---

## Step 2: Create Buckets

### Source Bucket (us-south)
1. Navigate to `my-coslab-xx-source`.  
2. Click **Create bucket**.  
3. Configure:
   - Bucket name: `source-bucket-coslab-xx`  
   - Resiliency: `Cross-region`  
   - Location: `us-geo`  
   - Storage class: `Standard` 
   - Versioning : `Enabled`
4. Click **Create bucket**.  


### Upload data to Source Bucket (us-south)
1. Navigate to `source-bucket-coslab-xx`
2. Click **Upload**
3. Upload any file.


### Destination Bucket (eu-de)
1. Navigate to `my-coslab-xx-destination`.  
2. Click **Create bucket**.  
3. Configure:
   - Bucket name: `destination-bucket-coslab-xx`  
   - Resiliency: `Cross-region`  
   - Location: `eu-geo`  
   - Storage class: `Standard`  
   - Versioning : `Enabled`
4. Click **Create bucket**.  

---

## Step 3: Configure IAM Permissions

### Create Authorization Policy
1. Go to **Manage > Access (IAM)**.  
2. Click **Authorizations**.  
3. Click **Create**.  
4. Configure:  
   - Source service: `Cloud Object Storage` (`my-coslab-xx-source`)  
   - Target service: `Cloud Object Storage` (`my-coslab-xx-destination`)  
   - Roles: `Writer`  
5. Click **Authorize**.  

---


## Step 4: Configure Replication Rules

1. Navigate to `my-coslab-xx-source > source-bucket-coslab-xx`.  
2. Go to **Data management** tab → **Bucket replication rules** → **Setup replication**  
3. Configure:  
   - **Rule details:**  
     - **Replication source**  
     - Cloud Object Storage instance: `my-coslab-xx-destination`  
     - Name of target bucket : `destination-bucket-coslab-xx`
     - Check Permissions
     - Rule name: `RuleSRC`  
     - Priority: `0`
     - Done
4. Navigate to `my-coslab-xx-destination > destination-bucket-coslab-xx`.  
5. Go to **Confirguration** tab → **Bucket replication rules** → **Setup replication**  
6. Configure:  
   - **Rule details:**  
     - **Replication target**  
     - Source bucket CRN: `crn:v1:bluemix:public:xxx` 
     - Check Permissions
     - Done

---

## Step 5: Test Replication

### Upload Test File to Source
1. In `source-bucket-coslab-xx`, click **Upload**.  
2. Create & upload `test-file.txt` with content:  
   - `"Test replication file content"`  

### Verify in Destination Bucket
1. In `destination-bucket-coslab-xx`, wait **1-2 minutes**.  
2. Refresh → Confirm `test-file.txt` appears.  
3. Open file → Verify content.  

---

## Step 6: Monitor Replication
- **Source bucket > Replication tab:** Check rule status, errors, warnings.  
- **Destination bucket:** Confirm object timestamps and replication.  

---

## Step 7: Simulate Failover
1. In `source-bucket-coslab-xx`, upload `failover-test.txt` with content `"Failover test file"`.  
2. After 1-2 mins, verify file exists in **destination-bucket-lab** alongside `test-file.txt`.  

---

## 🔧 Troubleshooting

| Issue | Solution |
|-------|-----------|
| Replication not working | Check IAM permissions & authorization policies |
| Objects not replicating | Ensure versioning enabled on **both** buckets |
| Permission errors | Verify Service ID has **Reader/Writer** on destination |
| Slow replication | Review network connectivity and region choice |

**Monitoring checklist:**  
- IAM permissions: IAM > Authorizations  
- Versioning: Source & Destination bucket configs  
- Replication status: Source bucket > Replication tab  
- Service ID permissions: IAM > Service IDs  

---

## 🧹 Cleanup

### Delete Test Files
- Remove test files from both `source-bucket-coslab-xx` & `destination-bucket-coslab-xx`.  

### Complete Cleanup (Optional)
- Delete both buckets after emptying.  
- Delete both `my-coslab-xx-source` and `my-coslab-xx-destination` service instances.  
- Delete Authorization policy.  

---

## ✅ Best Practices
- Always **enable versioning** before configuring replication.  
- Monitor replication metrics regularly.  
- Test **failover scenarios** periodically.  
- Use storage classes wisely (Standard / Vault / Cold Vault).  
- Configure **event notifications** for replication monitoring.  
- Apply **least-privilege** IAM policies.  

---


⇨ [Vault Backup](60-Vault.md)