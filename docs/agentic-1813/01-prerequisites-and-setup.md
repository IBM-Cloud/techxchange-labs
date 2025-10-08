# Prerequisites and Setup Requirements

## Technical Prerequisites

While this lab guides you step-by-step without assuming specific prior knowledge, participants will benefit from having:

- Basic knowledge of Terraform syntax and workflows
- Familiarity with containerization and Docker concepts
- Understanding of IBM Cloud services and navigation
- Basic experience with Git and GitHub workflows

> 💡 **Tip:** Don't worry if you're not an expert in these areas - the lab provides detailed instructions and explanations throughout.

## Lab Environment

### For Instructor-Led Workshops


You will use a web-based IDE for development and a dedicated IBM Cloud account to deploy your infrastructure. Access your credentials at: **[https://ibm.biz/txc25_1813_creds](https://ibm.biz/txc25_1813_creds)**. Your instructor will provide the access passcode.

**Step 1: Access the Web-based IDE**

> ⚠️ **Before starting**: Please ensure you don't have any existing active IBM Cloud sessions. Log out at https://cloud.ibm.com/logout if necessary.

1.  Open a browser tab and log in at **[https://ibm.biz/txc-lab-env-login](https://ibm.biz/txc-lab-env-login)** using the first set of credentials provided.
2.  After logging in, you will land on an IBM Cloud dashboard. In the same tab, open the web-based IDE by navigating to **[https://ibm.biz/txc-lab-env](https://ibm.biz/txc-lab-env)**. This is your complete IDE development environment, where you will edit files and run all the necessary commands (like `terraform`).
    > **Note:** After authentication, you may be prompted to **Log in with OpenShift**. Click the button to proceed.
    > ![Login with OpenShift](./images/devenv/login-ide-openshift.png ':size=500')

<details>
<summary><b>A Quick Tour of the Web-based IDE</b></summary>

Once the IDE is loaded, here’s a quick tour to get you started.

1.  **Initial Workspace Load**: The IDE will load the lab's workspace. This may take a moment.
    ![Initial Workspace Load](./images/devenv/ide-initial-workspace-load.png ':size=500')

2.  **Trust Workspace Authors**: For the terminal and other features to work correctly, you must trust the workspace authors. Click **Yes, I trust the authors**.
    ![Trust Workspace Authors](./images/devenv/ide-trust-authors.png ':size=500')

3.  **Welcome Tab**: You can close the "Welcome" tab to get a clearer view of the file explorer.
    ![Close Welcome Tab](./images/devenv/ide-close-welcome.png ':size=500')

4.  **Editor and File Explorer**: The main interface consists of the file explorer on the left, where you can navigate through the lab files, and the editor on the right, where you can view and modify file contents.
    ![Editor and File Explorer](./images/devenv/ide-editor.png ':size=500')

5.  **Open a New Terminal**: To run commands, you'll need a terminal. Click the hamburger menu (the three horizontal lines) at the top left, then select **Terminal** > **New Terminal**.

6.  **Manage Terminals**: You can create multiple terminals and switch between them using the dropdown menu in the terminal panel.
    ![Open a New Terminal](./images/devenv/ide-new-terminal.png ':size=500')
    ![Switch Between Terminals](./images/devenv/ide-switch-between-terminal.png ':size=500')

7.  **Create a New File**: To create a new file, right-click in the file explorer, select **New File**, and give it a name.
    ![Create a New File](./images/devenv/ide-new-file.png ':size=500')

</details>

**Step 2: Log in to Your Target IBM Cloud Account**

Go to the accounts credentials page **[https://ibm.biz/txc25_1813_creds](https://ibm.biz/txc25_1813_creds)** and follow the instructions to access your target deployment account.

After obtaining your credentials, click the login link provided to access the IBM Cloud console. Once logged in, you'll be able to view and manage the resources you'll deploy in the following steps.

> **Important**: Keep both tabs open. You will write code in the IDE (first tab) and view the deployed resources in your target IBM Cloud account (second tab).


