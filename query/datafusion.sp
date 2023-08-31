query "datafusion_instance_not_publicly_accessible" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'private_instance')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'private_instance')::boolean then ' is not publicly accessible'
        else ' is publicly accessible'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_data_fusion_instance';
  EOQ
}

query "datafusion_instance_stackdriver_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_stackdriver_logging')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'enable_stackdriver_logging')::boolean then ' has stackdriver logging enabled'
        else ' has stackdriver logging disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_data_fusion_instance';
  EOQ
}

query "datafusion_instance_stackdriver_monitoring_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_stackdriver_monitoring')::boolean then 'ok'
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'enable_stackdriver_monitoring')::boolean then ' has stackdriver monitoring enabled'
        else ' has stackdriver monitoring disabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_data_fusion_instance';
  EOQ
}
