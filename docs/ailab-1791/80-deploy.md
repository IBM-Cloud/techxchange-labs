# Deploy and test a model

## Prepare a model for deployment

After you train a model, you can deploy it by using the OpenShift AI model serving capabilities.

To prepare a model for deployment, you must move the model from your workbench to Cloud Object Storage. You use the data connection that you reviewed in the `Configure storage` section and upload the model from a notebook. You also convert the model to the portable ONNX format. ONNX allows you to transfer models between frameworks with minimal preparation and without the need for rewriting the models.

1. In your Jupyter environment, open the `2_save_model.ipynb` file.
1. Follow the instructions in the notebook to upload the portable ONNX model file to the Cloud Object Storage bucket.
1. When you have completed the notebook instructions, the `models/fraud/1/model.onnx` file is in Cloud object storage and it is ready for your model server to use.

## Deploy a model

Now that the model is accessible in storage and saved in the portable ONNX format, you can use an OpenShift AI model server to deploy it as an API.

OpenShift AI offers two options for model serving:

* Single-model serving - Each model in the project is deployed on its own model server. This platform is suitable for large models or models that need dedicated resources.
* Multi-model serving - All models in the project are deployed on the same model server. This platform is suitable for sharing resources amongst deployed models.

In this section, you will deploy on a single-model server. You create a new model server and deploy your model to it.

1. In the OpenShift AI dashboard, go to **Data science projects**.
1. Select the **ailab-1791-dsp** project.
1. Click the **Models** tab.
1. Click **Deploy model**.
1. In the form, provide the following values:
   1. Set **Model deployment name** to the username assigned to you at the beginning of the lab.
   1. Set **Serving runtime** to **OpenVINO Model Server**.
   1. Set **Model framework** to **onnx-1**.
   1. Set **Number of model server replicas to deploy** to **1**.
   1. Set **Model server size** to **Custom**
      1. Set CPU requested to 500 millicores
      1. Set CPU limit to 500 millicores
      1. Set Memory requested to 1 GiB
      1. Set Memory limit to 1 GiB
   1. Set **Existing connection** to **ailab-1791-storage**.
   1. Type the path that leads to the version folder that contains your model file `models/<your-username>/fraud`.
   1. Leave the other fields with the default settings.
   ![](images/80-configure-model-server.png ':size=600')
1. Click **Deploy**.
1. Wait for the model to deploy and for the Status to show a <span style='color: green'>green</span> checkmark.

## Test the model API

Now that you’ve deployed the model, you can test its API endpoints.

1. Note the model’s Inference endpoint. You need this information when you test the model API.
   ![](images/50-dsp-get-api-endpoint.png ':size=600')
1. Return to the Jupyter environment to try out your new endpoint.
1. Open the file `5_rest_requests_single_model.ipynb` to try a REST API call.
1. Notice how the `infer_url` is built after the project and the model names:.
   ![](images/80-define-infer-url.png ':size=600')
1. Follow the instructions in the notebook to call your model through the REST API. The example tries calls with two different parameter values, one resulting in no fraud being detected, and one with fraud being detected.
1. When done:
   1. Delete the model you created.
   1. Delete the workbench you created.

?> In this section you learned how to expose a model through a REST (or gRPC) API within your cluster. The same API can also be exposed outside the cluster.
