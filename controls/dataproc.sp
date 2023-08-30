locals {
  dataproc_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Dataproc"
  })
}

benchmark "dataproc" {
  title       = "Dataproc"
  description = "This benchmark provides a set of controls that detect Terraform GCP Dataproc resources deviating from security best practices."

  children = [
    control.dataproc_cluster_encrypted_with_kms_cmk,
    control.dataproc_cluster_not_publicly_accessible,
    control.dataproc_cluster_public_ip_disabled
  ]

  tags = merge(local.dataproc_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dataproc_cluster_encrypted_with_kms_cmk" {
  title       = "Dataproc cluster should be encrypted with KMS CMK"
  description = "This control checks whether Dataproc cluster is encrypted with KMS CMK."
  query       = query.dataproc_cluster_encrypted_with_kms_cmk

  tags = local.dataproc_compliance_common_tags
}

control "dataproc_cluster_public_ip_disabled" {
  title       = "Dataproc cluster should not have public IP"
  description = "This control checks whether Dataproc cluster has public IP."
  query       = query.dataproc_cluster_public_ip_disabled

  tags = local.dataproc_compliance_common_tags
}

control "dataproc_cluster_not_publicly_accessible" {
  title       = "Dataproc cluster should not be publicly accessible"
  description = "This control checks whether Dataproc cluster is publicly accessible."
  query       = query.dataproc_cluster_not_publicly_accessible

  tags = local.dataproc_compliance_common_tags
}