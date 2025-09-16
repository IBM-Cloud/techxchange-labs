# Part 4: Environmental Impact Improvements

**Estimated time**: 10-15 minutes

## Learning Objectives
- Understand the carbon emissions produced by cloud infrastructure
- Analyze emissions by location and service type
- Project the environmental impact of your optimization changes
- Explore strategies for reducing your carbon footprint

In this part of the lab, you will understand the emissions produced by the infrastructure hosting these applications and learn how you can optimize your carbon footprint. This represents the "GreenOps" aspect of cloud optimization, where environmental sustainability becomes a factor in your infrastructure decisions alongside cost and performance.

## Launch the Carbon Calculator to View Emissions

1. Navigate to the billing and usage page by selecting Manage → Billing and Usage.
   ![Billing and usage navigation](images/billing-usage.png ':size=400')

2. Select Carbon Calculator from the left menu.
   ![Carbon calculator option](images/carbon-calc.png ':size=600')

## Analyze Current Emissions for OpenShift Services

1. Filter to the Kubernetes service (OpenShift is part of the overall Kubernetes service).
   ![Kubernetes filter](images/kub-filter.png ':size=600')

2. Note the emissions per location. Some locations have lower or no emissions, so migrating your workloads to zero-emission data centers is one way to improve your carbon footprint.

> **Key Insight**: IBM Cloud data centers have varying carbon footprints based on their local energy sources. Data centers powered by renewable energy or in regions with cleaner energy grids will show lower emissions.

## Project Future Emissions

Now that you've analyzed the current emissions and planned optimization changes, let's project the environmental impact of those changes:

1. Consider how resizing our clusters (based on the work we did earlier) could improve our carbon footprint and by how much.
   - You can use straight ratios for a simple projection:
     - 50% fewer nodes means approximately 50% less emissions
     - 50% smaller nodes means approximately 50% less emissions
   - Alternatively, scaling up our cluster will correspondingly increase emissions

2. Analyze the impact of geographic location on emissions:
   - If we moved all workloads from Tokyo to Dallas, how would that impact the workload carbon footprint?
   - Which regions show the lowest carbon emissions in the calculator?
   - What would be the trade-off between latency and carbon footprint when selecting regions?

3. Document your findings and recommendations for reducing the carbon footprint of this workload.

## Summary

In this section, you've:
- Examined the carbon emissions of your cloud infrastructure
- Analyzed how different regions impact your environmental footprint
- Projected the environmental benefits of your optimization changes
- Considered strategies for further reducing emissions

These insights demonstrate how FinOps (cost optimization) and GreenOps (environmental optimization) can work together to create more sustainable and efficient cloud deployments. In the next section, you'll compare your optimization recommendations with expert suggestions.
