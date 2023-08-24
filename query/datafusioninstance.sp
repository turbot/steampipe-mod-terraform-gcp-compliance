query "datafusioninstance_not_publicly_accessible" {
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

query "datafusioninstance_stackdriver_logging_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_stackdriver_logging')::boolean then 'ok' 
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'enable_stackdriver_logging')::boolean then ' has Stackdriver logging enabled' 
        else ' does not have Stackdriver logging enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_data_fusion_instance';
  EOQ
}

query "datafusioninstance_stackdriver_monitoring_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments ->> 'enable_stackdriver_monitoring')::boolean then 'ok' 
        else 'alarm'
      end as status,
      name || case
        when (arguments ->> 'enable_stackdriver_monitoring')::boolean then ' has Stackdriver monitoring enabled' 
        else ' does not have Stackdriver monitoring enabled'
      end || '.' reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_data_fusion_instance';
  EOQ
}