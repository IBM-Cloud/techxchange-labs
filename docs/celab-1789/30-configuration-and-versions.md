# Configuration and versions

Every change made to the configuration of an application creates an immutable revision. Changes can include:
- Deploying a new version of your code
- Changing the runtime resources (CPU, memory, number of instances)
- Adding or removing an environment variable

Really, any change you make to the configuration of an application is saved as a new revision of the application.

## Let’s make a change to the configuration of your application

From the **Configuration** tab for your specific application, Code Engine displays information about  the selected revision and its characteristics.

![](images/30-configuration.png ':size=800')

1. Click **Redeploy**.
1. Select the **Resources & scaling** tab.
   1. Set **CPU and memory** to `0.25 vCPU / 0.5 GB`.
   1. Set **Min number of instances** to 1.
   1. Set **Max number of instances** to 5.
   ![](images/30-set-runtime.png ':size=750')
1. Select the **Environment variables** tab.
   1. Click **Add environment variable**.
   1. Select **Literal value**.
   1. Set **Environment variable name** to `HELLO`.
   1. Set **Value** to `WORLD`
   ![](images/30-env-var.png ':size=750')
   > Note that you can use also use configmap and secrets defined at the project level.
   1. Click **Add**.
1. Click **Deploy**.
   ![](images/30-click-deploy.png ':size=800')

When you save the configuration changes, Code Engine deploys a new version of your application with the configuration changes.

## New version deployed!

When Code Engine deploys a new version of your application with the new settings, Code Engine also automatically moves the traffic from the previous version to the new version. Let’s observe this. 

1. Switch to the **Overview** tab.
1. When the new version is `Ready`, notice there is `1` instance of the application that is running with the lower CPU and memory consumption. This value corresponds to the minimum number of instances setting that was changed.
1. Access the application URL via the **Test application** button or by refreshing the application if you still have a browser tab open.
   > Note that the application URL does not change between versions.
1. The `HELLO` environment variable is now showing in the application.
   ![](images/30-hello-world.png ':size=500')

You have now changed the configuration of your application and deployed a new revision with those changes.

⇨ [Continue to Service bindings](40-service-binding.md)