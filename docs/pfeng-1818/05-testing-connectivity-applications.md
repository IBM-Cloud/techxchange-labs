# 🧪 Testing Connectivity and Applications

After deploying your infrastructure, the next critical step is to test it. This ensures that all components are working together as expected, from network connectivity to application deployment.

## Step 1: Get Your Infrastructure Outputs

First, let's retrieve the key information about your newly created infrastructure from the Terraform outputs. You will need these values for the following steps.

1.  **Open your terminal** in the same directory where your `main.tf` file is located.

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
    The private key was created in the project directory using the prefix you defined in the previous lab. Please provide that prefix again to construct the key file path.

    Replace `<YOUR-PREFIX>` with the same prefix you used before (e.g., "jdoe-lab").
    ```bash
    export TF_VAR_prefix="<YOUR-PREFIX>"
    export PRIVATE_KEY_FILE="${TF_VAR_prefix}_ssh_private_key.pem"
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

    > **Note:** For the next steps, you will run commands from *inside* the jumpbox. Keep this terminal open.

## Step 3: Test Connectivity to a Private Workload Server

From the jumpbox, you should be able to connect to the workload servers in the private VPC. This test validates that the **Transit Gateway** is correctly routing traffic between the two VPCs.

1.  **Copy the Private Key to the Jumpbox**:
    The jumpbox needs the private SSH key to connect to the workload server.

    First, open a **new, second terminal window** on your local machine. In this new terminal, you need to re-export the variables for the jumpbox IP and the private key.

    Run these commands from your local machine in the new terminal. Remember to replace `<YOUR-PREFIX>` with the same prefix you used before.
    ```bash
    export JUMPBOX_IP=$(terraform output -raw jumpbox_public_ip)
    export TF_VAR_prefix="<YOUR-PREFIX>"
    export PRIVATE_KEY_FILE="${TF_VAR_prefix}_ssh_private_key.pem"
    ```

    Now, run the following command from the same new terminal to copy the key.
    ```bash
    scp -i $PRIVATE_KEY_FILE $PRIVATE_KEY_FILE root@$JUMPBOX_IP:~/.
    ```

2. **Connect to the Workload Server**:
    From the jumpbox, you can now connect to the private workload server. You will need two pieces of information that are currently in your **first local terminal**: the workload server's private IP and the name of the private key file.

    First, switch to your **first local terminal** (the one where you ran the `terraform output` commands) and run the following commands to display the values. Copy these values to your clipboard.
    ```bash
    echo "Workload IP: $WORKLOAD_IP_1"
    echo "Private Key Filename: $PRIVATE_KEY_FILE"
    ```

    Now, go back to your **jumpbox terminal**. Use the values you just copied to set the environment variables and SSH into the workload server.
    ```bash
    # Paste the IP address and filename you copied from your local terminal
    export WORKLOAD_IP_1="<paste-workload-ip-here>"
    export PRIVATE_KEY_FILE="<paste-key-file-name-here>"

    # Now connect
    chmod 400 $PRIVATE_KEY_FILE
    ssh -i $PRIVATE_KEY_FILE root@$WORKLOAD_IP_1
    ```

    If successful, your prompt will change again to `root@<workload-server-name>`. You have successfully "jumped" from the public internet to the secure, private workload environment.

    > **Note:** For the next step, you will run commands from *inside the workload server*. Keep this connection active.

## Step 4: Deploy and Test the End-to-End Application

Now for the final test. You will deploy a sample Python application on the workload server. This application will read a file from Cloud Object Storage (COS) and display it. This tests the entire chain:

`Internet -> Public LB -> Private LB -> Workload Server -> VPE -> COS`

1. **Copy the Application to the Workload Server**:
    This is a two-step process: first from your local machine to the jumpbox, then from the jumpbox to the workload server.

    First, if you are currently inside the workload server, type `exit` to return to the jumpbox. Your terminal prompt should look like `root@<jumpbox-name>`.

    Now, open your **second local terminal**. From there, copy the `test_app.py` file to the jumpbox's home directory.
    ```bash
    # Run from your second local terminal
    scp -i $PRIVATE_KEY_FILE test_app.py root@$JUMPBOX_IP:~
    ```

    Next, go back to your **jumpbox terminal**. From the jumpbox, copy the file to the workload server.
    ```bash
    # Run from your jumpbox terminal
    scp -i $PRIVATE_KEY_FILE test_app.py root@$WORKLOAD_IP_1:~
    ```

    Finally, SSH back into the workload server from the jumpbox to continue the setup.
    ```bash
    # Run from your jumpbox terminal
    ssh -i $PRIVATE_KEY_FILE root@$WORKLOAD_IP_1
    ```
    Your prompt should now be `root@<workload-server-name>`.

2. **Upload a Test File to COS**:
    From one of your **local machine's terminals**, log in to IBM Cloud.
    ```bash
    ibmcloud login
    ```
    
    Next, you need to configure the Cloud Object Storage CLI plugin with the CRN (Cloud Resource Name) of the service instance created by Terraform. This command searches your entire account for the COS instance matching your prefix.

    ```bash
    export COS_CRN=$(ibmcloud resource search "name:${TF_VAR_prefix}-cos-*" --output json | jq -r '.items[0].crn')
    ibmcloud cos config crn --crn "${COS_CRN}"
    ```

    Now, use the IBM Cloud CLI to upload the `dummy_page.html` file to your COS bucket. Since the bucket name has a random suffix for uniqueness, we'll find it by listing the buckets associated with your prefix.

    First, find your bucket name and export it as a variable.
    ```bash
    export BUCKET_NAME=$(ibmcloud cos buckets --output json | grep '"Name"' | awk -F'"' '{print $4}' | grep "^${TF_VAR_prefix}-data-bucket")
    echo "Found Bucket: $BUCKET_NAME"
    ```
    Then, upload the file.
    ```bash
    ibmcloud cos object-put --bucket $BUCKET_NAME --key "index.html" --body dummy_page.html
    ```

3. **Install Dependencies and Run the App**:
    The final setup step is to run the Python application on the workload server.

    First, go to your **local terminal** and get the credentials needed by the application.
    ```bash
    # Display the values on your local machine and copy them
    terraform output -raw cos_access_key_id
    terraform output -raw cos_secret_access_key
    echo $BUCKET_NAME
    ```

    Now, switch to your **workload server terminal**. Use the values you just copied to set the environment variables. Then, install the Python dependencies and run the application.
    ```bash
    # Paste the values you copied from your local terminal
    export COS_ACCESS_KEY_ID="<paste_access_key_id_here>"
    export COS_SECRET_ACCESS_KEY="<paste_secret_access_key_here>"
    export COS_BUCKET_NAME="<paste_bucket_name_here>"

    # Run the application in the background
    nohup python3 test_app.py > app.log 2>&1 &
    ```
    
    The application will start and listen on port 8080. You can check its status with `tail -f app.log`.

## Step 5: Verify Public Access

The final step is to access the application from the public internet through the load balancer.

1. **Access the Application**:
    Open a web browser or use `curl` from your **local machine's terminal**. First, ensure the load balancer's hostname is set in your current terminal session.

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
