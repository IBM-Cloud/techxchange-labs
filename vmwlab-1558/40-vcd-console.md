# Review Cloud Resources

The lab environment has been pre-configured with a partially configured sample application which we will fix in the next exercise. First however we will explore the resources deployed to familiarize ourselves with the VCD console. Existing VMware vCenter users should see certain correlation with the vCenter and NSX-T consoles.
Lab users have been granted full administrative permissions, it should be noted at that fine grain security and permissions are fully integrated into IBM Cloud IAM. 

For more information on IAM integration please refer to the documentation -> https://cloud.ibm.com/docs/vmwaresolutions?topic=vmwaresolutions-vcd-ops-guide&interface=ui#vcd-ops-guide-roles.

## Content Hub

The Content Hub hosts a library of user-managed VMware templates, media and images. The lab environment has been pre-configured with images associated with deploying the Petstore application.
1.	From the VCD console, navigate:
  * Content Hub **(A)**, 
  * Catalogs **(B)**, 
  * lab-catalog **(C)**, 
  * Application images **(D)**. 

The application images required to deploy the Pet Clinic application are displayed.

  ![](images/40-content-hub.jpg ':size=400') 

 
## Navigating to your VDC
When we navigate out of Virtual Data Center to a section for example the Content Hub we will need to navigate our way back. This is a general technique for navigating to the Virtual Data Center we are managing.
1.	Select Data Centers (A)

  ![](images/40-vdc.jpg ':size=400') 
 
2.	Navigate to and select the VDC we have been assigned

  ![](images/40-vdc-list.png ':size=400') 

3. We should now be viewing the Data Center we are managing.
 
  ![](images/40-vdc-instance.jpg ':size=400') 

## Virtual Machines

The VCD console can allow management of virtual machines. Pet Clinic virtual machines have been deployed from the Application Images listed previously. When reviewing virtual machine configuration, feel free to explore as much as possible to get a feel for the control that VCD provides and the obvious parallel to vCenter.

Please note, some of the virtual machines have been **switched off**, please leave them in this state for the time being.

1.	To list virtual machines, from the VCD console, select **Virtual Machines (A)**, Pet Clinic virtual machines will be listed. 

Note that same virtual machines may be powered off. Please explore the Actions and Details for a virtual machines. For example, to find the IP address of the lab01-app virtual machine….

  ![](images/40-vdc-vm.jpg ':size=400') 
 

2.	From the virtual machine, lab01-app, select the **DETAILS (A)** button. 

  ![](images/40-vdc-vm-details.jpg ':size=400')  

3.	Select Hardware -> **NICS (A)**.

  ![](images/40-vdc-vm-nics.jpg ':size=400') 

On the network panel, we can see that this virtual machine has been deployed on the **lab01-app network (B)** and has a private **IP Address (C)** of 192.168.100.10.

4.	As an exercise, review the other settings for a virtual machine, note the similarity to the control afforded by the vCenter console.

For example:
*	To change **Compute**, **Details** -> **Hardware** -> **Compute** -> **Edit** (We can modify)
  *	CPU
  *	Cores Per Sockeet
  *	Memory

* To add a second disk, **Details** -> **Hardware** -> **Hard Disks** -> **Edit** (We can add a second disk)


## Networks
Private networks are created internally on the VDC Edge Server, which is deployed with each VDC. Under the covers this is implemented on an NSX-T T1 router and similar functionality is surfaced to a VCD deployment.

We have deployed two private networks to host the Pet Clinic application. The public facing (lab01-web) network will have sufficient firewall rules open to allow browser traffic over port 80, while the application network (lab01-app) is completely isolated.

1.	To list networks, select **Networking** -> **Networks** (A), the list of available networks is displayed.
  
  ![](images/40-vdc-networks.jpg ':size=400')

We can see the two pre-provisioned private networks.

2.	Select a network and review the displayed information.
 
  ![](images/40-vdc-vm-web01.png ':size=400')

We can see in the above example, the network has a Gateway CIDR of 192.168.100.9/29, is routed, connected to our T0 gateway and supports Distributed routing. These options are beyond the scope of this lab, however, in general VCD networks support similar options as a T1 router.

3.	As an exercise, review the other network options such as **Static IP Pools** and **IP Usage**.


## Edge Server
Each Virtual Data Center (VDC) is provisioned with a single Edge Server which is functionally similar to a NSX-T T1 Router. The Edge Server is private to the VDC and will host the VDC networks as well as supporting networking functions such as Firewall and NAT.

1.	To list the Edge Server, select **Networking** -> **Edges (A)**.
 
We can see a single Edge Server deployed with the Virtual Data Center.

  ![](images/40-vdc-edge.jpg ':size=400')

2.	Select the **Edge Server**

  ![](images/40-vdc-edge-details.png ':size=400')
 
Details of the Edge Server are displayed, to view the Firewall rules…

3.	Select **Services** -> **Firewall (A)**.

  ![](images/40-vdc-edge-firewall.jpg ':size=400')

In addition to the default rule, we have two firewall rules defined to control the inbound and outbound traffic to the web servers.

4.	As an exercise, explore **IP Sets** and **NAT rules**.



⇨ [Complete Application Configuration](50-pet-clinic-application.md)