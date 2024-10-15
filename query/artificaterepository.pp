query "artifact_registry_repository_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'kms_key_name') is null then 'alarm' 
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'kms_key_name') is null then ' not encrypted with KMS CMK' 
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_artifact_registry_repository';
  EOQ
}

query "artifact_registry_repository_not_publicly_accessible" {
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
      type in ('google_artifact_registry_repository_iam_member','google_artifact_registry_repository_iam_binding');
  EOQ
}
