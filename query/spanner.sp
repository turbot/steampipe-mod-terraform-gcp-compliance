query "spanner_database_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
     address as resource,
      case
        when (attributes_std -> 'encryption_config' ->> 'kms_key_name') is null then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'encryption_config' ->> 'kms_key_name') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_spanner_database';
  EOQ
}

query "spanner_database_deletion_protection_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'deletion_protection') is null then 'alarm'
        when (attributes_std -> 'deletion_protection')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'deletion_protection') is null then ' ''deletion_protection'' not defined'
        when (attributes_std -> 'deletion_protection')::boolean then ' deletion protection enabled'
        else ' deletion protection disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_spanner_database';
  EOQ
}

query "spanner_database_drop_protection_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'enable_drop_protection')::boolean then 'ok'
        else 'alarm'
      end status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'enable_drop_protection')::boolean then ' enable drop protection enabled'
        else ' enable drop protection disabled'
      end || '.' as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_spanner_database';
  EOQ
}