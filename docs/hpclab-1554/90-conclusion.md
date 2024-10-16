# Conclusion

IBM® Spectrum LSF allows you to deploy high-performance computing (HPC) clusters by using IBM Spectrum LSF as HPC scheduling software. This offering uses open source Terraform-based automation to provision and configure IBM Cloud resources. With simple steps to define configuration properties and use automated deployment, you can build your own HPC clusters in minutes by using your choice of an Intel x86 based VPC virtual server instance profile type for the worker nodes in the cluster. IBM Spectrum LSF also enables configuration for auto scaling, so IBM Spectrum LSF clusters can automatically add and remove worker nodes based on workload specifications. This allows you to take full advantage of consumption-based pricing and pay for cloud resources only when they are needed. 

IBM Spectrum LSF offers the option to dynamically provision virtual machine, or static compute nodes on dedicated hosts. The dedicated host option allows you to have systems that are assigned just for your workloads and avoids issues like a noisy neighbor. The deployment properties allow you to either "pack" or "spread". You can pack a dedicated host to full capacity before spilling to another instance or spread the virtual server instances evenly across all dedicated hosts.

In addition, IBM Spectrum LSF provides two shared storage options for you to manage your application data: File storage for VPC or Storage Scale. The Storage Scale option specifically works with static compute nodes only and allows you to deploy a high-performance file system with your HPC cluster.

The offering supports the bring-your-own-license (BYOL) model for IBM Spectrum LSF to deploy an HPC cluster on IBM Cloud. Make sure that you have sufficient software licenses to deploy the required capacity on the IBM Cloud cluster. For evaluation purposes, IBM Cloud does enable limited access. Contact your IBM Cloud sales or support team for evaluation licenses.

### Capabilities

| Capability | Description |
| ---------- | ----------- |
| Faster time to readiness  | Fully automated deployment of HPC environment on IBM Cloud including ready to use IBM Spectrum LSF software |
| Control costs | Automated, dynamic scaling of resources with IBM Spectrum LSF for CPU and GPU resources |
| Security | Deployment follows security best practices |
| Support | Single vendor support for infrastructure and software for more rapid problem resolution |
| Capacity | On demand compute capacity as well as static capacity on dedicated hosts. |
| GPU | Support for a wide range of GPU profiles | 
| Storage options | Choice of NFS, IBM Storage Scale (BYOL) |

### Integrations

| Integration | Description |
| ----------- | ----------- |
| IBM Cloud VPC | Integates with IBM Cloud VPC for compute, network and strorage options |
| IBM Cloud DNS | Integrate with IBM Cloud DNS for custom domain resolutions |
| IBM Cloud Key Protect | Support managing of encryption keys for storage, images and and boot volumes |
| IBM Cloud Secrets Manager | Store and Manage all your secrets in a single place |
| IBM Storage Scale | Allows to mount storage scale endpoint |
| LDAP | Bring your own user directory |

