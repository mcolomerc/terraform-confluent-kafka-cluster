 

# Confluent Cloud Environment
variable "environment" {
  type = string
}

# Confluent Cloud Service Account  
variable "service_account" {
  description = "Service Account and Role for cluster management."
  type = object({
      name = string
      role = string
    }) 
  default = null
} 

# Cluster definition
variable "cluster" {
  type = object({
    display_name = string
    availability = string
    cloud        = string
    region       = string
    type         = string
    cku          = optional(string)
    config       = optional(map(string))
  })
  validation {
    condition = (
      contains(["SINGLE_ZONE", "MULTI_ZONE"], var.cluster.availability)
      && contains(["GCP", "AWS", "AZURE"], var.cluster.cloud)
      && contains(["BASIC", "STANDARD", "DEDICATED"], var.cluster.type)
      && (var.cluster.type == "DEDICATED" ? var.cluster.type == "DEDICATED" && var.cluster.cku != null : true)
    )
    error_message = <<EOT
- cluster.availability => SINGLE_ZONE or MULTI_ZONE 
- cluster.cloud => GCP, AWS or AZURE 
- cluster.type => BASIC or STANDARD or DEDICATED
- for DEDICATED clusters, cluster.cku must be set
    EOT
  }
}
variable "network" {
  type = string
  description = "Confluent Cloud Network ID"
  default = ""
}

variable "byok" {
  type = string
  description = "Confluent BYOK ID"
  default = ""
}