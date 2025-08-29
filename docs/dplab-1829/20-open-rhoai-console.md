## Step 2: Open the OpenShift AI console

1. In the IBM Cloud console, navigate to the Resource List and expand the **Containers** category. Select the `l4-lab-paas-rhoai-cluster`
2. At the top of the screen, Click the **OpenShift web console** button
3. In the top navigation bar, click the **grid icon (A)** and then click **Red Hat OpenShift AI (B)**

    ![image](images/dp-openshift-ai-console.png)

4. Open the **Model Deployments (A)** menu to view the deployed models on the OpenShift AI cluster. You will need 2 bits of information to build the pipeline in a later step. Record the **Model deployment name (B)**. Click on the **Inference endpoint (C)** link. Record the **External (D)** endpont of the model. These values will vary by the model deployed and the cluster the model is deployed on.
    Record:
    * **Model deployment name**: `model-granite-3.3-8b-instruct` (example)
    * **Inference endpoint (external)**: `https://model-granite-33-8b-instruct-aal4lab-v1.l4-lab-paas-rhoai-946464-1cce585f5a0d7ffedb5150cacf858bae-0000.br-sao.containers.appdomain.cloud` (example)

    ![image](images/dp-model-deployments.png)
