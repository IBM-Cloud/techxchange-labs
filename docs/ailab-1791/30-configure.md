# Configure a Jupyter notebook to use GPUs for AI/ML modeling

Red Hat OpenShift AI provides a fully supported environment in which to rapidly develop, train, and test machine learning models before deploying them in production.

In this section, you will walk through configuring a Jupyter notebook to use GPUs for AI/ML modeling. You will learn how to use PyTorch to examine GPU resources, then load and run a PyTorch model.

## Start your Jupyter notebook server

Let's start by setting up options for your Jupyter notebook server.

1. Go to Applications > Enabled
1. Click **Launch application** in the **Jupyter** tile.

A configuration screen gives you the opportunity to select a notebook image and configure its options.

![](images/30-jupyter-configure-server.png ':size=600')

Available notebook images include:
   * Minimal Python
   * Standard Data Science
   * CUDA
   * PyTorch
   * Tensorflow
   * TrustyAI
   * Habana

You can also choose different deployment sizes based on the type of data analysis and machine learning code you are working on. Each deployment size is pre-configured with specific CPU and memory resources.

1. Select **PyTorch** and under **Versions**, select **Version 2025.1**.
1. Set **Container Size** to **Small**.
1. Click **Start server**.

   !> You may see an "Insufficient resources" message. It will disappear after a few seconds.
1. Wait for the server to be up and running.
   ![](images/30-jupyter-start-server.png ':size=600')
1. Select to open the server in a new tab.
   ![](images/30-jupyter-open-server.png ':size=400')
1. Authorize access.
   ![](images/30-jupyter-allow.png ':size=600')
1.  Welcome to your very own *JupyterLab*!

## Examine GPU resources with PyTorch

After starting your server, these sections appear in JupyterLab's launcher:
* Notebook
* Console
* Elyra - Elyra is a set of AI-centric extensions to JupyterLab Notebooks.
* Other

In the window, locate the following components:
* on the left side is the file explorer panel. This panel is where you can create and manage your notebook directories.
* at the top is the menu bar with the most common actions to work with notebooks.
   ![](images/30-jupyter-launcher.png ':size=600')

### Clone a GitHub repository

Now it's time to populate your JupyterLab notebook with a GitHub repository.

1. Under the **Git** menu, select the **Clone a Repository** menu option.
1. Set the **URI** to **https://github.com/IBM-Cloud/roks-osai-getting-started-with-gpus**.
   ```
   https://github.com/IBM-Cloud/roks-osai-getting-started-with-gpus
   ```
1. Click **Clone**. The repository contents appear in a directory in the file explorer panel.
1. Double-click on the newly created directory under the file explorer panel. The directory contains several notebooks as .ipnyb files, along with a standard license and README file.
   ![](images/30-jupyter-cloned.png ':size=600')

### View the GPU configuration

1. Double-click on the `torch-use-gpu.ipynb` file to open this notebook.
   ![](images/30-jupyter-gpu-open.png ':size=600')
1. Run the first step `!nvidia-smi`. This step gets some basic information about the GPU resources available to your notebook server.
   ![](images/30-jupyter-gpu-view.png ':size=600')
1. Continue running the steps until the step retrieving the device name of the GPU `torch.cuda.get_device_name(0)`.
   ![](images/30-jupyter-gpu-name.png ':size=600')

In this lab, you have access to one NVIDIA L40S GPU.

?> Your environment is correctly configured. Time to play with this **<span style="color: darkblue">GPU</span>**!

⇨ [Continue to Build, train, and run a PyTorch model](40-build-train-run.md)
