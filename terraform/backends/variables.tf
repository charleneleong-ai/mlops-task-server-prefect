# company
variable "company" {
  type        = string
  description = "This variable defines the name of the company"
  default     = "relevanceai"
}


variable "backendrg" {
  type        = string
  description = "This variable name of the backend resource group"
  default     = "charlene"
}

# environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
  default     = "dev"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "australiaeast"
}