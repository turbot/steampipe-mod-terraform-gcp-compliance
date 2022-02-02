locals {
  storage_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "storage"
  })
}

benchmark "storage" {
  title       = "Cloud Storage"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud Storage resources deviating from security best practices."

  children = [
    control.storage_bucket_not_publicly_accessible,
    control.storage_bucket_uniform_access_enabled
  ]

  tags = local.storage_compliance_common_tags
}

control "storage_bucket_not_publicly_accessible" {
  title         = "Ensure that Cloud Storage bucket is not anonymously or publicly accessible"
  description   = "It is recommended that IAM policy on a Cloud Storage bucket does not allow anonymous or public access."
  sql           = query.storage_bucket_not_publicly_accessible.sql

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "5.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "storage_bucket_uniform_access_enabled" {
  title         = "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
  description   = "It is recommended that uniform bucket-level access is enabled on Cloud Storage buckets."
  sql           = query.storage_bucket_uniform_access_enabled.sql

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "5.2"
    cis_level   = "2"
    cis_type    = "automated"
  })
}
