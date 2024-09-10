# Introduction 

IBM Cloud for VMware Cloud Foundation (VCF) as a Service is the IBM Cloud managed service offering for which customers can deploy existing or new VMware workloads in an environment that is managed by IBM while still being fully accessible to customers. IBM Cloud for VMware Cloud Foundation as a Service (VCFaaS) is available in single or multi-tenant configurations with the choice to reserve dedicated resources of flexibly grow resource consumption as need demands. For more information please review the Documentation.

  ![](images/10-lab-environment.jpg ':size=200%')


VCFaaS is managed by VMware Cloud Director which provides the multi-tenancy and management capabilities which may be unfamiliar to existing vCenter customers. This hands-on lab is a gentle introduction to the concepts and capabilities VMware Cloud Director and how an application might be deployed in a multi-tenanted environment.

## LAB Shared Data

The following information is relevant to all Lab Participants.

| Item | value |
|-----|-----|
|Cloud director Site | IBM VCFaaS Multitenant – WDC <br>(All VDC will be deployed on this site.) |
|Cloud Login URL | https://cloud.ibm.com/authorize/5eb21c423b5249b6884e527fc8ebc3e5 |
|Virtual Machine user	lab | Used to log into the Virtual Machines deployed. |
| Virtual Machine password | ibmlab01 |
| Virtual Machine IP | The following private IP addresses are allocated to virtual machines in each VDC: <br> * Web server – 192.168.100.10 <br> * App Server – 192.168.101.10 <br> * Database Server – 192.168.101.11 |



## Lab individual data

The following information is relevant to all Lab Participants.

| Item | Description |
|-----|-----|
|Virtual Data Center (VDC) | Each participant will be configuring their own individual  VDC, for example **ibm_techxchange_lab_1**. |
|Public IP Address | Each VDC has a fixed number of Public IP Addresses allocated at instantiation. <br> These are unique to each lab participant. <br> For example: <br> * 149.81.18.2 <br> * 149.81.18.3 |
| IBM Cloud Service Account| Each participant will receive credentials to log into IBM Cloud, these credentials provide OIDC to the Director Console. |


⇨ [Logging in as a lab user](20-logon.md)
