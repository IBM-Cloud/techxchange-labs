# Tour the OpenShift AI environment

Once the deployment of the architecture completes, it creates the following resources:
* a Virtual Private Cloud (VPC) and its related network components
* a Red Hat OpenShift cluster in this VPC,
* worker nodes and their GPUs attached to the cluster,

![](images/architecture.svg ':size=600')

In addition, it deploys the Operators necessary for the Red Hat OpenShift AI functionality to the new cluster. The following Operators and their corresponding components are deployed:

* Red Hat Pipelines Operator - Incorporate Tekton pipelines into your AI work.
* Red Hat Node Discovery Feature Operator > Node Discovery Feature instance - this instance actually does the work of labeling nodes.
* Nvidia GPU Operator > Cluster Policy instance - this instance installs the GPU stack of daemonsets and pods.
* Red Hat OpenShift AI Operator > OpenShift AI instance - this instance installs the components.

## Review deployed resources

1. Go to the list of OpenShift clusters at https://cloud.ibm.com/kubernetes/clusters?platformType=openshift.
1. Select the cluster.
1. All cluster indicators are <span style='color: green'>Green</span>.
   ![](images/20-tour-cluster.png ':size=600')
1. Select **Worker nodes** in the left menu.
1. Notice the worker nodes split in two worker pools: `default` and `GPU`.
1. Expand one worker node in the `GPU` worker pool. It is using one of the GPU-enabled flavor.
   ![](images/20-tour-worker-node.png ':size=600')

## Launch OpenShift console

1. Click **OpenShift web console** button.

   !> You may get a _popup blocked_ message depending of your web browser configuration. If so, allow popups from this site and click the button again.
1. The *OpenShift web console* opens.
   ![](images/20-tour-openshift-web-console.png ':size=600')

## Discover Red Hat OpenShift AI environment

### Dashboard

1. In the upper right-hand corner of the console, click the grid icon ᎒᎒᎒. Under the *Openshift Self Managed Services* menu option, select **Red Hat OpenShift AI** to launch the Openshift AI dashboard.
   ![](images/20-tour-launch-osai.png ':size=600')
1. Click **Log in with OpenShift**.
1. After the OpenShift AI dashboard launches, from the left menu, select **Applications > Enabled**. It displays all currently enabled applications. In this case, *Jupyter* is enabled.
   ![](images/20-tour-enabled-applications.png ':size=600')
1. The **Applications > Explore** menu option takes you to a variety of available applications. These include:
   * Red Hat managed cloud services: Applications that have been developed by Red Hat, such as Jupyter.
   * Partner managed services: Services created by one of Red Hat's external partners. These services are available in the OpenShift AI  dashboard.
   * Self-managed software: Other types of software developed by external partners, such as OpenVino. This software is available in the OpenShift AI  dashboard.

### Data Science Projects

As a data scientist, you can organize your data science work into a single project. A data science project in OpenShift AI can consist of the following components:

* **Workbenches** - Creating a workbench allows you to add a Jupyter notebook to your project.
* **Cluster storage** - For data science projects that require data to be retained, you can add cluster storage to the project.
* **Data connections** - Adding a data connection to your project allows you to connect data inputs to your workbenches.
* **Pipelines** - Standardize and automate machine learning workflows to enable you to further enhance and deploy your data science models.
* **Models and model servers** - Deploy a trained data science model to serve intelligent applications. Your model is deployed with an endpoint that allows applications to send requests to the model.

### Data Science Pipelines

As a data scientist, you can enhance your data science projects on OpenShift AI by building portable machine learning (ML) workflows with data science pipelines, using Docker containers. This enables you to standardize and automate machine learning workflows to enable you to develop and deploy your data science models.

For example, the steps in a machine learning workflow might include items such as data extraction, data processing, feature extraction, model training, model validation, and model serving. Automating these activities enables your organization to develop a continuous process of retraining and updating a model based on newly received data. This can help address challenges related to building an integrated machine learning deployment and continuously operating it in production.

### Models

Serving trained models on Red Hat OpenShift AI means deploying the models on your OpenShift cluster to test and then integrate them into intelligent applications. Deploying a model makes it available as a service that you can access by using an API. This enables you to return predictions based on data inputs that you provide through API calls. This process is known as model inferencing. When you serve a model on OpenShift AI, the inference endpoints that you can access for the deployed model are shown in the dashboard.

⇨ [Continue to Configure a Jupyter notebook to use GPUs for AI/ML modeling](30-configure.md)
