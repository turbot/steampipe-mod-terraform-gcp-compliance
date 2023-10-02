query "cloudrun_not_publicly_accessible" {
  sql = <<-EOQ
    select
      address as resource,
      case
        when (attributes_std ->> 'member') in ('allUsers', 'allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm'
        else 'ok'
      end as status,
      split_part(address, '.', 2) || case
        when (attributes_std ->> 'member') in ('allUsers', 'allAuthenticatedUsers') or (attributes_std -> 'members') @> '["allUsers"]' or (attributes_std -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_cloud_run_service_iam_member','google_cloud_run_service_iam_binding');
  EOQ
}