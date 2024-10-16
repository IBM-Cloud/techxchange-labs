# Deploy the HPC Environment

In the previous sections we have explored and run workload in the pre-configured IBM Cloud HPC environment. In this final section, we will learn how an administrator will deploy an IBM Cloud HPC environment and which configuration options the offering provides.

As shown earlier, the following diagram provides the reference architecture and all components provisioned and configured in IBM Cloud HPC

![](images/20-explore-hpc-da.svg ':size=600')

The deployable architecture is using Terraform and IBM Cloud Schematics service to automatically provision and configure the components. The user can customize the deployable architecture by specifying the required and optional parameters. Let's review the available parameters and how IBM Cloud Schematics helps to manage the deployment.

### Steps

1. Login to [IBM Cloud](10-getting-started?id=log-in-to-ibm-cloud) and navigate to the [Spectrum LSF catalog offering](10-getting-started?id=deploy-the-ibm-cloud-hpc-environment)
2. Find additional information in the [documentation link](https://cloud.ibm.com/docs/ibm-spectrum-lsf?topic=ibm-spectrum-lsf-getting-started-tutorial) and under **About**
   ![](images/60-tile1-landing.png ':size=600')
3. Keep the default **deployment target** and **delivery method** to be IBM Cloud Schematics and Terraform
4. Scroll through the page
5. Review the **pricing plans** supported by this offering
   ![](images/60-tile3-byol.png ':size=600')
6. Permissions to **Configure your workspace** has been restricted for this Lab to avoid provisioning new clusters.
   ![](images/60-tile4-permissions.png ':size=600')
7. All of the above sections are more of general nature.
8. Let's get into the HPC specific configuration sections. Find the documentation of all available [deployment values](https://cloud.ibm.com/docs/ibm-spectrum-lsf?topic=ibm-spectrum-lsf-deployment-values). 
9. Review the **Required input variables**
   ![](images/60-tile5-required.png ':size=600')
10. Expand the **Optional input variables**
   ![](images/60-tile6-optional-expand.png ':size=600')
11. Review the **Optional input variables**
   ![](images/60-tile6-optional.png ':size=600')
12. After setting and reviewing all the deployment values and **license agreements** the user can **Install** the environment (We skip this step)
13. The **Install** action created the [IBM Cloud Schematics Workspace](https://cloud.ibm.com/schematics/workspaces)
   ![](images/60-schematics-workspaces.png ':size=600')
14. Open the **Workspace** details
   ![](images/60-schematics-workspace-details.png ':size=600')
15. Scroll through the page and logs
16. Open the **Settings** of the job and notice the variables
   ![](images/60-schematics-workspace-settings.png ':size=600')


?> Voila, we have reviewed the deployment of a HPC environment using Schematics and Terraform. For more details review the documentation of [IBM Spectrum LSF](https://cloud.ibm.com/docs/ibm-spectrum-lsf?topic=ibm-spectrum-lsf-getting-started-tutorial) and [IBM Cloud Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-getting-started).