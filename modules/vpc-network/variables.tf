variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "network_name" {
  description = "The name of the network being created"
  type        = string
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "subnets" {
  type = list(object({
    subnet_name                      = string
    subnet_ip                        = string
    subnet_region                    = string
    subnet_private_access            = optional(string, "false")
    subnet_private_ipv6_access       = optional(string)
    subnet_flow_logs                 = optional(string, "false")
    subnet_flow_logs_interval        = optional(string, "INTERVAL_5_SEC")
    subnet_flow_logs_sampling        = optional(string, "0.5")
    subnet_flow_logs_metadata        = optional(string, "INCLUDE_ALL_METADATA")
    subnet_flow_logs_filter          = optional(string, "true")
    subnet_flow_logs_metadata_fields = optional(list(string), [])
    description                      = optional(string)
    purpose                          = optional(string)
    role                             = optional(string)
    stack_type                       = optional(string)
    ipv6_access_type                 = optional(string)
  }))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "create_psa" {
  type        = bool
  description = "Enable PSA for the network"
  default     = true
}
