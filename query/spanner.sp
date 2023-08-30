query "spanner_database_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_config' ->> 'kms_key_name') is null then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'encryption_config' ->> 'kms_key_name') is null then ' not encrypted with customer-managed encryption keys' 
        else ' encrypted with customer-managed encryption keys'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_spanner_database';
  EOQ
}