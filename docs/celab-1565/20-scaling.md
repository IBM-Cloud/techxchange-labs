# Autoscaling and scale to zero

Because you were the only user accessing the application, Code Engine only needed one instance of your application to serve the request.

Based on the CPU and memory resources that are allocated to your application, one instance can handle a good number of concurrent requests.

![](images/20-one-instance.png ':size=400')

But eventually, when your application workload increases, one instance is not going to be enough. You can configure Code Engine to **automatically scale up** and create additional instances to handle your application workload when it increases. Then, as the load decreases, Code Engine can **automatically scale down** your application to zero when no one is accessing the application.

## Let's generate some load

From the **Overview** tab for your specific application, Code Engine displays basic information about your application instances:
   * The current number of **Instances**.
   * The total number of **CPU** and **Memory** used by these instances.

Now, let’s see what happens when this app gets a lot of traffic!
1. Go to https://ibm.biz/1565-loadgen.
1. Copy and paste the URL of the application in the form.
   ![](images/20-configure-load.png ':size=400')
1. Click **Generate Load**.
1. Back on the application’s **Overview** tab, watch the number of instances, CPU, and memory increase as the load increases. Code Engine is automatically scaling up the instances.
   ![](images/20-load.png ':size=400')
1. When the load test completes, Code Engine automatically scales down the instances for this application by decreasing the number of instances to 0.
   ![](images/20-load-scale-to-zero.png ':size=400')

?> With IBM Cloud Code Engine, you don't need to think about scaling your application because the number of running instances of an application is automatically scaled up or down (to zero) based on incoming requests. With automatic scaling, you don't pay for resources that are not used.
<br><br>
Code Engine monitors the number of requests in the system and scales the application instances, within the constraints of the application's concurrency settings.

In this exercise, you have observed that your application automatically scaled up and down based on workload.

⇨ [Continue to Configuration and versions](30-configuration-and-versions.md)