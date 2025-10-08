# Build from source

You can deploy your application directly from source code that's located in a Git repository.

![](images/55-source-to-code.png ':size=300')

Code Engine can automatically push (upload) images to IBM Container Registry namespaces in your account and even create a namespace for you.

Whether your code is in a public or private Git repository or in your local system, Code Engine provides the capability to build and deploy your application in both scenarios.

## Enable your project to write to IBM Container Registry

### Create an IAM service ID

To provide Code Engine `read` and `write` access to the Container Registry, we'll create an IAM service ID.

1. Go to https://cloud.ibm.com/iam/serviceids
   * Alternatively, use the **Manage > Access (IAM)** menu and select **Service IDs** on the left.
1. Click **Create service ID**.
1. Set **Name** to something like `<your-username>-sid`. As example `celab-123-sid`.
1. Click **Create**.
   ![](images/55-create-sid.png ':size=750')

### Configure service ID access permissions

First, we'll configure an access policy that grants permission to push and pull from a specific IBM Container Registry namespace.
1. Click **Assign access**.
   ![](images/55-assign-access.png ':size=750')
1. Set **Service** to **Container Registry**.
1. Click **Next**.
1. In **Resources**, select **Specific resources**.
   1. Select **Geography** as attribute type and pick **Global** as **Value**.
   1. Click **Add a condition**.
   1. Select **Resource Type** as attribute type and type **namespace** as **Value**.
   1. Click **Add a condition**.
   1. Select **Resource Name** as attribute type and use your username (like `celab-123`) as **Value**.
   ![](images/55-service-id-resources.png ':size=500')
1. Click **Next**.
1. In **Roles and actions**, select **Reader** and **Writer**.
   ![](images/55-service-id-roles.png ':size=500')
1. Click **Next**, **Add**, and **Assign**.
   ![](images/55-policy-assigned.png ':size=750')

In order to be enable the Code Engine Web-UI to discover the IBM Container Registry namespace, we'll need to create a second access policies that grants permissions to the service ID to administer itself.

1. Add a second access policy by clicking **Assign access**.
1. Set **Service** to **IAM Identity Service**.
1. In **Resources**, select **Specific resources**.
   1. Select **Resource type** as attribute type and type **serviceid** as **Value**.
   1. Click **Add a condition**.
   1. Select **Resource ID** as attribute type and copy and past the service ID UUID from the browsers address bar into the **Value** field. E.g. `ServiceId-1d764eb0-59b6-4b53-bf60-7a877cc84d68`.
   ![](images/55-service-id-resources-2.png ':size=500')
1. Click **Next**.
1. In **Roles and actions**, select **Administrator**.
1. Click **Next**, **Add**, and **Assign**.
   ![](images/55-policy-assigned-2.png ':size=750')


### Generate an API key for the service ID

1. Select the **API keys** tab.
1. Click **Create**.
1. Set **Name** to **for-codeengine**.
   ![](images/55-service-id-apikey.png ':size=750')
1. Click **Create**.
1. Click **Copy** and paste the value in a text file. You will need it later.

## Deploy an application from source code

### Create a registry access secret

1. Go to https://cloud.ibm.com/containers/serverless/projects
   * Alternatively, use the navigation menu to go to the Code Engine Projects page: **☰ > Containers > Serverless (Code Engine) > Serverless Projects**.
1. Select the project you created previously.
1. Select **Secrets and configmaps** in the left menu.
1. Click **Create**.
1. Select **Registry secret**.
1. Click **Next**.
   1. Set **Secret name** to **ibm-container-registry**.
   1. Set **Target registry** to **IBM Container Registry**
   1. Set **Location** to **Global (private.icr.io)**.
   1. Set **IAM API key** to the value of the API key you copied in the previous steps.
   1. Leave **Email** empty.
1. Click **Create**.
   ![](images/55-create-registry-secret.png ':size=750')

### Create a new application

1. In the breadcrumb click on name of your project, to navigate back to the project overview page.
   ![](images/55-click-breadcrumb.png ':size=750')
1. Select **Applications** from the left menu of your project.
1. Click **Create**.
1. Set the **Name** to something like `<your-username>-from-source`. As example `celab-123-from-source`.
1. Select **Build container image from source code**.
   ![](images/55-new-app-from-source.png ':size=750')
1. Click **Specify build details**.
   1. In **Source**, keep the default values.
   1. Click **Next**.
   1. In **Strategy**, keep the default values. The source code uses a `Dockerfile`.
   1. Click **Next**.
   1. In **Output**, set **Registry server** to **private.icr.io (IBM Registry Global)**.
   1. Set **Registry access secret** to **ibm-container-registry** (created earlier).
      > Note: The Namespace is pre-selected with information from the IBM Container registry.
   1. Set **Repository (image name)** to `<your-username>-helloworld`, as example `celab-123-helloworld`.
   1. Click **Done**.
   ![](images/55-specify-build-details.png ':size=750')
1. Under **Instance resources**, set **CPU and memory** to **0.125 vCPU / 0.25 GB** (the first in the list).
1. Click **Create**.
   ![](images/55-create-app-from-source.png ':size=750')

### View the deployed application

Code Engine triggers a build of your application by pulling the code from the public repository containing the sample _Hello world_ app https://github.com/IBM/CodeEngine. To view the progress of the build:

![](images/55-app-deploying.png ':size=750')

1. Navigate to **Configuration** page.
1. The **Code** tab shows the image reference, the secret that was used and a link to the _build_ log.
   ![](images/55-view-build.png ':size=750')
1. Click **View build**.
1. Click on the first _Build run_ in the **Build runs** table to view the details of the build operation
   ![](images/55-buildrun-list.png ':size=750')
1. By expanding the sections, one can observe the progress of how Code Engine pulled, built and pushed the source code to the IBM Cloud Container registry.
   ![](images/55-build-complete.png ':size=750')

Wait for the build to complete, go back to your application and access the application.

?> To learn more about deploying an application directly from source code, see [Deploying your app from repository source code](https://cloud.ibm.com/docs/codeengine?topic=codeengine-app-source-code).

⇨ [Continue to More to discover](60-more-to-discover.md)
