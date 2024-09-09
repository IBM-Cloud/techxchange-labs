# Complete Application Configuration

Before we begin, it is important to realize that the application has been deployed but needs some remediation before it is functional. 
The main decision that is lab specific is to decide on a Public IP address to use to access the application. 

In the following examples, the public IP address used is 150.240.25.130, **yours will be different** and should be selected from the list of Public IP Addresses defined in the Virtual Data Center Configuration.


## Access Application
1.	From a browser, access http://[Public_IP_Address]/petclinc
The connection will time out.

   ![](images/50-application-broken.png ':size=400') 


## Start Virtual Machines
Earlier you might have noticed that some virtual machines were in powered off. In order to rectify this we will power them on.
1.	From the Virtual Machines console, click Multiselect(A), then select the lab01-app and lab01-web virtual machines, click ACTIONS -> Power -> Power on (B).
 
   ![](images/50-application-vm-start.jpg ':size=400')  
The virtual machines will now start. Please wait until they have a status of Powered on.
 
   ![](images/50-application-vm-start-2.png ':size=400') 

2.	Attempt to access the application once more, you should find the application still unreachable.

## Modify the inbound web NAT Rule
Initially we need to think about the public IP address we selected to access the application. Initially public IP addresses in a sense are routable but lead nowhere. To connect the Public IP Address to our web server, we need to **configure a NAT rule**.
 
   ![](images/50-application-inbound-nat.jpg ':size=400') 

The lab environment will conveniently have a NAT rule configured, however, the public IP address configured in this rule needs to be modified. 
Do not forget, the example IP address will not be the same as the one you have selected or assigned for this lab.

1.	Navigate to the NAT rules as previously described, **Networking** -> **Edges** -> **[Edge Server]** -> **Services** -> **NAT**.

2.	Select the NAT rule **public-petclinic (A)** and click **EDIT**.

   ![](images/50-application-inbound-nat-edit.png ':size=400') 
 
Inspect the NAT rule, you will notice the internal IP address is 192.168.100.10, which is the private IP address of the web server. The external rule however, is set to 160.240.25.130, this is incorrect.


3.	Set the external IP address to your personally allocated public **IP address (A)**, **click Save (B)**.

   ![](images/50-application-inbound-nat-edit-2.jpg ':size=400')

In the above case, we are setting the external IP address to 150.240.25.130. This will have the effect of translating all traffic to this address to our web server on 192.168.100.10.



3.	Attempt to access the application once more, you should find the application still unreachable.

## Enable inbound firewall rule
We now need to pay attention to our firewall rules, currently when attempting to access the web application, we encounter the default firewall rule which prevents all inbound and outbound communication to our Virtual Data Center.

   ![](images/50-application-firewall-arch.jpg ':size=400') 
 
The Edge Server includes a firewall service which by default prevents all traffic from passing.
1.	Navigate to the NAT rules as previously described, **Networking** -> **Edges** -> **[Edge Server]** -> **Services** -> **Firewall**.

   ![](images/50-application-firewall-rule.jpg ':size=400') 

2.	Select the Firewall rule **public-web (A)** and click **EDIT (B)**.
 
Upon closer inspection, we notice that although the firewall to allow HTTP traffic to our web server, the rule is disabled.
   ![](images/50-application-firewall-rule-edit.jpg ':size=400') 

3.	Slide the **State (A)** to enabled then click **SAVE (B**). Ensure the slider bar turns green.
 
Traffic from the internet should now be routable to the web server.
4.	Once more test the application, this time should be **successful !!!**

   ![](images/50-application-working.png ':size=400') 

 
## (optional) Configure outbound communication
A common requirement is for virtual machines to access the internet to download the latest patches. In our case we have deployed Pet Clinic on Ubuntu servers which use the apt package manager. 
The object of this exercise is to configure outbound communication to the internet from a web server in limited use cases, for example, updating patches.

1.	Access the lab01-web virtual machine console by selecting **VM Console (A)** from the virtual machine, the **console (B)** will appear in a new browser. Please note: this will not work well on Safari Browsers, please use either Chrome or Firefox.

    ![](images/50-application-console.jpg ':size=400') 

2.	Login using the virtual machine credentials provided
 
    ![](images/50-application-console-logon.png ':size=400') 

3.	Run the following command and enter the virtual machine password when prompted : `sudo apt-get update`

    ![](images/50-application-sudo-broken.png ':size=400') 

The command will spin for some time, and **ultimately fail** due to what are essentially network errors. 
The issue is that virtual machines have no outbound access to the internet. 
To resolve this, we will enable the firewall rule which allows this traffic. 
Similar to an earlier exercise we will enable a pre-existing firewall rule created for this lab exercise.

5.	Edit the web-public firewall rule. Navigate to the Firewall rules as previously described, **Networking** -> **Edges** -> **[Edge Server]** -> **Services** -> **Firewall**. Select web-public and click **EDIT**.

    ![](images/50-application-firewall-outbound.png ':size=400') 

Note the protocols listed in the **Applications** section, these include HTTPS, HTTP, DNS and more. Enabling this rule will allow our command to work properly.

6.	Slide the State to green, then click **SAVE**.
7.	To enable external access, we must also activate a SNAT rule. Navigate to the NAT rules as previously described, **Networking** -> **Edges** -> **[Edge Server]** -> **Services** -> **Firewall** -> **NAT Rules**.
8.	Select the **web-public** NAT rule and add a Public IP Address to the **External Address** field and click **Save**.
9.	Run the following command and enter the virtual machine password when prompted : `sudo apt-get update` The command should successfully execute.

    ![](images/50-application-sudo-working.png ':size=400') 
 


We have now completed the configuration necessary to enable the Pet Clinic application in your environment. This example was deliberately simple, however, IBM VCFAAS can support complete production ready environments.

⇨ [Configure Veeam Backups](60-veeam-backups.md)