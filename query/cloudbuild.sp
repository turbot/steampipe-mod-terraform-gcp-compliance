query "cloudbuild_workers_use_private_ip" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'worker_config' ->> 'no_external_ip') = 'true' then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments -> 'worker_config' ->> 'no_external_ip') = 'true' then ' no external IP configured'
        else ' external IP configured'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_cloudbuild_worker_pool';
  EOQ
}