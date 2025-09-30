## Create a SSH Key 

1. Go to **Infrastructure -> Compute -> SSH keys**. 

![sshKeyMenu](./images/20-ssh-key-menu.png)

<p>&nbsp;</p>

The `SSH Keys` page looks like below

![sshListKeys](./images/20-ssh-keys-list.png)

<p>&nbsp;</p>



2. Click on the **Create** button.

* Select the **Geography** (`Europe`) and the **Region** (`Frankfurt(eu-de)`)
* Provide the **Name** for the ssh key (`txc-gpulab-`<**group number**>`-key`). Make sure to use your group number or your user-id to keep the resources unique.
* Select the **Resource Group** (`gpulab-1827-lab`)
* Click on **Create** button to create the key.
* Store the private key that gets downloaded.

![sshCreateMenu](./images/20-ssh-keys-create.png)

3. Check to see the created ssh key

* Go to **Infrastructure -> Compute-> SSH keys**

![sshListCreatedKey](./images/20-ssh-keys-list-2.png)
<p>&nbsp;</p>