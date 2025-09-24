# Architeture

This architecture facilitates data synchronization between two IBM Cloud Object Storage buckets using Rclone configured on a Virtual Server Instance (VSI) that resides within an IBM Virtual Private Cloud (VPC). It is useful for backup, redundancy, cross-region syncing, or data replication use cases.

 ![](images/30-architecture.png ':size=600')

🔧 Components

1. IBM Cloud Object Storage - Bucket A
This is the source bucket.
It stores data that needs to be copied/synced to another location.
Can be in any IBM Cloud region or zone.
2. IBM Cloud Object Storage - Bucket B
This is the target bucket.
It receives data from Bucket A through syncing operations.
Often located in a different region for disaster recovery (DR) or compliance purposes.
3. IBM Virtual Server Instance (VSI)
A virtual compute resource hosted in IBM Cloud.
It is configured with Rclone, a powerful open-source tool to sync files across various cloud storage systems.
Acts as a bridge to perform data sync between Bucket A and Bucket B.
4. IBM Virtual Private Cloud (VPC)
Provides secure network isolation.
The VSI is deployed within this VPC.
Ensures private connectivity (via IBM’s internal network) to COS endpoints for high security and performance.

🔁 Data Flow (Sync using Rclone)

The VSI periodically runs a scheduled job (via cron or systemd timers) with Rclone.
Rclone reads from Bucket A and writes to Bucket B.
The syncing happens via IBM Cloud's private network (faster and more secure than public internet).
You can configure Rclone with features like:
Checksum validation
Bandwidth throttling
Logging and retries

✅ Benefits

Automated & Reliable: Cron + Rclone setup provides hands-off, reliable synchronization.
Secure: Uses IBM’s internal networking (Private endpoints) to transfer data.
Cost-efficient: Only requires a small VSI; Rclone is free and lightweight.
Flexible: Easy to adjust sync direction, frequency, or storage class.

⇨ [RClone](40-rclonesetup.md)
