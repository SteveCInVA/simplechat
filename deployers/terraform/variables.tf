
variable "global_which_azure_platform" {
  description = "Set to 'AzureUSGovernment' for Azure Government, 'AzureCloud' for Azure Commercial."
  type        = string
  default     = "AzureUSGovernment" # Default from script
  validation {
    condition     = contains(["AzureUSGovernment", "AzureCloud"], var.global_which_azure_platform)
    error_message = "Invalid Azure platform. Must be 'AzureUSGovernment' or 'AzureCloud'."
  }
}

variable "param_subscription_id" {
  description = "Your Azure Subscription ID."
  type        = string
}

variable "param_tenant_id" {
  description = "Your Azure AD Tenant ID."
  type        = string
}

variable "param_location" {
  description = "Primary Azure Government region for deployments (e.g., usgovvirginia, usgovarizona, usgovtexas)."
  type        = string
}

variable "param_resource_owner_id" {
  description = "Used for tagging resources (e.g., Tom Jones)."
  type        = string
}

variable "param_resource_owner_email_id" {
  description = "Used for tagging resources (e.g., somebody@somebody.onmicrosoft.us)."
  type        = string
}


variable "param_environment" {
  description = "Environment identifier (e.g., dev, test, prod, uat)."
  type        = string
}

variable "param_base_name" {
  description = "A short base name for your organization or project (e.g., contoso1, projectx2)."
  type        = string
}

variable "acr_name" {
  description = "Azure Container Registry name (must be globally unique, lowercase alphanumeric)."
  type        = string
}

variable "acr_resource_group_name" {
  description = "Azure Container Registry resource group name."
  type        = string
}

variable "image_name" {
  description = "Container image name (e.g., simple-chat:2025-05-15_7)."
  type        = string
}

variable "param_use_existing_openai_instance" {
  description = "Set to true to use an existing Azure OpenAI instance."
  type        = bool
}

variable "param_existing_azure_openai_resource_name" {
  description = "Existing Azure OpenAI resource name."
  type        = string
}

variable "param_existing_azure_openai_resource_group_name" {
  description = "Existing Azure OpenAI resource group name."
  type        = string
}

variable "param_create_entra_security_groups" {
  description = "Set to true to create Entra ID security groups."
  type        = bool
  default     = true # Default from script
}

# ACR Credentials (assumed to be available for Terraform)
variable "acr_username" {
  description = "Username for the Azure Container Registry."
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "Password for the Azure Container Registry."
  type        = string
  sensitive   = true
}
