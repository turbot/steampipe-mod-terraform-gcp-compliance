locals {
  vertex_ai_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/VertexAI"
  })
}

benchmark "vertexai" {
  title       = "Vertex AI"
  description = "This benchmark provides a set of controls that detect Terraform GCP Vertex AI resources deviating from security best practices."

  children = [
    control.vertex_ai_dataset_encrypted_with_cmk,
    control.vertex_ai_notebook_instance_restrict_public_access
  ]

  tags = merge(local.vertex_ai_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "vertex_ai_dataset_encrypted_with_cmk" {
  title       = "Vertex AI datasets should be encrypted with KMS CMK"
  description = "This control checks whether Vertex AI dataset is encrypted with KMS CMK."
  query       = query.vertex_ai_dataset_encrypted_with_cmk

  tags = local.vertex_ai_compliance_common_tags
}

control "vertex_ai_notebook_instance_restrict_public_access" {
  title       = "Vertex AI notebook instances should restrict public access"
  description = "This control checks whether Vertex AI notebook instances are not public."
  query       = query.vertex_ai_notebook_instance_restrict_public_access

  tags = local.vertex_ai_compliance_common_tags
}
