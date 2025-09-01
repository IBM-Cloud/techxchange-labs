##############################################################################
# Resource Group
##############################################################################
module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.2.1"
  resource_group_name = "txc-2025-resource-group"
}

##############################################################################
# Code Engine Project
##############################################################################
module "code_engine_project" {
  source            = "terraform-ibm-modules/code-engine/ibm//modules/project"
  version           = "4.5.1"
  name              = "txc-2025-ce-project"
  resource_group_id = module.resource_group.resource_group_id
}

##############################################################################
# Code Engine Secret
##############################################################################
module "code_engine_secret" {
  source     = "terraform-ibm-modules/code-engine/ibm//modules/secret"
  version    = "4.5.1"
  name       = "my-registry-secret"
  project_id = module.code_engine_project.id
  format     = "registry"
  data = {
    "server"   = "private.us.icr.io",
    "username" = "iamapikey",
    "password" = var.ibmcloud_api_key,
  }
}

##############################################################################
# Container Registry Namespace
##############################################################################
resource "ibm_cr_namespace" "rg_namespace" {
  name              = "txc-2025-crn"
  resource_group_id = module.resource_group.resource_group_id
}

##############################################################################
# Code Engine Build
##############################################################################
locals {
  output_image = "private.us.icr.io/${resource.ibm_cr_namespace.rg_namespace.name}/ai-agent-for-loan-risk"
}

module "code_engine_build" {
  source                     = "terraform-ibm-modules/code-engine/ibm//modules/build"
  version                    = "4.5.1"
  name                       = "txc-2025-ce-build"
  ibmcloud_api_key           = var.ibmcloud_api_key
  project_id                 = module.code_engine_project.id
  existing_resource_group_id = module.resource_group.resource_group_id
  source_url                 = "https://github.com/IBM/ai-agent-for-loan-risk"
  strategy_type              = "dockerfile"
  output_secret              = module.code_engine_secret.name
  output_image               = local.output_image
}

##############################################################################
# Code Engine Application
##############################################################################
module "code_engine_app" {
  depends_on      = [ module.code_engine_build ]
  source          = "terraform-ibm-modules/code-engine/ibm//modules/app"
  version         = "4.5.1"
  project_id      = module.code_engine_project.id
  name            = "ai-agent-for-loan-risk"
  image_reference = module.code_engine_build.output_image
  image_secret    = module.code_engine_secret.name
  run_env_variables = [{
    type  = "literal"
    name  = "WATSONX_AI_APIKEY"
    value = var.ibmcloud_api_key
    },
    {
      type  = "literal"
      name  = "WATSONX_PROJECT_ID"
      value = var.watsonx_project_id
    }
  ]
}
