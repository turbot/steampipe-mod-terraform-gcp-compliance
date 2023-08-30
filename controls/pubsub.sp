locals {
  pubsub_compliance_common_tags = merge(local.terraform_gcp_compliance_common_tags, {
    service = "GCP/PubSub"
  })
}

benchmark "pubsub" {
  title       = "Cloud Run"
  description = "This benchmark provides a set of controls that detect Terraform GCP Pub Sub services deviating from security best practices."

  children = [
    control.pubsub_topic_encrypted_with_kms_cmk,
    control.pubsub_topic_repository_not_publicly_accessible
  ]

  tags = merge(local.pubsub_compliance_common_tags, {
    type = "Benchmark"
  })
}

control "pubsub_topic_encrypted_with_kms_cmk" {
  title       = "PubSub Topic Encrypted with KMS CMK"
  description = "This control checks whether PubSub topics are encrypted with a KMS CMK."
  query       = query.pubsub_topic_encrypted_with_kms_cmk

  tags = local.pubsub_compliance_common_tags
}

control "pubsub_topic_repository_not_publicly_accessible" {
  title       = "PubSub Topic Repository Not Publicly Accessible"
  description = "This control checks whether PubSub topics are not publicly accessible."
  query       = query.pubsub_topic_repository_not_publicly_accessible

  tags = local.pubsub_compliance_common_tags
}