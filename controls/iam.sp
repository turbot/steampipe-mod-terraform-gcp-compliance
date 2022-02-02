locals {
  iam_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "iam"
  })
}

benchmark "iam" {
  title       = "IAM"
  description = "This benchmark provides a set of controls that detect Terraform GCP Identity and Access Management(IAM) resources deviating from security best practices."

  children = [
    control.iam_service_account_gcp_managed_key
  ]

  tags = local.iam_compliance_common_tags
}

control "iam_service_account_gcp_managed_key" {
  title         = "Ensure that there are only GCP-managed service account keys for each service account"
  description   = "User managed service accounts should not have user-managed keys."
  sql           = query.iam_service_account_gcp_managed_key.sql

  tags = merge(local.iam_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "1.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}