locals {
  spanner_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Spanner"
  })
}

benchmark "spanner" {
  title       = "Spanner"
  description = "This benchmark provides a set of controls that detect Terraform GCP Spanner resources deviating from security best practices."

  children = [
    control.spanner_database_deletion_protection_enabled,
    control.spanner_database_drop_protection_enabled,
    control.spanner_database_encrypted_with_kms_cmk
  ]

  tags = merge(local.spanner_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "spanner_database_encrypted_with_kms_cmk" {
  title       = "Spanner databases should be encrypted with a KMS CMK"
  description = "This control checks whether Spanner databases are encrypted with a KMS CMK."
  query       = query.spanner_database_encrypted_with_kms_cmk

  tags = local.spanner_compliance_common_tags
}

control "spanner_database_deletion_protection_enabled" {
  title       = "Spanner databases deletion protection should be enabled"
  description = "This rule ensures that Spanner database has deletion protection enabled."
  query       = query.spanner_database_deletion_protection_enabled

  tags = local.spanner_compliance_common_tags
}

control "spanner_database_drop_protection_enabled" {
  title       = "Spanner databases drop protection should be enabled"
  description = "This rule ensures that Spanner database has drop protection enabled."
  query       = query.spanner_database_drop_protection_enabled

  tags = local.spanner_compliance_common_tags
}