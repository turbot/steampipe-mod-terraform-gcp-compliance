query "pubsub_topic_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'kms_key_name') is not null then 'ok' 
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'kms_key_name') is not null then ' encrypted with kms cmk' 
        else ' not encrypted with kms cmk'
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
      type || ' ' || name as resource,
      case
        when (arguments ->> 'member') in ('allUsers','allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'member') in ('allUsers','allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason      
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_pubsub_topic_iam_member','google_pubsub_topic_iam_binding');
  EOQ
}