# Deploy and test a model

## Prepare a model for deployment

After you train a model, you can deploy it by using the OpenShift AI model serving capabilities.

To prepare a model for deployment, you must move the model from your workbench to Cloud Object Storage. You use the data connection that you reviewed in the `Configure storage` section and upload the model from a notebook. You also convert the model to the portable ONNX format. ONNX allows you to transfer models between frameworks with minimal preparation and without the need for rewriting the models.

1. In your Jupyter environment, open the `2_save_model.ipynb` file.
1. Follow the instructions in the notebook to make the model accessible in storage and save it in the portable ONNX format.
1. When you have completed the notebook instructions, the `models/fraud/1/model.onnx` file is in Cloud object storage and it is ready for your model server to use.

## Deploy a model

Now that the model is accessible in storage and saved in the portable ONNX format, you can use an OpenShift AI model server to deploy it as an API.

OpenShift AI offers two options for model serving:

* Single-model serving - Each model in the project is deployed on its own model server. This platform is suitable for large models or models that need dedicated resources.
* Multi-model serving - All models in the project are deployed on the same model server. This platform is suitable for sharing resources amongst deployed models.

In this section, you will deploy on a multi-model server. OpenShift AI multi-model servers can host several models at once. You create a new model server and deploy your model to it.

1. In the OpenShift AI dashboard, navigate to the project details page and click the **Models** tab.
1. A model server has already been created for you.
1. In the **Models and model servers** list, click **Deploy model**.
   ![](images/80-model-server.png ':size=600')
1. In the form, provide the following values:
   1. Set **Model Name** to **your username**, as example `ailab-123`.
   1. Set **Model framework** to **onnx-1**.
   1. Set **Existing data connection** to **osai-1566-storage**.
   1. Type the path that leads to the version folder that contains your model file `models/<your-username>/fraud`, as example `models/ailab-123/fraud`.
   1. Leave the other fields with the default settings.
1. Click **Deploy**.
1. Wait for the model to deploy and for the Status to show a <span style='color: green'>green</span> checkmark.

## Test the model API

Now that you’ve deployed the model, you can test its API endpoints.

1. Note the model’s Inference endpoint. You need this information when you test the model API.
   ![](images/50-dsp-get-api-endpoint.png ':size=600')
1. Return to the Jupyter environment to try out your new endpoint.
1. Open the file `3_rest_requests_multi_model.ipynb` to try a REST API call.
1. Notice how the `infer_url` is built after the project and the model names:.
   ![](images/80-define-infer-url.png ':size=600')
1. Follow the instructions in the notebook to call your model through the REST API. The example tries calls with two different parameter values, one resulting in no fraud being detected, and one with fraud being detected.

?> In this section you learned how to expose a model through a REST (or gRPC) API within your cluster. The same API can also be exposed outside the cluster.
