# Terraform module for Confluent Cloud Kafka clusters 

- cluster.availability => SINGLE_ZONE or MULTI_ZONE 
- cluster.cloud => GCP, AWS or AZURE 
- cluster.type => BASIC or STANDARD or DEDICATED
  - for DEDICATED clusters, cluster.cku must be set

`export TF_VAR_confluent_cloud_api_key="<CCLOUD_API_KEY>`  

`export TF_VAR_confluent_cloud_api_secret="<CCLOUD_API_SECRET>`  


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | ~>1.21.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | 1.21.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.service_account_kafka_api_key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_kafka_cluster.cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_cluster) | resource |
| [confluent_kafka_cluster_config.cluster_config](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_cluster_config) | resource |
| [confluent_role_binding.saccount_role](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/role_binding) | resource |
| [confluent_environment.env](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/environment) | data source |
| [confluent_service_account.service_account](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Cluster definition | <pre>object({<br>    display_name = string<br>    availability = string<br>    cloud        = string<br>    region       = string<br>    type         = string<br>    cku          = optional(string)<br>    config       = optional(map(string))<br><br>  })</pre> | n/a | yes |
| <a name="input_confluent_cloud_api_key"></a> [confluent\_cloud\_api\_key](#input\_confluent\_cloud\_api\_key) | Confluent Cloud API KEY. export TF\_VAR\_confluent\_cloud\_api\_key="API\_KEY" | `string` | n/a | yes |
| <a name="input_confluent_cloud_api_secret"></a> [confluent\_cloud\_api\_secret](#input\_confluent\_cloud\_api\_secret) | Confluent Cloud API KEY. export TF\_VAR\_confluent\_cloud\_api\_secret="API\_SECRET" | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Confluent Cloud Environment | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service Account and Role for cluster management. | <pre>object({<br>      name = string<br>      role = string<br>    })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster"></a> [cluster](#output\_cluster) | n/a |
<!-- END_TF_DOCS -->