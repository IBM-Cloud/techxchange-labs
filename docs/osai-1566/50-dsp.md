# Setup a project and storage

In this section, you learn how to incorporate data science and artificial intelligence and machine learning (AI/ML) into an OpenShift development workflow.

You will use an example fraud detection model to complete the following tasks:
* Explore a pre-trained fraud detection model by using a Jupyter notebook.
* Deploy the model by using OpenShift AI model serving.

The example fraud detection model monitors credit card transactions for potential fraudulent activity. It analyzes the following credit card transaction details:

* The geographical distance from the previous credit card transaction.
* The price of the current transaction, compared to the median price of all the user’s transactions.
* Whether the user completed the transaction by using the hardware chip in the credit card, entered a PIN number, or for an online purchase.

Based on this data, the model outputs the likelihood of the transaction being fraudulent.

## Set up your data science project

In the previous sections, you used the standalone Jupyter server as a one-off solution running in isolation. To implement a data science workflow, you must use a data science project. Projects allow you and your team to organize and collaborate on resources within separated namespaces. From a project you can create multiple workbenches, each with their own IDE environment (for example, JupyterLab), and each with their own data connections and cluster storage. In addition, the workbenches can share models and data with pipelines and model servers.

1. On the navigation menu, select **Data Science Projects**. This page lists any existing projects that you have access to.
1. Select the existing data science project, already created for you.
   ![](images/50-dsp-select-project.png ':size=600')

You can now see your project’s initial state. Individual tabs provide more information about the project components and project access permissions:
* **Workbenches** are instances of your development and experimentation environment. They typically contain IDEs, such as JupyterLab, RStudio, and Visual Studio Code.
* **Pipelines** contain the data science pipelines that are executed within the project.
* **Models** allow you to quickly serve a trained model for real-time inference. You can have multiple model servers per data science project. One model server can host multiple models.
* **Cluster storage** is a persistent volume that retains the files and data you’re working on within a workbench. A workbench has access to one or more cluster storage instances.
* **Data connections** contain configuration parameters that are required to connect to a data source, such as an S3 object bucket.

## Configure storage

To build your pipeline, you need to configure two storage connections, backed by two buckets in Cloud Object Storage:
* **Model Storage** - Use this bucket for storing your models and data. You can reuse this bucket and its connection for your notebooks and model servers.
* **Pipelines Artifacts** - Use this bucket as storage for your pipeline artifacts. A pipeline artifacts bucket is required when you create a pipeline server. For this tutorial, create this bucket to separate it from the first storage bucket for clarity.

These buckets have already been created and configured for you.

1. Select the **Data connections** tab to view the two bucket configurations.
   ![](images/50-dsp-view-connections.png ':size=600')
