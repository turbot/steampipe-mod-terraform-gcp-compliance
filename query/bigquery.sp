query "bigquery_table_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'encryption_configuration') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'encryption_configuration') is null then ' not encrypted with customer-managed encryption keys'
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

query "bigquery_dataset_encrypted_with_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'default_encryption_configuration') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'default_encryption_configuration') is null then ' not encrypted with CMK'
        else ' encrypted with CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigquery_dataset';
  EOQ
}

query "bigquery_instance_encrypted_with_kms_cmk" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'cluster' ->> 'kms_key_name') is null then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'cluster' ->> 'kms_key_name') is null then ' not encrypted with KMS CMK'
        else ' encrypted with KMS CMK'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigtable_instance';
  EOQ
}

query "bigquery_table_not_publicly_accessible" {
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
      type in ('google_bigquery_table_iam_binding','google_bigquery_table_iam_member');
  EOQ
}

query "bigquery_dataset_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'access') is null then 'ok'
        when exists(
          select
            1
          from
            jsonb_array_elements(
              case
                when jsonb_typeof(arguments -> 'access') = 'array' then arguments -> 'access'
                else jsonb_build_array(arguments -> 'access')
              end
            ) as access
          where
            (access ->> 'special_group' is not null and access ->> 'special_group' in ('allAuthenticatedUsers', 'allUsers'))
            or
            not(access ?| ARRAY['user_by_email', 'group_by_email', 'domain', 'view', 'routine', 'dataset'])
        ) then 'alarm'
        else 'ok'
      end status,
      name || case
        when (arguments -> 'access') is null then 'ok'
        when exists(
          select
            1
          from
            jsonb_array_elements(arguments -> 'access') as access
          where
            (access ->> 'special_group' is not null and access ->> 'special_group' in ('allAuthenticatedUsers', 'allUsers'))
            or
            not(access ?| ARRAY['user_by_email', 'group_by_email', 'domain', 'view', 'routine', 'dataset'])
        ) then 'alarm'
        else 'ok'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_bigquery_dataset';
  EOQ
}