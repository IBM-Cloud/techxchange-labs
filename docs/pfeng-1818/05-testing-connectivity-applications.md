# 🧪 Testing Connectivity and Applications

After deploying your infrastructure, the next critical step is to test it. This ensures that all components are working together as expected, from network connectivity to application deployment.

## Step 1: Get Your Infrastructure Outputs

First, let's retrieve the key information about your newly created infrastructure from the Terraform outputs. You will need these values for the following steps.

1.  **Open a new terminal**. We'll refer to this as **Terminal 1 (Local)**.

> In your development environment, you can open a terminal by clicking on the hamburger menu in the top left corner and selecting **Terminal > New Terminal**.

2.  **Get the Jumpbox Public IP**:

    ```bash
    export JUMPBOX_IP=$(terraform output -raw jumpbox_public_ip)
    echo "Jumpbox IP: $JUMPBOX_IP"
    ```

3.  **Get a Workload Server Private IP**:
    We'll just use the first one for our tests.

    ```bash
    export WORKLOAD_IP_1=$(terraform output -json workload_server_private_ips | jq -r '.[0]')
    echo "Workload Server 1 IP: $WORKLOAD_IP_1"
    ```

4.  **Get the Public Load Balancer Hostname**:

    ```bash
    export LB_HOSTNAME=$(terraform output -raw public_load_balancer_hostname)
    echo "Public Load Balancer: $LB_HOSTNAME"
    ```

5.  **Set the Private Key File Name**:
    The private key was created in the project directory using the prefix you defined in the previous lab.
    
    ```bash
    export PRIVATE_KEY_FILE=$(terraform output -raw ssh_private_key_file_name)
    echo "Private Key File: $PRIVATE_KEY_FILE"
    ```

## Step 2: Test Connectivity to the Jumpbox

The jumpbox is your secure gateway to the private environment. Let's connect to it.

1.  **SSH into the Jumpbox**:
    Use the IP address and the private key file you retrieved.

    ```bash
    ssh -i $PRIVATE_KEY_FILE root@$JUMPBOX_IP
    ```

When prompted to continue connecting, type `yes`. If the connection is successful, your terminal prompt will change to `root@<jumpbox-name>`. You are now inside the jumpbox.

> **Terminal Management:** This terminal window (**Terminal 1**) is now connected to your jumpbox. We'll refer to the session inside this window as the **Jumpbox Session**. For the next steps, you will open a new local terminal.

## Step 3: Test Connectivity to a Private Workload Server

From the jumpbox, you should be able to connect to the workload servers in the private VPC. This test validates that the **Transit Gateway** is correctly routing traffic between the two VPCs. It also implicitly verifies that the **Network ACLs** and **Security Groups** on both the jumpbox and the workload server are configured to allow SSH traffic.

1. **Copy the Private Key to the Jumpbox**:
    To connect from the jumpbox to the workload server, the jumpbox needs the private SSH key. Because you are connecting *through* the jumpbox, it acts as an intermediary and needs the key to authenticate to the workload server on your behalf. You will copy this key from your local machine to the jumpbox.

    First, open a **new, second terminal window** on your local machine. We'll call this **Terminal 2 (Local)**. Navigate to the project directory. In this new terminal, you need to re-export the variables for the jumpbox IP and the private key.

    Run these commands from **Terminal 2 (Local)**.
    
    ```bash
    export JUMPBOX_IP=$(terraform output -raw jumpbox_public_ip)
    export PRIVATE_KEY_FILE=$(terraform output -raw ssh_private_key_file_name)
    ```

    Now, run the following command from **Terminal 2 (Local)** to copy the key.
    ```bash
    scp -i $PRIVATE_KEY_FILE $PRIVATE_KEY_FILE root@$JUMPBOX_IP:~/.
    ```

2. **Connect to the Workload Server**:
    From the jumpbox, you can now connect to the private workload server. You will need the workload server's private IP and the name of the private key file. You can retrieve these from your second local terminal.

    First, switch to **Terminal 2 (Local)**. Run the following commands to get the required values. Copy the output to your clipboard.
    ```bash
    export WORKLOAD_IP_1=$(terraform output -json workload_server_private_ips | jq -r '.[0]')
    echo "Workload IP: $WORKLOAD_IP_1"
    echo "Private Key Filename: $PRIVATE_KEY_FILE"
    ```

    Now, go back to your **Jumpbox Session** in **Terminal 1**. Use the values you just copied to set the environment variables and SSH into the workload server.
    ```bash
    export WORKLOAD_IP_1="<paste-workload-ip-here>"
    export PRIVATE_KEY_FILE="<paste-key-file-name-here>"
    ```
    
    Now connect to the **workload server** from the **Jumpbox Session**.
    ```bash
    chmod 400 $PRIVATE_KEY_FILE
    ssh -i $PRIVATE_KEY_FILE root@$WORKLOAD_IP_1
    ```

   When prompted to continue connecting, type `yes`. If successful, your prompt will change again to `root@<workload-server-name>`. You have successfully "jumped" from the public internet to the secure, private workload environment.

    > **Terminal Management:** Your **Terminal 1** window is now connected to your workload server. We'll refer to this as the **Workload Session**. Keep this connection active.

