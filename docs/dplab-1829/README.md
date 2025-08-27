# Building AI Workflows with Data Science Pipelines on IBM Cloud

This lab provides guided step-by-step provisioning and configuration for OpenShift AI data science pipelines on IBM Cloud. Data science pipelines provide a way to automate data preparation, model training, evaluation, and deployment tasks for AI usage. This lab will setup data science pipeline in OpenShift AI that will run model evaluation tests for a model that is hosted in the cluster and serves inferencing requests. The evaluation test cases are written in Python and are represented as nodes in a pipeline, that run sequentially. The framework for the evaluation test cases is deepeval, in which simple test cases that test for answer correctness, answer relevancy, and hallucinations are performed. Data science pipelines can be used for just about any workflow you want to automate for your AI projects, so evaluation testing is just one use out of many.



![image](images/architecture.png ':size=600')

⇨ [It's time to jump right in!](10-create-cos-bucket.md)
