
variable k8s_rg_name {
    default = "astronomer-k8s-rg"
}

variable location {
    default = "Australia East"
}

# variable "parent_domain" {
#   description = "pre-existing parent domain in which to create the NS record for the child domain"
#   type        = string
# }

# variable "child_domain_prefix" {
#   description = "child domain prefix (<child_domain_prefix>.<parent_domain>)"
#   type = string
# }
# variable dns_zone_name {
#     default = "astronomer.relevanceai.com"
#     type = string
# }

# variable private_dns_zone_name {
#     default = "test.astronomer.relevanceai.com"
#     type = string
# }
