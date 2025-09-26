# Run a Serverless Fleet to process documents with Docling

![](./images/20-docling-processing.png ':size=600')

[Docling](https://docling-project.github.io/docling/) simplifies document processing, parsing diverse formats — including advanced PDF understanding — and providing seamless integrations with the gen AI ecosystem. Advanced document understanding is essential to build gen AI solutions such as training pipelines or RAG solutions.

This lab provides a comprehensive guide on using serverless fleets to convert PDFs into Markdown format with Docling. It leverages [IBM Cloud Object Storage](https://www.ibm.com/de-de/products/cloud-object-storage) for managing the input (PDFs) and the output (Markdown) files. This lab uses the CPU version of the [docling container image](https://github.com/docling-project/docling-serve?tab=readme-ov-file#container-images) which can easily being replaced using the GPU version in combination with a **Serverless GPU** (as shown later in [more to discover](./60-more-to-discover.md)).


The guide is devided into four steps:
1. Review the prepared example PDFs in the input COS bucket
1. Define the task specification with docling command and arguments
1. Run a fleet to convert the PDFs into Markdown 
1. View the resulting markdown files in the output COS


## Step 1 - View the input data (.pdfs) in COS

1. Navigate to https://cloud.ibm.com/objectstorage/overview
1. Expand **Instances**
1. Click on **fleetlab-user1--cos**
1. Review the three COS buckets that have been prepared:
   * **fleetlab-user1-input** used to store the input for the examples
   * **fleetlab-user1-output** used to store the input for the examples
   * **fleetlab-user1-taskstore** used by Code Engine to store the tasks
   ![](images/20-cos-instance-buckets.png ':size=600')
1. Click on the **fleetlab-user1-input** bucket to open it's content
   ![](images/20-cos-input-bucket.png ':size=600')
1. Click on the **docling** and then **pdfs** folder (prefix) 
1. Review the PDF files (objects)
   ![](images/20-cos-docling-pdfs.png ':size=600')
1. Navigate back to the instance in the left-navigation
1. Click on the **fleetlab-user1-output** bucket to open it's content
1. Click on **docling** and notice that the folder is empty

Now, we will prepare the tasks and will assume that the input bucket is being mounted under `/input` and the output bucket is being mounted under `/output`.

## Step 2 - View the docling commands

Fleets allow to submit tasks from a local file, which contains the command and arguments. In this tutorial we will use `docling` to process the PDF from the input folder and write the resulting Markdown to the output folder, where both folders are mounted from the Cloud Object Storage buckets.

1. Download the <a href="./assets/docling_commands.jsonl" target="_blank" download="docling_commands.jsonl">docling_commands.jsonl</a>
1. Save the file on the Desktop under `docling_commands.jsonl`
1. The content of the file looks as follows:
```
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/2203.01017v2.pdf", "--output", "/output/docling_2203.01017v2.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/2206.01062.pdf", "--output", "/output/docling_2206.01062.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/2305.03393v1-pg9.pdf", "--output", "/output/docling_2305.03393v1-pg9.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/2305.03393v1.pdf", "--output", "/output/docling_2305.03393v1.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/amt_handbook_sample.pdf", "--output", "/output/docling_amt_handbook_sample.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/code_and_formula.pdf", "--output", "/output/docling_code_and_formula.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/picture_classification.pdf", "--output", "/output/docling_picture_classification.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/redp5110_sampled.pdf", "--output", "/output/docling_redp5110_sampled.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/right_to_left_01.pdf", "--output", "/output/docling_right_to_left_01.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/right_to_left_02.pdf", "--output", "/output/docling_right_to_left_02.pdf.md" ]}
{ "cmds":["docling"], "args": ["--num-threads", "4", "/input/pdfs/right_to_left_03.pdf", "--output", "/output/docling_right_to_left_03.pdf.md" ]}
```


## Step 3 - Launch the fleet

1. Go to https://cloud.ibm.com/containers/serverless/overview
   * Alternatively, use the navigation menu to go to the Code Engine Overview page: **☰ > Containers > Serverless > Get started**.
1. Click **Start creating**.
  ![](images/10-landing.png ':size=600')
1. In the dropdown make sure you select your **project**, e.g. `fleetlab-user1--ce-project`
  ![](images/10-select-project.png ':size=600')
1. Select **Fleet**
1. Set the **Name** of the fleet to something unique like `<your-username>-docling-fleet`. As example `fleetlab-user1-docling-fleet`.
1. In the **Code** section  
   * **Container image reference** - Set the image to `quay.io/docling-project/docling-serve-cpu` which is the public accessible docling image.
   ![](images/20-select-code.png ':size=600')
1. In the **Tasks** section
   * Set the **Tasks from File** option - Upload the *docling_commands.jsonl* from step 2 above. This will define the task with individual commands and arguments. Notice that the *Number of tasks* shows *11*
   * Set the **Task state store** to `fleet-task-store` - The task state store is used for persist the processing of the tasks. In this example a persistent data store has been pre-configured. 
   ![](images/20-select-tasks.png ':size=600')
1. In the **Resources & Scaling** section:
   * **Instance resource** - Select 4 vCPU / 8GB per instance that processes a task.
   * **Scaling Settings** - Set the *Maximum number of concurrent instances* to 11
   ![](images/20-select-scaling.png ':size=600')
1. Review the remaining sections:
   * **Network placement** - You can configure the subnets and zones into which the workers are deployed.
   * **Environment variables** - You can use these settings to inject configuration key-value pairs into your running code.
1. In the **Optional Settings** section expand **Volume mounts** and configure two mount points as follows:
   * For the input bucket:
     * Click on **Add**
     * Select volume type  **Persistent Data Store**
     * Select **fleet-input-store**
     * Set the **Bucket subpath** to `/docling`
     * Set the **Mount path** to `/input`
     * Select **Access permissions** to be `Read-only`
   ![](images/20-add-volume-mounts.png ':size=600')
   * Repeat for the output bucket
     * For the input bucket:
     * Click on **Add**
     * Select volume type  **Persistent Data Store**
     * Select **fleet-output-store**
     * Set the **Bucket subpath** to `/docling`
     * Set the **Mount path** to `/output`
     * Select **Access permissions** to be `Read-write`
   * Review the volume mounts:
   ![](images/20-list-volume-mounts.png ':size=600')
1. Click **Create**.
1. View the list of 11 pending **Tasks** and 3 pending **Workers**
1. After a short duration notice that the **Workers** are switching into **Running** status
   * IBM Cloud Code Engine calculated the capacity requirements of 11 tasks * 4 vCPU/task = 44 vCPU and 88 GB memory.
   * As a result, 3 workers are being provisioned with 32, 8 and 4 vCPU which perfectly match the resource requirements.
   ![](images/20-running-workers.png ':size=600')
1. Switch to the **Tasks** tab and notice that the all tasks are switching into **Running** status
   ![](images/20-running-tasks.png ':size=600')

?> **Congratulations!** You are now running a quite compute intensive fleet that consists of 11 tasks. Code Engine scaled-up the workers and run all 11 instances in parallel. Each instance will mount the input bucket to `/input` and output bucket to `/output` and run the `docling` command with the arguments to convert the PDFs to Markdown. 


## Step 4 - View the results in COS

1. Navigate to https://cloud.ibm.com/objectstorage/overview
1. Expand **Instances**
1. Click on **fleetlab-user1--cos**
1. Click on the **fleetlab-user1-output** bucket to open it's content
   ![](images/20-cos-input-bucket.png ':size=600')
1. Click on the **docling** folder (prefix) 
1. Wait until the first the Markdown object appear. This may take a few minutes. 
1. Do not wait for the remaining documents and move on with the next chapter

⇨ [Let's observe the fleet](30-observability.md)
