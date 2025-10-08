# IBM Cloud Object Storage - Backup Vaults Lab Guide

## Overview
This repository contains a **lab guide** for setting up and configuring **IBM Cloud Object Storage Backup Vaults**.

Backup Vaults provide a **secure, scalable, and cost-effective** solution for storing backup data with features like:
- **Immutability** (protection against ransomware and accidental deletion)
- **Retention policies** for compliance
- **S3 compatibility** with third-party tools

---


## Lab Steps

### 1. Create a Backup Vault
1. Log in to the [IBM Cloud console](https://cloud.ibm.com/).
2. Navigate to **Object Storage > `my-coslab-xx-source`.  
3. Click **Backup Vaults**.
4. Click **Create**
5. Configure the following:
   - **Name:** e.g., `my-backup-vault`
   - **Resiliency:**
     - *Cross-Region* for high durability  
     - *Regional* for lower cost
   - **Region:** Choose a region closest to your users or compliance requirements
   - **Backup authorization:** Select **Authorize** 
6. Click **Create** to provision the vault.

---

### 2. Configure Backup Policies
1. Navigate to **Object Storage > `my-coslab-xx-source > source-bucket-coslab-xx`.
2. Click **Backup Policies**.
3. Click **Create**
4. Configure the following:
    - **Name:** e.g., `my-backup-policy`
    - **Backup type:** Continuous
   - **Choose destination backup vault:** Select `my-backup-vault`
   - **Backup retention time (days):`1` - you can customize it
5. Click **Create** .
---

### 3. Monitor and Maintain
- Set up **Monitoring Alerts** for storage usage and API activity
- Use **Activity Tracker** to audit access and changes
- Regularly **test restore operations** to ensure data recoverability

---

## Best Practices
- **Immutable Backups:** Enable *Object Lock* for ransomware protection
- **Lifecycle Policies:** Automate tiering to *Cold Vault* for cost optimization
- **Access Control:** Use IAM policies to restrict access to the minimum required users/services
- **Encryption:** Use IBM-managed keys (default) or Bring Your Own Key (KYOK)

---

## Troubleshooting
- **Authentication Errors:** Verify IAM roles and service credentials
- **Connectivity Issues:** Check network ACLs and firewall rules
- **Permission Denied:** Ensure the credential has the correct role (Writer/Reader)

---

⇨ [Conclusion](90-conclusion.md)