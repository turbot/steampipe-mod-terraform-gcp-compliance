locals {
  storage_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Storage"
  })
}

benchmark "storage" {
  title       = "Storage"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud Storage resources deviating from security best practices."

  children = [
    control.storage_bucket_not_publicly_accessible,
    control.storage_bucket_public_access_prevention_enforced,
    control.storage_bucket_uniform_access_enabled,
    control.storage_bucket_versioning_enabled
  ]

  tags = merge(local.storage_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "storage_bucket_not_publicly_accessible" {
  title       = "Ensure that Cloud Storage bucket is not anonymously or publicly accessible"
  description = "It is recommended that IAM policy on a Cloud Storage bucket does not allow anonymous or public access."
  query       = query.storage_bucket_not_publicly_accessible

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "5.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "storage_bucket_uniform_access_enabled" {
  title       = "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
  description = "It is recommended that uniform bucket-level access is enabled on Cloud Storage buckets."
  query       = query.storage_bucket_uniform_access_enabled

  tags = merge(local.storage_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "5.2"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "storage_bucket_public_access_prevention_enforced" {
  title       = "Storage buckets public access prevention should be enforced"
  description = "It is recommended that public access prevention should be enforced for storage buckets."
  query       = query.storage_bucket_public_access_prevention_enforced

  tags = local.storage_compliance_common_tags
}

control "storage_bucket_versioning_enabled" {
  title       = "Storage buckets versioning should be enabled"
  description = "It is recommended that versioning should be enabled for storage buckets."
  query       = query.storage_bucket_versioning_enabled

  tags = local.storage_compliance_common_tags
}