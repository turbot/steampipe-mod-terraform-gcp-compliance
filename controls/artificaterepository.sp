locals {
  artificaterepository_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/ArtifactRegistryRepository"
  })
}

benchmark "artificaterepository" {
  title       = "Artifact Registry Repository"
  description = "This benchmark provides a set of controls that detect Terraform GCP Artifact Registry Repository resources deviating from security best practices."

  children = [
    control.artifact_registry_repository_encrypted_with_kms_cmk,
    control.artifact_registry_repository_not_publicly_accessible
  ]

  tags = merge(local.artificaterepository_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "artifact_registry_repository_encrypted_with_kms_cmk" {
  title       = "Artifact Registry Repository should be encrypted with KMS CMK"
  description = "This control checks whether Artifact Registry Repository is encrypted with KMS CMK."
  query       = query.artifact_registry_repository_encrypted_with_kms_cmk

  tags = local.artificaterepository_compliance_common_tags
}

control "artifact_registry_repository_not_publicly_accessible" {
  title       = "Artifact Registry Repository should not be publicly accessible"
  description = "This control checks whether Artifact Registry Repository is not publicly accessible."
  query       = query.artifact_registry_repository_not_publicly_accessible

  tags = local.artificaterepository_compliance_common_tags
}
