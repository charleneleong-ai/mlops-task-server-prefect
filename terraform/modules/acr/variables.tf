

variable prefix {
  description = "Project Prefix"
}

variable environment {
  type = string
  description = "Environment (dev/stg/prd)"
  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "The environemnt value must be a valid environment - dev, stg, prd."
  }
}

variable rg {
    type = any
}

variable location {
  description = "Azure location"
    default = "Australia East"
}

# Meta Data
variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
}



