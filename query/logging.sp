query "logging_bucket_retention_policy_enabled" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std -> 'retention_policy' ->> 'is_locked')::boolean then 'ok' else 'alarm'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std -> 'retention_policy') is null then ' ''retention_policy'' is not defined'
        when (attributes_std -> 'retention_policy' ->> 'is_locked') is null then ' ''retention_policy.is_locked'' is not defined'
        when (attributes_std -> 'retention_policy' ->> 'is_locked')::boolean then ' has retention policies configured'
        else ' does not have retention policies configured.'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_storage_bucket';
  EOQ
}
