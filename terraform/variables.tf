

variable prefix {
  description = "Project Prefix"
}

variable location {
  description = "Azure location"
    default = "Australia East"
}

variable rg_name {
  description = "Resource Group Name"
}


variable environment {
  type = string
  description = "Environment (dev/stg/prd)"
  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "The environmenet value must be a valid environment - dev, stg, prd."
  }
}

# Meta Data
variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
}
