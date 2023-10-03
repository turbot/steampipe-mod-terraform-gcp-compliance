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