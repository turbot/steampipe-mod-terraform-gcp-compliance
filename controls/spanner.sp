locals {
  spanner_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Spanner"
  })
}

benchmark "spanner" {
  title       = "Spanner"
  description = "This benchmark provides a set of controls that detect Terraform GCP Spanner workers deviating from security best practices."

  children = [
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