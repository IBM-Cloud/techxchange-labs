# Part 4: Environmental Impact improvements

In this part of the lab you will understand the emissions produced by the infrastructure hosting these applications and learn how you can optimize your carbon footprint.

## Launch the carbon calculator to view emissions
1. Navigate to the billing and usage page by selecting manage->billing and usage.
![billing and usage](images/billing-usage.png ':size=400')
1. Select Carbon Calculator from the left menu
![carbon calculator](images/carbon-calc.png ':size=600')

## Note current emissions for Open Shift services in this account
1. Filter to the Kubernetes service (Open Shift is part of the overall Kubernetes service)
![kub filter](images/kub-filter.png ':size=600')
1. Note the emissions per location.  Some locations have lower or no emissions, so migrating your workloads to zero emission data centers is one way to improve your carbon footprint.

## Project future emissions
1. If we resized our clusters (based on the work we did earlier) could we improve our carbon foot print and by how much?  You can use straight ratios for a simple projection (%50 less nodes means %50 less emissions, %50 smaller nodes means %50 less emissions).  Alternatively, scaling up our cluster will corresponding increase emissions.
1. If we moved all workloads from Tokyo to Dallas how would that impact the workload carbon footprint?
