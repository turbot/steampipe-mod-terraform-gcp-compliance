locals {
  kms_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/KMS"
  })
}

benchmark "kms" {
  title       = "KMS"
  description = "This benchmark provides a set of controls that detect Terraform GCP KMS resources deviating from security best practices."

  children = [
    control.kms_key_not_publicly_accessible,
    control.kms_key_prevent_destroy_enabled,
    control.kms_key_rotated_within_90_day,
    control.kms_key_rotated_within_100_day
  ]

  tags = merge(local.kms_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "kms_key_rotated_within_100_day" {
  title       = "Check that CMEK rotation policy is in place and is sufficiently short"
  description = "Google Cloud Key Management Service stores cryptographic keys in a hierarchical structure designed for useful and elegant access control management. The format for the rotation schedule depends on the client library that is used."
  query       = query.kms_key_rotated_within_100_day

  tags = merge(local.kms_compliance_common_tags, {
    forseti_security_v226 = "true"
  })
}

control "kms_key_rotated_within_90_day" {
  title       = "Ensure KMS encryption keys are rotated within a period of 90 days"
  description = "Google Cloud Key Management Service stores cryptographic keys in a hierarchical structure designed for useful and elegant access control management. The format for the rotation schedule depends on the client library that is used. For the gcloud command-line tool, the next rotation time must be in ISO or RFC3339 format, and the rotation period must be in the form INTEGER[UNIT], where units can be one of seconds (s), minutes (m), hours (h) or days (d)."
  query       = query.kms_key_rotated_within_90_day

  tags = merge(local.kms_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "1.10"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "kms_key_not_publicly_accessible" {
  title       = "KMS keys should not be publicly accessible"
  description = "This control checks whether the KMS keys are publicly accessible."
  query       = query.kms_key_not_publicly_accessible

  tags = local.kms_compliance_common_tags
}

control "kms_key_prevent_destroy_enabled" {
  title       = "KMS Crypto keys should have prevent destroy enabled"
  description = "CryptoKeys cannot be deleted from Google Cloud Platform. Destroying a Terraform-managed CryptoKey will remove it from state and delete all CryptoKeyVersions, rendering the key unusable, but will not delete the resource from the project. When Terraform destroys these keys, any data previously encrypted with these keys will be irrecoverable. For this reason, it is strongly recommended that you add lifecycle hooks to the resource to prevent accidental destruction."
  query       = query.kms_key_prevent_destroy_enabled

  tags = local.kms_compliance_common_tags
}