# Part 5: Determine Success

**Estimated time**: 10 minutes

## Learning Objectives
- Compare your optimization recommendations with expert suggestions
- Evaluate the effectiveness of your resource sizing decisions
- Reflect on the optimization process and lessons learned

In this final part of the lab, we compare the optimizations you made in your merge requests to the optimizations we suggested. This will help you understand how your analysis and decisions align with best practices for Kubernetes resource optimization.

## Compare Your Proposed Resource Limits

1. Navigate to the Git repo where we have stored the cluster configuration for workload limits (in deployment.yaml): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
   ![GitLab repository](images/gitlab.png ':size=600')

2. Click on Merge Requests from the menu at the left, then click on your deployment.yaml merge request. If there are a lot of merge requests, you can click in the search bar to filter the list by author to show only your own merge requests.
   ![Merge requests list](images/merge-requests-list.png ':size=600')

3. Click the "Edit" button near the top right.
   ![Edit merge request button](images/edit-merge-request.png ':size=400')

4. Adjust the merge request so that it is based off the "optimized" branch instead of "main".
   ![Switch branches option](images/switch-branch.png ':size=600')

5. Examine the difference between the suggested values and your values by saving the merge request and then clicking on the changes tab.
   ![Changes tab view](images/changes-tab.png ':size=600')

### Reflection Questions:
- How close were your resource limit recommendations to the suggested values?
- Where did your analysis differ from the expert recommendations?
- What factors might have led to these differences?

## Compare Your Proposed Cluster Changes

1. Navigate to the Git repo where we have stored the cluster configuration for workload limits (in project-config.json): https://us-south.git.cloud.ibm.com/hyndman/Cluster-Config
   ![GitLab repository](images/gitlab.png ':size=600')

2. Click on Merge Requests from the menu at the left, then click on your project-config.json merge request. If there are a lot of merge requests, you can click in the search bar to filter the list by author to show only your own merge requests.
   ![Merge requests list](images/merge-requests-list.png ':size=600')

3. Click the "Edit" button near the top right.
   ![Edit merge request button](images/edit-merge-request.png ':size=600')

4. Adjust the merge request so that it is based off the "optimized" branch instead of "main".
   ![Switch branches option](images/switch-branch.png ':size=600')

5. Examine the difference between the suggested values and your values by saving the merge request and then clicking on the changes tab.
   ![Changes tab view](images/changes-tab.png ':size=600')

### Reflection Questions:
- How did your cluster sizing recommendations compare to the expert suggestions?
- Did you choose to optimize for cost, performance, or a balance of both?
- What additional information might have helped you make better sizing decisions?


# Congratulations!

You have successfully completed the "Reduce costs and optimize resources on IBM Cloud" lab. In this lab, you have:

1. Explored the IBM Cloud environment and understood the deployed resources
2. Analyzed resource usage patterns using IBM Cloud Monitoring
3. Identified optimization opportunities for application resource settings
4. Adjusted cluster size based on workload requirements
5. Examined the environmental impact of your cloud resources
6. Compared your optimization recommendations with expert suggestions

These skills are essential for implementing FinOps and GreenOps practices in your organization, helping you maximize the value of your cloud investments while minimizing both costs and environmental impact.

## Next Steps

Consider applying these same principles to your own cloud environments:
- Regularly monitor resource usage and identify optimization opportunities
- Right-size your workloads based on actual usage patterns
- Consider both cost and environmental factors in your cloud decisions
- Implement a continuous optimization process as part of your cloud governance
