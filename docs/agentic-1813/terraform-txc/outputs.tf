##############################################################################
# Outputs
##############################################################################

output "resource_group_id" {
 value       = module.resource_group.resource_group_id
 description = "The ID of the resource group."
}

output "ce_project_id" {
 value       = module.code_engine_project.id
 description = "The ID of the code engine project."
}


output "output_image" {
 value       = local.output_image
 description = "The URL of the container registry image"
}

output "app_url" {
 value       = module.code_engine_app.endpoint
 description = "The public endpoint to access the deployed loan application."
}
