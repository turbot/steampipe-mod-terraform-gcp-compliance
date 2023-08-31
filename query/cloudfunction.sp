query "cloudfunction_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'member') = 'allUsers' or (arguments -> 'members') @> '["allUsers"]' then 'alarm'
        else 'ok'
      end as status,
      name || case
        when (arguments ->> 'member') = 'allUsers' or (arguments -> 'members') @> '["allUsers"]' then ' is publicly accessible'
        else ' is not publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type in ('google_cloudfunctions_function_iam_member', 'google_cloudfunctions_function_iam_binding', 'google_cloudfunctions2_function_iam_member', 'google_cloudfunctions2_function_iam_binding');
  EOQ
}