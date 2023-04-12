query "iam_service_account_gcp_managed_key" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then 'alarm'
        else 'ok'
      end status,
      name || case
        when name in (select split_part((arguments ->> 'service_account_id'), '.', 2) from terraform_resource where type = 'google_service_account_key') then ' has user-managed keys'
        else ' does not have user-managed keys'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_service_account';
  EOQ
}
