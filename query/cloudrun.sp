query "cloudrun_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'member') in ('allUsers', 'allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'member') in ('allUsers', 'allAuthenticatedUsers') or (arguments -> 'members') @> '["allUsers"]' or (arguments -> 'members') @> '["allAuthenticatedUsers"]' then ' is publicly accessible'
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