locals {
  logging_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Logging"
  })
}

benchmark "logging" {
  title       = "Logging"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud Logging resources deviating from security best practices."

  children = [
    control.logging_bucket_retention_policy_enabled
  ]

  tags = merge(local.logging_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "logging_bucket_retention_policy_enabled" {
  title         = "Ensure that retention policies on log buckets are configured using Bucket Lock"
  description   = "Enabling retention policies on log buckets will protect logs stored in cloud storage buckets from being overwritten or accidentally deleted. It is recommended to set up retention policies and configure Bucket Lock on all storage buckets that are used as log sinks."
  sql           = query.logging_bucket_retention_policy_enabled.sql

  tags = merge(local.logging_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "2.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}