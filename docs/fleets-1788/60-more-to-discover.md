# More to discover

There are more capabilities built in Code Engine to help you build and deploy your applications. Several are highlighted below.

## Run a Fleet with Serverless GPUs

Fleets support GPUs. The user can specify the GPU by setting the worker profile or defining the GPU-family, e.g. L4, L40s, A100, A200, H100. When selecting a GPU, Code Engine will automatically configure the GPU-drivers on the host and make the GPU devices available to the container instance. Common frameworks like PyTorch or tools like Docling will automatically detect the GPU devices. 

For example, in order to run the previous fleet with Docling on a Nvidia L40s GPU, the user would simply specify 
1. `--gpu l40s` to select the GPU-family, and
2. `--image quay.io/docling-project/docling-serve` to use the GPU-enabled container image of Docling

All other configurations, like the tasks definition with commands and arguments as well as the mount points would remain the same. This allows easy adoption of GPUs without the burder of infrastructure management.


## Pricing of Serverless Fleets

When you run a fleet, charges apply only for the CPU, GPU and memory resources that are consumed while the fleet runs. Charges incur based on the number of milliseconds that your workers run. For non-GPU workers, the cost is the same for all worker node profiles. However, if you choose to use GPUs, an additional cost is applied. The exact amount of the additional charge for GPUs *does* vary between different worker profiles. For example,

For example, in the docling example the fleet was running 11 tasks (PDFs) where each task required 4 vCPU and 8 GB memory. In total, the fleet required 44 vCPU and 88 GB of memory and run for about 6 min (0.1 hours). Code Engine provisioned and charged the following workers to run the fleet on the required resources:
- worker 1 with profile `cx2-32x64`
- worker 2 with profile `cx2-8x16`
- worker 3 with profile `cx2-4x8`

This results in a total charge of *44 vCPU * 0.1 hours * $0.0048/hour+ 88 GB * 0.1 hours * $0.0042/hour = $0.05808* which would run in the free-tier.

The charges seamlessly increase ith the scale of tasks and their CPU/Memory and runtime specification. 
If no task is running, no charges incur. A purely serverless pricing model!

## Run a Fleet from your source code

Code Engine's main claim is "Run any code. Easily. At scale"... But so far, we ran only code that had been packaged already. Let us change this by deploying YOUR code :) 

In this section, you are going to deploy source code hosted on github.com. Precisly, we'll perform a Monte Carlo simulation on a set of stock tickers. More details on the concrete use case can be found [here](https://github.com/IBM/CodeEngine/blob/main/beta/serverless-fleets/tutorials/simulation/README.md).

### Prepare the GitHub repository
1. Login to GitHub.com and navigate to https://github.com/IBM/CodeEngine
2. Fork the repository into your personal GitHub organization
3. (If you don't want to create a fork, continue this section by using the original repository URL: https://github.com/IBM/CodeEngine)

### Create a build
1. Navigate to Serverless projects list page https://cloud.ibm.com/containers/serverless/projects.
1. Select your project, e.g. `fleetlab-user1--ce-project`.
1. Navigate to **Image builds** using the side navigation on the left.
1. Switch to the **Image build** tab and create a new buld by clicking **Create**.
1. Set the **Name** of the build to something unique like `<your-username>-build`. As example `fleetlab-user1-build`.
1. Set the URL that points to your fork, e.g. `https://github.com/<YOUR_ORG>/CodeEngine`
1. Assuming the forked Github repository is public, we can skip the SSH secret part.
1. Set `beta/serverless-fleets/tutorials/simulation` as context directory and click `Next`.
1. Keep the defaults (Dockerfile strategy) and click `Next`.
1. Set a unique **Namespace**, like `ce-txc2025-<your-username>-icr`. As example `ce-txc2025-fleetuser1-icr`.
1. Set the repository to `simulation`. 
1. Complete the dialogue by clicking `Done`.

### Run the build
1. On the buid details page, click `Create` and confirm by clicking `Submit build` in the sidepanel to submit a build run that converts your source code to a container image.
1. Observe the build run execution by observing the log records published on the build run details page.
1. Repeat this step, after each contribution to the github repo to pick-up source code updates.

### Run a fleet using your container image
1. Navigate to the projects overview page and click on **Fleets** in the side navigation.
1. Click **Create**
1. Click **Configure image** to open the side panel that allows you to choose the container image that you've just built
1. Download the following file to your local workstation: <a href="./assets/simulations-commands.jsonl" target="_blank" download="commands.jsonl">commands.jsonl</a>
1. Import the downloaded file as **Task from file**.
1. Set the **Task state store** to `fleet-task-store`.
1. Set **vCPU per instance** to `1 vCPU` and **Memory per instance** to `4 GB`.
1. Set the **Max number of concurrent instances** to `24` to launch all tasks in parallel.
1. Add a volume mount with **Read-write** permissions for the **Mount path** `/output` that uses the **Persistent data store** `fleet-output-store` and writes the results to the **Bucket subpath** `/simulation`.

### Check the results
1. Navigate to the COS bucket `fleet-output-store` and download the results of the Monte Carlo simulation.


## Deploy a Code Engine application

With Code Engine, you can also deploy applications to serve HTTP requests or responnd to events. A file added to an Object Storage bucket, or a timed trigger, are such examples of sources for to these events.

In this section, you are going to log in to IBM Cloud, deploy an application and access it, all from the IBM Cloud web console. The application is a simple _Hello World_.

### Deploy your app

1. Navigate back to https://cloud.ibm.com/containers/serverless/overview 
1. Click **Start creating**
1. Select **Application** as the component type you'd like to deploy.
1. Set the **Name** of the application to something unique like `<your-username>-helloworld-app`. As example `fleetlab-user1-helloworld-app`.
1. Review the other settings in the page but keep their default values:
   * **Code** - This example application uses a pre-built sample image that is publically available in IBM Cloud Container Registry (`icr.io/codeengine/helloworld`). However, outside of this specific example, you can easily use your own container image or even start from a source code repository.
      * Because this example uses a sample that is publically available, no registry access is required. (I would acknowledge the registry access secret setting).
      * This application listens internally for requests on port `8080`, but is exposed by Code Engine on the standard `443` HTTPS port.
   * **Resources & Scaling** - You can configure resources that are associated with your application including CPU, memory, storage, number of instances, and autoscaling settings.
   * **Domain mappings** - These settings control the visibility of your application. Consider if your application is internet-facing, only available inside the IBM Cloud network, or only available to other applications in the same Code Engine project.
   * **Environment variables** - You can use these settings to inject configuration key-value pairs into your running code.
   * **Image start options** - Use these settings to override how the application is started within the container.
1. Click **Create**.

### Test the app

After a short time, **your application is deployed** and ready to serve requests. 

![](images/60-app-running.png ':size=400')

1. Click **Test application**.
1. From the Test application page, click **Application URL** to access the application.
1. Wait for a short time for Code Engine to start the first instance of your application and for your application to display output.

![](images/60-app-output.png ':size=400')


⇨ [Continue to Conclusion](90-conclusion.md)