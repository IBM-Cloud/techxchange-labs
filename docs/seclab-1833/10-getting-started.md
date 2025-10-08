## Getting Started

### Log in to IBM Cloud and launch SCC+WP

1. Go to https://ibm.biz/txc-1833

2. Enter the `Username` and `Password` provided for the lab

3. Click on the `Sign in` button

![accountLogin](./images/10-account-login.png)

You will be placed on the IBM Cloud dashboard screen

![accountDashboard](./images/10-account-dashboard.png)

4. To view the resources, click the menu icon ![menuLines](../images/10-menu-lines.png) on the top left part of the screen.

Then select “Resource list” to see the list of resources.

![menuResourceList](./images/10-menu-resource-list.png) 

5. In the resources list, in the Security category, find the instance of Security and Compliance Center Workload Protection - "SCC-WP-Instance"

Click the name on the left-hand side of the instance to continue.
   
![resourcesSCCWP](./images/10-resources-sccwp.png)


6. On the SCC+WP instance screen, launch SCC+WP instance UI by clicking the “Open dashboard” button on the top right
 
![launchSCCWP](./images/10-launch-sccwp.png)

You should now see the Home page of SCC WP.

![sccwpHomePage](./images/10-sccwp-homepage.png)

The Home page provides a summarized view of the vulnerabilities and compliance posture of the resources in the account. We will explore these further in the exercises.

How is the vulnerability and compliance information collected? 

Workload Protection agents routinely scan the resources in the IBM Cloud account and feed into the SCC+WP instance. The agents are installed by account administrators. For the purpose of this lab they are already installed.

7. To check the details of the installed agents, click on “Integrations” > “Sysdig Agents” in the bottom left menu.

![sccwpIntegrations](./images/10-menu-sccwp-integrations.png)


8. Check the status of the agents. 

![sccwpIntegrations](./images/10-sccwp-integrations.png)

You should see 5 agents connected and up-to-date. This confirms SCC+WP is configured and collecting data about compliance checks on the resources in the account.
