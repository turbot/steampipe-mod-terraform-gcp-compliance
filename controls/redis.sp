locals {
  redis_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Redis"
  })
}

benchmark "redis" {
  title       = "Redis"
  description = "This benchmark provides a set of controls that detect Terraform GCP Redis resources deviating from security best practices."

  children = [
    control.redis_instance_auth_enabled,
    control.redis_instance_encryption_in_transit_enabled
  ]

  tags = merge(local.redis_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "redis_instance_auth_enabled" {
  title       = "Redis instances should have auth enabled"
  description = "Ensure Redis instance has AUTH enabled. This control is non-compliant if AUTH is disabled for Redis instance."
  query       = query.redis_instance_auth_enabled

  tags = local.redis_compliance_common_tags
}

control "redis_instance_encryption_in_transit_enabled" {
  title       = "Redis instances encryption in transit should be enabled"
  description = "Ensure Redis instance encryption in transit is enabled. This control is non-compliant if encryption in transit is disabled for Redis instance."
  query       = query.redis_instance_encryption_in_transit_enabled

  tags = local.redis_compliance_common_tags
}