## Step 4: Deploy and Test the End-to-End Application

Now for the final test. You will deploy a sample Python application on the workload server. This application will read a file from Cloud Object Storage (COS) and display it. This tests the entire chain:

`Internet -> Public LB -> Private LB -> Workload Server -> VPE -> COS`

1. **Download some additional files in your Development workspace (local terminal)**:
    1. Download the sample Python application file 
       ```bash
       wget https://raw.githubusercontent.com/IBM/deployable-architecture-iac-lab-materials/refs/heads/main/test_app.py
       ```
    2. Download the dummy HTML page
       ```bash
       wget https://raw.githubusercontent.com/IBM/deployable-architecture-iac-lab-materials/refs/heads/main/dummy_page.html
       ```

2. **Copy the Application to the Workload Server**:
    This is a two-step process: first from your local machine to the jumpbox, then from the jumpbox to the workload server.

    First, if you are currently in the **Workload Session** (**Terminal 1**), type `exit` to return to the **Jumpbox Session**. Your terminal prompt should look like `root@<jumpbox-name>`.

    Now, switch to **Terminal 2 (Local)**. From there, copy the `test_app.py` file to the jumpbox's home directory.
    ```bash
    scp -i $PRIVATE_KEY_FILE test_app.py root@$JUMPBOX_IP:~
    ```

    Next, go back to the **Jumpbox Session** in **Terminal 1**. From the jumpbox, copy the file to the workload server.
    ```bash
    scp -i $PRIVATE_KEY_FILE test_app.py root@$WORKLOAD_IP_1:~
    ```

    Finally, SSH back into the workload server from the jumpbox to continue the setup.
    ```bash
    ssh -i $PRIVATE_KEY_FILE root@$WORKLOAD_IP_1
    ```
    Your prompt should now be `root@<workload-server-name>`, and you are back in the **Workload Session** in **Terminal 1**.

3. **Upload a Test File to COS**:
    From **Terminal 2 (Local)**, log in to IBM Cloud.
    ```bash
    ibmcloud login --sso
    ```
    > **Note**: If you have access multiple IBM cloud accounts, make sure to select the account where your resources are deployed. 
    
    Next, you need to configure the Cloud Object Storage CLI plugin with the CRN (Cloud Resource Name) of the service instance created by Terraform.

    ```bash
    export COS_CRN=$(terraform output -raw cos_instance_crn)
    ibmcloud cos config crn --crn "${COS_CRN}"
    ```

    Now, use the IBM Cloud CLI to upload the `dummy_page.html` file to your COS bucket.

    Export your bucket name as a variable and upload the file.
    ```bash
    export BUCKET_NAME=$(terraform output -raw bucket_name)
    ibmcloud cos object-put --bucket $BUCKET_NAME --key "index.html" --body dummy_page.html
    ```

4. **Install Dependencies and Run the App**:
    The final setup step is to run the Python application on the workload server.

    First, go to **Terminal 2 (Local)** and get the credentials needed by the application.
    ```bash
    # Display the values on your local machine and copy them
    terraform output -json cos_access_key_id
    terraform output -json cos_secret_access_key
    terraform output workload_vpe_ips_1
    echo $BUCKET_NAME
    ```

    Now, switch to the **Workload Session** in **Terminal 1**. Use the values you just copied to set the environment variables. Then, install the Python dependencies and run the application.
    ```bash
    # Paste the values you copied from your local terminal
    export COS_ACCESS_KEY_ID="<paste_access_key_id_here>"
    export COS_SECRET_ACCESS_KEY="<paste_secret_access_key_here>"
    export VPE_ENDPOINT="<paste_workload_vpe_ips_1>"
    export COS_BUCKET_NAME="<paste_bucket_name_here>"

    # Run the application in the background
    nohup python3 test_app.py > app.log 2>&1 &
    ```
    
    The application will start and listen on port 8080. You can check its status with `tail -f app.log`.

## Step 5: Verify Public Access

The final step is to access the application from the public internet through the load balancer.

1. **Access the Application**:
    Open a web browser or use `curl` from **Terminal 1 (Local)**. First, ensure the load balancer's hostname is set in your current terminal session.

    ```bash
    export LB_HOSTNAME=$(terraform output -raw public_load_balancer_hostname)
    curl http://$LB_HOSTNAME
    ```

2. **Check the Result**:
    You should see the content of the `dummy_page.html` file:

    ```html
    <h1>It works!</h1>
    <p>This page was served from a private VSI, retrieved from Cloud Object Storage via a VPE.</p>
    ```

**Congratulations!** You have successfully tested the entire hub-and-spoke infrastructure. You've verified secure access, inter-VPC connectivity, and the full application data path.

---

[Next: Packaging as a Deployable Architecture](./06-packaging-as-deployable-architecture.md)
