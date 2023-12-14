data "confluent_environment" "env" {
  display_name = var.environment
}

# Confluent Cloud cluster 
resource "confluent_kafka_cluster" "cluster" {
  display_name = var.cluster.display_name
  availability = var.cluster.availability
  cloud        = var.cluster.cloud
  region       = var.cluster.region
  dynamic "basic" {
    for_each = upper(var.cluster.type) == "BASIC" ? [1] : []
    content {

    }
  }
  dynamic "standard" {
    for_each = upper(var.cluster.type) == "STANDARD" ? [1] : []
    content {

    }
  }
  dynamic "dedicated" {
    for_each = upper(var.cluster.type) == "DEDICATED" ? [1] : []
    content {
      cku = var.cluster.cku
    }
  }
  environment {
    id = data.confluent_environment.env.id
  }

  dynamic "network" {
    for_each = var.network != "" ? [1] : []
    content {
      id = var.network
    }
  }

  dynamic "byok_key" {
    for_each = var.byok != "" ? [1] : []
    content {
      id = var.byok
    }
  }
}
data "confluent_service_account" "service_account" {
  count       = var.service_account != null ? 1 : 0
  display_name = var.service_account.name
}

resource "confluent_role_binding" "saccount_role" {
  count       = var.service_account != null ? 1 : 0
  principal   = "User:${data.confluent_service_account.service_account[0].id}"
  role_name   = var.service_account.role
  crn_pattern = confluent_kafka_cluster.cluster.rbac_crn
  depends_on = [
    data.confluent_service_account.service_account
  ]
}

 // Kafka Cluster API KEY - Moved to terrraform-confluent-iam module 
 // Generate a Kafka API Key for the service account
 // Error with Dedicated Private Networking - Requires Data Plane access 
resource "confluent_api_key" "service_account_kafka_api_key" {
   count       = var.service_account != null ? 1 : 0
  display_name = "${var.service_account.name}_kafka_api_key"
  description  = "Kafka API Key that is owned by ${var.service_account.name} service account"
  owner {
    id          = data.confluent_service_account.service_account[0].id
    api_version = data.confluent_service_account.service_account[0].api_version
    kind        = data.confluent_service_account.service_account[0].kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.cluster.id
    api_version = confluent_kafka_cluster.cluster.api_version
    kind        = confluent_kafka_cluster.cluster.kind

    environment {
      id = data.confluent_environment.env.id
    }
  }
  depends_on = [
    data.confluent_service_account.service_account
  ]
} 

resource "confluent_kafka_cluster_config" "cluster_config" {
  count = var.service_account != null ? 1 : 0
  kafka_cluster {
    id = confluent_kafka_cluster.cluster.id
  }
  rest_endpoint = confluent_kafka_cluster.cluster.rest_endpoint
  config        = var.cluster.config
  credentials {
    key    = confluent_api_key.service_account_kafka_api_key[0].id
    secret = confluent_api_key.service_account_kafka_api_key[0].secret
  }
}
