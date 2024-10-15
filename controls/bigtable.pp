locals {
  bigtable_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Bigtable"
  })
}

benchmark "bigtable" {
  title       = "Bigtable"
  description = "This benchmark provides a set of controls that detect Terraform GCP Bigtable resources deviating from security best practices."

  children = [
    control.bigtable_instance_deletion_protection_enabled,
    control.bigtable_instance_encrypted_with_kms_cmk
  ]

  tags = merge(local.bigtable_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "bigtable_instance_deletion_protection_enabled" {
  title       = "Bigtable Instance deletion protection should be enabled"
  description = "This rule ensures that Big Table Instance has deletion protection enabled."
  query       = query.bigtable_instance_deletion_protection_enabled

  tags = local.bigtable_compliance_common_tags
}

control "bigtable_instance_encrypted_with_kms_cmk" {
  title       = "Big Query Instance should be encrypted with KMS CMK"
  description = "This control checks whether the Big Query Instance is encrypted with KMS CMK."
  query       = query.bigtable_instance_encrypted_with_kms_cmk

  tags = local.bigquery_compliance_common_tags
}
