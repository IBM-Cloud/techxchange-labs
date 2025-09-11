# 📋 Prerequisites and IBM Cloud Setup

This lab guides you through designing and automating a secure cloud infrastructure. While the instructions are step-by-step, some background knowledge will help you get the most out of the experience.

## Technical Prerequisites

You'll find this lab most valuable if you have:

-   Basic knowledge of Terraform syntax and commands.
-   Familiarity with navigating the IBM Cloud console.
-   Basic experience with Git and GitHub for version control.

> **Note:** These are not strict requirements. You can complete the lab even as a beginner.

## Lab Environment

### For Instructor-Led Workshops

You will use a web-based IDE for development and a dedicated IBM Cloud account to deploy your infrastructure. Access your credentials at: **[https://ibm.biz/txc25_1818_creds](https://ibm.biz/txc25_1818_creds)**. Your instructor will provide the access passcode.

**Step 1: Access the Web-based IDE**

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

1.  To ensure you can work with both accounts simultaneously, open a **new private or incognito browser window**. Alternatively, you can use a different browser profile.
2.  Log in at **[https://ibm.biz/1818-login](https://ibm.biz/1818-login)** using the second set of credentials. This is your target account where the infrastructure will be provisioned.

> **Important**: Keep both tabs open. You will write code in the IDE (first tab) and view the deployed resources in your target IBM Cloud account (second tab).

### Self-Paced

Ensure you have:

- IBM Cloud account with necessary permissions (Pay-As-You-Go account required)
- Development machine with:
  - [Terraform CLI](https://developer.hashicorp.com/terraform/install)
  - [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started)
  - Make sure you have installed Cloud Object Storage plugin for IBM Cloud CLI by running `ibmcloud plugin install cloud-object-storage`.
  - Text editor such as [Visual Studio Code](https://code.visualstudio.com/docs/setup/setup-overview)
  - (Optional) [Git client](https://github.com/git-guides/install-git)

---

[Next: Understanding the Hub-and-Spoke Architecture](./02-understanding-hub-spoke-fundamentals.md)
