# Review Cloud Resources

In this section we will review how the in-cloud resources which comprise a VCFaaS environment are represented. The classroom instructor will lead this initial session to avoid any participant access issues.
It is important understand how your service exists from a cloud perspective before we delve inside it to configure resources.

## Review Cloud Director Site

A VMware Cloud Director Virtual Data Center runs on resources defined in the Cloud Director site. The Cloud Director site defines the resources consumed and can be of two major flavors: 
* **Single tenant** – Resources such as Disk, ESXi Hosts vCenter and more are dedicated to a single customer.
* **Multi tenant** – Resources are shared between multiple customers.

For more information on this offering please refer to -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-vmware-aas-overview - vmware-aas-overview-features

In this activity we will review the resources deployed from a Cloud perspective. This will involve viewing the deployment details of the following two major concepts:
*	Cloud Director Site
*	Virtual Data Center

1.	From the Cloud Console, select **VMware** -> **Resources** -> **VCF as a Service**
2.	Select **Cloud Director Sites (A)**

  ![](images/30-cloud-director-site.jpg ':size=400')
 
3.	Select the appropriate Cloud Director Site
 
This lab has deployed a multi-tenant site. Cloud Director sites are scoped to a specific region and are not resource constrained in the way single-tenant sites are. 
For more information please review the documentation on deployment options -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-tenant-ordering

  ![](images/30-cloud-director-site-details.png ':size=400')

4.	Select **Add-on services (A)** to view the optional add-on services.
 
The IBM Cloud for VMware Cloud Foundation (VCF) as a Service is packaged with a number of optional add-on services. The lab environment will have pre-installed the following:
*	VMware Cloud Director Availability
*	Veeam Backup and Replication

Add-on services are optionally provisioned and integrated using automation from the IBM Cloud Console. 
For more information on provisioning add-on services please visit the documentation here -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-tenant-plan-deploy#tenant-plan-deploy-services

  ![](images/30-cloud-director-add-on.jpg ':size=400')

5.	Click on **Virtual data centers (A)** to view the attached Virtual data centers.
 
Cloud Director sites represent a single organization and resources which is split between 1..n Virtual Data Centers. 
The Virtual Data Center contains the operational aspects of the environment such as virtual machines, networks and firewalls.

  ![](images/30-cloud-director-vdc.jpg ':size=400')

## Review Virtual Data Center
A Virtual Data Center is a construct that manages the operational parts of a site, for example, Virtual Machines, Networks, Edge Server and more. Similar in nature to VMware vCenter, the Virtual Data Center consumes resources exposed by the Cloud Director site and provides an operational interface to manage the day to day tasks in managing resources.

1.	Select the **Virtual Data Center** for your instance as described in List virtual data centers.
 
  ![](images/30-cloud-director-vdc-site-details.jpg ':size=400') 

Some points of interest from the above example:
* **Resources Limits (A)**	
  * Resource limits apply to a Virtual Data Center. From a prescribed minimum in a multi-tenant site, resources can be expanded as required.  Pricing can be on-demand or reserved.
* **Public IP (B)**	
  * Each Virtual Data Centre is assigned 6 public IP addresses that are attached to the edge server.
* **Network Edge Type (C)**	
  * The type of edge to be deployed, allowable values are Performance or Efficiency.
* **Region (D)**	
  * Each Virtual Data Centre is scoped to a region, within which the resources are highly available.
* **Network Connections (E)**	
  * At deployment, public, private or both network types can be selected.

**Exercise**: Please review more fully the deployment options here -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-vdc-adding

## Log into VCD Console
1.	From the Cloud Console, select the **VMware console (A)** button for the relevant Cloud Director Site.

  ![](images/30-cloud-director-site-console.jpg ':size=400') 

The login screen will now be displayed.
2.	Click  **SIGN IN WITH OIDC** button.

  ![](images/30-cloud-director-oidc.jpg ':size=400') 
 

3.	The Director Console will be displayed.
 
  ![](images/30-cloud-director-console-instance.jpg ':size=400') 

## Navigating to your VDC
When we navigate out of Virtual Data Center to a section for example the Content Hub we will need to navigate our way back. This is a general technique for navigating to the Virtual Data Center we are managing.
1.	Select **Data Centers (A)**
  ![](images/30-cloud-director-console-dc.jpg ':size=400') 
 
2.	Navigate to and select the VDC we have been assigned

  ![](images/30-cloud-director-console-2.jpg ':size=400') 
 
We should now be viewing the Data Center we are managing.
 
  ![](images/30-cloud-director-console-instance.jpg ':size=400') 



⇨ [Explore the VCD Console](40-vcd-console.md)