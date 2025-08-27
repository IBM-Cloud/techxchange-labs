# Build, train, and run a PyTorch model

## Use GPU with simple functions

1. Run the steps under the **Loading vectors, matrices, and other data onto the GPU** section of the notebook. These steps show you how to use the PyTorch library to interact with the GPU device through the CUDA software layer.
1. Notice that you need to make sure your computation happens on the GPU device otherwise it will use the CPU.
   ![](images/40-use-gpu.png ':size=600')

## Train and save a model

In the section, you will train your neural network model using the [FashionMNIST data set](https://github.com/zalandoresearch/fashion-mnist), a fashion product database.

1. Run the steps under the **Loading a Neural Network Model onto the GPU** section. Again notice that the model is loaded onto the GPU by targeting the device with `SimpleNet().to(device)`.
   ![](images/40-load-model.png ':size=600')
1. Continue with the **Training the Neural Network Model** section to load the fashion data set. Eventually the notebook shows random items from the data set.
   ![](images/40-train-show-items.png ':size=600')
1. Continue through the notebook to train the model.
   ![](images/40-train-model.png ':size=600')
1. Run the last step **Saving the model**. This step creates a file named `mnist_fashion_SimpleNet.pt` containing model's weights.
   ![](images/40-train-save.png ':size=600')

## Run the model

Now that the model is trained, let's put it to the test. The model predicts the category that a fashion item should be in, and lists its confidence percentage beside the prediction.

1. Double-click on the `torch-test-model.ipynb` file to open this notebook.
1. Go through the first steps to set up the environment.
   ![](images/40-run-setup.png ':size=600')
1. Continue with the steps of the **Load the model and trained weights onto the GPU** section.
   ![](images/40-run-load.png ':size=600')
1. Finally proceed with the **Run the model and check the results** steps. You can re-run the step to get the model to pick another image.
   ![](images/40-run-predict.png ':size=600')

## Stop the notebook

1. In Red Hat OpenShift AI console, select **Applications / Enabled**.
1. Click **Launch Application** in the *Jupyter* tile.
1. Click **Stop notebook server**
   ![](images/40-stop-notebook.png ':size=600')



⇨ [Continue to Be a data scientist](50-dsp.md)
