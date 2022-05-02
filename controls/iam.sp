locals {
  iam_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/IAM"
  })
}

benchmark "iam" {
  title       = "IAM"
  description = "This benchmark provides a set of controls that detect Terraform GCP Identity and Access Management(IAM) resources deviating from security best practices."

  children = [
    control.iam_service_account_gcp_managed_key
  ]

  tags = merge(local.iam_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "iam_service_account_gcp_managed_key" {
  title         = "Ensure that there are only GCP-managed service account keys for each service account"
  description   = "User managed service accounts should not have user-managed keys. It is recommended that only GCP-managed service account keys are used for each service account."
  sql           = query.iam_service_account_gcp_managed_key.sql

  tags = merge(local.iam_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "1.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}