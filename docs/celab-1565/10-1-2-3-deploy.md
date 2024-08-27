# 1-2-3 Deploy!

With Code Engine, you can deploy applications to serve HTTP requests or to deploy jobs to perform a task in response to events. A file added to an Object Storage bucket, or a timed trigger, are such examples of sources for to these events.

In this section, you are going to log in to IBM Cloud, deploy an application and access it, all from the IBM Cloud web console. The application is a simple _Hello World_.

## Log in to IBM Cloud

1. Go to https://ibm.biz/1565-invite
1. Enter the `Username` and `Password` provided for the lab.
1. Click **Sign in**.
  ![](images/10-login.png ':size=600')
1. You are now logged in IBM Cloud.
  ![](images/10-logged.png ':size=600')

## Create a project

A project is a grouping of Code Engine entities such as applications, jobs, and builds. The name of your project must be unique within your IBM Cloud resource group, user account, and region. Projects are used to manage resources and provide access to its entities.

1. Go to https://cloud.ibm.com/codeengine/overview
   * Alternatively, use the navigation menu to go to the Code Engine Overview page: ☰ > Code Engine > Overview.
1. Click **Let's go**.
  ![](images/10-landing.png ':size=400')
1. Click **Create project**
  ![](images/10-click-create-project.png ':size=400')
1. Set the **Location** to **Dallas** or **Washington DC**.
1. Set the **Name** to something like `<your-username>-helloworld-project`. As example `celab-123-helloworld-project`.
1. Keep the default choices for **Resource group** and **Tags**.
1. Click **Create**.
  ![](images/10-create-project.png ':size=400')
1. Wait for the project to be created.

## Deploy your app

1. Select **Application** as the component type you'd like to deploy.
1. Set the **Name** of the application to something unique like `<your-username>-helloworld-app`. As example `celab-123-helloworld-app`.
1. Review the other settings in the page but keep their default values:
   * **Code to run** - This example application uses a pre-built sample image that is publically available in IBM Cloud Container Registry (`icr.io/codeengine/helloworld`). However, outside of this specific example, you can easily use your own container image or even start from a source code repository.
      * Because this example uses a sample that is publically available, no registry access is required. (I would acknowledge the registry access secret setting).
      * This application listens internally for requests on port `8080`, but is exposed by Code Engine on the standard `443` HTTPS port.
   * **Resources & Scaling** - You can configure resources that are associated with your application including CPU, memory, storage, number of instances, and autoscaling settings.
   * **Domain mappings** - These settings control the visibility of your application. Consider if your application is internet-facing, only available inside the IBM Cloud network, or only available to other applications in the same Code Engine project.
   * **Environment variables** - You can use these settings to inject configuration key-value pairs into your running code.
   * **Image start options** - Use these settings to override how the application is started within the container.
1. Click **Create**.

## Test the app

After a short time, **your application is deployed** and ready to serve requests. 

![](images/10-app-running.png ':size=400')

1. Click **Test application**.
1. From the Test application page, click **Application URL** to access the application.
1. Wait for a short time for Code Engine to start the first instance of your application and for your application to display output.

![](images/10-app-output.png ':size=400')

?> **Congratulations!** You just deployed a serverless app in IBM Cloud!

⇨ [Continue to Autoscaling](20-scaling.md)