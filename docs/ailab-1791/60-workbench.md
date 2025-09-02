# Create a workbench and a notebook

A workbench is an instance of your development and experimentation environment. Within a workbench you can select a notebook image for your data science work.

## Create a workbench

1. Navigate to the project detail page for your data science project.
1. Click the **Workbenches** tab, and then click the **Create workbench** button.
1. Set the name to your username, as example `ailab-123`.
1. Select the TensorFlow image.
   > Red Hat provides several supported notebook images. In the Notebook image section, you can choose one of these images or any custom images that an administrator has set up for you. The Tensorflow image has the libraries needed for this lab.
1. Set the image version to **2025.1**.
1. Choose **Small** for **Container size**.
1. Edit the cluster storage using the action menu (&#8942;) and set the **Persistent storage size** to **5GiB**.
1. Leave the default environment variables and storage options.
1. Under **Connections**
   1. Click **Attach existing connections**.
   1. Select the **ailab-1791-storage** from the list.
   1. Click **Attach**.
   ![](images/60-workbench-settings.png ':size=600')
1. Click the **Create workbench** button.
1. Wait for the workbench to start.
1. Eventually, in the **Workbenches** tab for the project, the status of the workbench changes from **Starting** to **Running**.

## Import the tutorial files into the Jupyter environment

The Jupyter environment is a web-based environment, but everything you do inside it happens on Red Hat OpenShift AI and is powered by the OpenShift cluster. This means that, without having to install and maintain anything on your own computer, and without disposing of valuable local resources such as CPU, GPU and RAM, you can conduct your data science work in this powerful and stable managed environment.

1. Click on your workbench in the list to open it. If prompted, log in and allow the Notebook to authorize your user.
   ![](images/50-dsp-open-workbench.png ':size=600')
   Your Jupyter environment window opens. This file-browser window shows the files and folders that are saved inside your own personal space in OpenShift AI.
1. Under the **Git** menu, select the **Clone a Repository** menu option.
1. Set the **URI** to **https://github.com/IBM-Cloud/roks-osai-fraud-detection**.
   ```
   https://github.com/IBM-Cloud/roks-osai-fraud-detection
   ```
1. Click **Clone**. The repository contents appear in a directory in the file explorer panel.
1. Double-click on the newly created folder, `roks-osai-fraud-detection`.
   ![](images/50-dsp-cloned.png ':size=400')
