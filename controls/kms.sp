locals {
  kms_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "kms"
  })
}

benchmark "kms" {
  title       = "KMS"
  description = "This benchmark provides a set of controls that detect Terraform GCP KMS resources deviating from security best practices."

  children = [
    control.cmek_rotation_one_hundred_days,
    control.kms_key_rotated_within_90_day
  ]

  tags = local.kms_compliance_common_tags
}

control "cmek_rotation_one_hundred_days" {
  title         = "Check that CMEK rotation policy is in place and is sufficiently short"
  sql           = query.kms_key_rotated_within_100_day.sql

  tags = merge(local.kms_compliance_common_tags, {
    forseti_security_v226   = "true"
    severity                = "high"
  })
}

control "kms_key_rotated_within_90_day" {
  title         = "Ensure KMS encryption keys are rotated within a period of 90 days"
  description   = "Google Cloud Key Management Service stores cryptographic keys in a hierarchical structure designed for useful and elegant access control management. The format for the rotation schedule depends on the client library that is used. For the gcloud command-line tool, the next rotation time must be in ISO or RFC3339 format, and the rotation period must be in the form INTEGER[UNIT], where units can be one of seconds (s), minutes (m), hours (h) or days (d)."
  sql           = query.kms_key_rotated_within_90_day.sql

  tags = merge(local.kms_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "1.10"
    cis_level   = "1"
    cis_type    = "automated"
  })
}
