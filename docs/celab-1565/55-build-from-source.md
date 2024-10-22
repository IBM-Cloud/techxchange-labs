# Build from source

You can deploy your application directly from source code that's located in a Git repository.

![](images/55-source-to-code.png ':size=300')

Code Engine can automatically push (upload) images to IBM Cloud Container Registry namespaces in your account and even create a namespace for you.

Whether your code is in a public or private Git repository or in your local system, Code Engine provides the capability to build and deploy your application in both scenarios.

## Enable your project to write to IBM Cloud Container Registry

### Create a _Service ID_ to provide Code Engine `write` access to the Container Registry

1. Go to https://cloud.ibm.com/iam/serviceids
   * Alternatively, use the **Manage > Access (IAM)** menu and select **Service IDs** on the left.
1. Click **Create**.
1. Set **Name** to something like `<your-username>-sid`. As example `celab-123-sid`.
1. Click **Create**.

### Configure the access for the Service ID

1. Click **Assign access**.
   ![](images/55-assign-access.png ':size=400')
1. Set **Service** to **Container Registry**.
1. Click **Next**.
1. In **Resources**, select **Specific resources**.
   1. Select **Geography** as attribute type and pick **Global** as **Value**.
   1. Click **Add a condition**.
   1. Select **Resource Type** as attribute type and type **namespace** as **Value**.
   1. Click **Add a condition**.
   1. Select **Resource Name** as attribute type and use your username (like `celab-123`) as **Value**.
   ![](images/55-service-id-resources.png ':size=400')
1. Click **Next**.
1. In **Roles and actions**, select **Writer**.
1. Click **Next**.
1. Click **Add**.
1. Click **Assign**.

### Generate an API key for the Service ID:

1. Select the **API keys** tab.
1. Click **Create**.
1. Set **Name** to **for-codeengine**.
   ![](images/55-service-id-apikey.png ':size=400')
1. Click **Create**.
1. Click **Copy** and paste the value in a text file. You will need it later.

## Deploy an application from source code

### Create a registry access secret

1. Go to https://cloud.ibm.com/codeengine/projects
   * Alternatively, use the navigation menu to go to the Code Engine Projects page: ☰ > Containers > Serverless > Projects.
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
   ![](images/55-create-registry-secret.png ':size=400')

### Create a new application

1. Select **Applications** from the left menu of your project.
1. Click **Create**.
1. Set the **Name** to something like `<your-username>-from-source`. As example `celab-123-from-source`.
1. Select **Build container image from source code**.
1. Click **Specify build details**.
   1. In **Source**, keep the default values.
   1. Click **Next**.
   1. In **Strategy**, keep the default values. The source code uses a `Dockerfile`.
   1. Click **Next**.
   1. In **Output**, set **Registry server** to **private.icr.io (IBM Registry Global)**.
   1. Set **Registry access secret** to **ibm-container-registry** (created earlier).
      > Ignore the warning access the registry. It is expected as we gave a limited set of permissions to the Service ID.
   1. Set **Namespace** to your username (like `celab-123`).
   1. Set **Repository (image name)** to `<your-username>-helloworld`, as example `celab-123-helloworld`.
   1. Click **Done**.
1. Under **Instance resources**, set **CPU and memory** to **0.125 vCPU / 0.25 GB** (the first in the list).
1. Click **Create**.

### View the deployed application

Code Engine triggers a build of your application by pulling the code from the public repository containing the sample _Hello world_ app https://github.com/IBM/CodeEngine. To view the progress of the build:

1. In the **Configuration revisions** table, click the first (and only) row.
1. The **Code** tab shows the image reference, the secret that was used and a link to the _build_ log.
   ![](images/55-view-build.png ':size=400')
1. Click **View build**.
1. Click on the first _Build run_ in the **Build runs** table to view the details of how Code Engine pulled, built and pushed the source code to the IBM Cloud Container registry.
   ![](images/55-build-complete.png ':size=400')

Wait for the build to complete, go back to your application and access the application.

?> To learn more about deploying an application directly from source code, see [Deploying your app from repository source code](https://cloud.ibm.com/docs/codeengine?topic=codeengine-app-source-code).

⇨ [Continue to More to discover](60-more-to-discover.md)
