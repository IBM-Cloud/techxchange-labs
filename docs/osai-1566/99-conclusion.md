# Conclusion

In this tutorial, you learned how to incorporate data science and artificial intelligence (AI) and machine learning (ML) into an OpenShift development workflow.

You used an example fraud detection model and completed the following tasks:
* Explored a pre-trained fraud detection model by using a Jupyter notebook.
* Deployed the model by using OpenShift AI model serving.

But there is more! You can automate these tasks by using Red Hat OpenShift AI pipelines. Pipelines offer a way to automate the execution of multiple notebooks and Python code. By using pipelines, you can execute long training jobs or retrain your models on a schedule without having to manually run them in a notebook.
   ![](images/99-pipelines.png ':size=600')

_This lab is based on these Red Hat tutorials [1](https://developers.redhat.com/learn/openshift-data-science/configure-jupyter-notebook-use-gpus-aiml-modeling), [2](https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/2.10/html/openshift_ai_tutorial_-_fraud_detection_example/index)._