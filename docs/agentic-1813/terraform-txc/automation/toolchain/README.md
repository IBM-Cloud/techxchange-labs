# Prerequisites

Before you can run the script to create the toolchain, you must have the following accesses:

1. **Editor** access to the `Toolchain` service
2. Access to a `Resource group` to create the toolchain in
3. **Editor** access to the `Catalog Management` service and access to at least one private catalog that you want to create your product under from the toolchain

# Creating the toolchain

To create the toolchain, complete the following steps:

1. Log in to the IBM Cloud CLI.
    * Run the command `ibmcloud login`.
    * Select the account that you want to create the toolchain under.
2. Switch into the `toolchain` directory by running a command like `cd automation/toolchain`.
3. Run the `./create-toolchain.sh` command to create an API key, and then create the following:  

    * Toolchain to drive the CI/CD for the deployable architecture
    * GitLab repos to manage the following items:
        * Host the code for this customized deployable architecture
        * Repo for compliance evidence
        * Repo to hold inventory
        * Link to a pipeline repo that holds the `Tekton DevSecOp` pipeline definitions
    * Two delivery pipelines:
        * CI
        * PR

The script uses the content of this folder as the basis for a repository to develop your deployable architecture. If everything runs properly, the script outputs the link to your toolchain in the following format:

```
echo "=================================================="
echo "The created toolchain is located at $toolchain_url"
echo "=================================================="
```

# Configuring your toolchain

To configure your toolchain, complete the following steps:

1. View the GitLab repository that was created by clicking the link under the repositories in the `compliance-iac...` section. 
2. With the default settings of the toolchain, it assumes that you already have an existing private catalog that is named as `my-private-catalog`. To change this setting and update it to a different catalog name that you want the product to be created under, you must complete the following steps: 
    * Navigate to `ci-pipeline`.
    * Select `Environment properties` in the resource navigation section on the left. 
    * Edit the `catalog-name` environment variable and change it to the value of your private catalog.
3. To start a pipeline run to create your initial product in the specified catalog, create a commit in the `Gitlab` repo with a commit message in the proper [sematic release format](https://semantic-release.gitbook.io/semantic-release/#how-does-it-work). Default triggers that pick up these changes and start a pipeline run are already put in place with the initial configuration.
