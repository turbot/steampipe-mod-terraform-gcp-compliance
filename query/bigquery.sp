query "bigquery_table_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration') is null then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'encryption_configuration') is null then ' encrypted with Google managed cryptographic keys' 
        else ' encrypted with customer-managed encryption keys'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigquery_table';
  EOQ
}

query "bigquery_dataset_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'access') = 'object' and ((arguments -> 'access' ->> 'special_group') = 'allAuthenticatedUsers') then 'alarm' 
        when jsonb_typeof(arguments -> 'access') = 'array' and ((arguments ->> 'access') like '%allAuthenticatedUsers%') then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when jsonb_typeof(arguments -> 'access') = 'object' and ((arguments -> 'access' ->> 'special_group') = 'allAuthenticatedUsers') then ' is publicly accessible' 
        when jsonb_typeof(arguments -> 'access') = 'array' and ((arguments ->> 'access') like '%allAuthenticatedUsers%') then ' is publicly accessible' 
        else ' is not publicly accessible'
      end || '.' reason      
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigquery_dataset';
  EOQ
}

query "bigquery_dataset_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'default_encryption_configuration') is null then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'default_encryption_configuration') is null then ' not encrypted with CMEK' 
        else ' encrypted with CMEK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigquery_dataset';
  EOQ
}
