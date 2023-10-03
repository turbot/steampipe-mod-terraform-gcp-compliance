query "pubsub_topic_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_name') is not null then 'ok'
        else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_name') is not null then ' encrypted with KMS CMK'
        else ' not encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_pubsub_topic';
  EOQ
}

query "pubsub_topic_repository_not_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'member') in ('allUsers','allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'member') in ('allUsers','allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_pubsub_topic_iam_member', 'google_pubsub_topic_iam_binding');
  EOQ
}