variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key."
  sensitive   = true
}

variable "watsonx_project_id" {
  type        = string
  description = "Watsonx project ID."
}
