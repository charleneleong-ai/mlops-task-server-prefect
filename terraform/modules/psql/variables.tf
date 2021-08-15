
variable k8s_rg_name {
    type = string
}

variable location {
    default = "Australia East"
    type = string
}

variable vnet_name {
    type = string
}

variable vnet_id {
    type = string
}

# Meta Data
variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
}
