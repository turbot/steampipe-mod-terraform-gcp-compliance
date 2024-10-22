locals {
  dataflow_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/Dataflow"
  })
}

benchmark "dataflow" {
  title       = "Dataflow"
  description = "This benchmark provides a set of controls that detect Terraform GCP Dataflow resources deviating from security best practices."

  children = [
    control.dataflow_encrypted_with_kms_cmk,
    control.dataflow_job_not_publicly_accessible
  ]

  tags = merge(local.dataflow_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "dataflow_encrypted_with_kms_cmk" {
  title       = "Dataflow should be encrypted with KMS CMK"
  description = "This control checks whether Dataflow is encrypted with KMS CMK."
  query       = query.dataflow_encrypted_with_kms_cmk

  tags = local.dataflow_compliance_common_tags
}

control "dataflow_job_not_publicly_accessible" {
  title       = "Dataflow job should not be publicly accessible"
  description = "This control checks whether Dataflow job is publicly accessible."
  query       = query.dataflow_job_not_publicly_accessible

  tags = local.dataflow_compliance_common_tags
}
