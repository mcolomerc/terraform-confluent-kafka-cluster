# Configure the Confluent Cloud Provider
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~>1.21.0"
    }
  }
  experiments = [module_variable_optional_attrs]
} 

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}