locals {
  redisinstance_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/RedisInstance"
  })
}

benchmark "redisinstance" {
  title       = "Redis Instance"
  description = "This benchmark provides a set of controls that detect Terraform GCP Redis Instance resources deviating from security best practices."

  children = [
    control.redis_instance_auth_enabled,
    control.redis_instance_encryption_in_transit_enabled
  ]

  tags = merge(local.redisinstance_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "redis_instance_auth_enabled" {
  title       = "Redis Instances should have auth enabled"
  description = "Ensure Redis Instance has AUTH enabled. This control is non-compliant if AUTH is disabled for Redis Instance."
  query       = query.redis_instance_auth_enabled

  tags = local.redisinstance_compliance_common_tags
}

control "redis_instance_encryption_in_transit_enabled" {
  title       = "Redis Instances encryption in transit should be enabled"
  description = "Ensure Redis Instance encryption in transit is enabled. This control is non-compliant if encryption in transit is disabled for Redis Instance."
  query       = query.redis_instance_encryption_in_transit_enabled

  tags = local.redisinstance_compliance_common_tags
}

