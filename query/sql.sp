query "sql_instance_postgresql_log_statement_stats_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_statement_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_statement_stats'
        then ' ''log_statement_stats'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_statement_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''log_statement_stats'' database flag set to ''off'''
        else ' ''log_statement_stats'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_cross_db_ownership_chaining_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name' = 'cross db ownership chaining') and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'cross db ownership chaining'
        then ' ''cross db ownership chaining'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'cross db ownership chaining' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''cross db ownership chaining'' database flag set to ''off'''
        else ' ''cross db ownership chaining'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_connections_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_connections' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_connections'
        then ' ''log_connections'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_connections' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_connections'' database flag set to ''on'''
        else ' ''log_connections'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_parser_stats_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_parser_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_parser_stats'
        then ' ''log_parser_stats'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_parser_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''log_parser_stats'' database flag set to ''off'''
        else ' ''log_parser_stats'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_user_options_database_flag_not_configured" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'user options'
        then 'alarm'
        else 'ok'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'user options'
        then ' ''user options'' database flag set'
        else ' ''user options'' database flag not set'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_external_scripts_enabled_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'external scripts enabled' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'external scripts enabled'
        then ' ''external scripts enabled'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'external scripts enabled' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''external scripts enabled'' database flag set to ''off'''
        else ' ''external scripts enabled'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_hostname_database_flag_configured" {
  sql = <<-EOQ
    select
  type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_hostname' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_hostname'
        then ' ''log_hostname'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_hostname' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_hostname'' database flag set to ''on'''
        else ' ''log_hostname'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_mysql_skip_show_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'MYSQL%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'skip_show_database' and 
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'MYSQL%'
        then ' not a MySQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'skip_show_database'
        then ' ''skip_show_database'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'skip_show_database' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''skip_show_database'' database flag set to ''on'''
        else ' ''skip_show_database'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_3625_trace_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = '3625' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> '3625'
        then ' ''3625'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = '3625' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''3625'' database flag set to ''off'''
        else ' ''3625'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_temp_files_database_flag_0" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_temp_files' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = '0'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_temp_files'
        then ' ''log_temp_files'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_temp_files' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = '0'
        then ' ''log_temp_files'' database flag set to ''0'''
        else ' ''log_temp_files'' database flag not set to ''0'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_remote_access_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'remote access' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'remote access'
        then ' ''remote access'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'remote access' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''remote access'' database flag set to ''off'''
        else ' ''remote access'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_planner_stats_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_planner_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_planner_stats'
        then ' ''log_planner_stats'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_planner_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''log_planner_stats'' database flag set to ''off'''
        else ' ''log_planner_stats'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_require_ssl_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'settings') is null then ' ''settings'' is not defined'
        when (arguments -> 'settings' -> 'ip_configuration') is null then ' ''settings.ip_configuration'' is not defined'
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl') is null
        then ' ''settings.ip_configuration.require_ssl'' is not defined'
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl')::boolean then ' enforces SSL connections'
        else ' does not enforce SSL connections'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_checkpoints_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_checkpoints' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_checkpoints'
        then ' ''log_checkpoints'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_checkpoints' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_checkpoints'' database flag set to ''on'''
        else ' ''log_checkpoints'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_disconnections_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_disconnections' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_disconnections'
        then ' ''log_disconnections'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_disconnections' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_disconnections'' database flag set to ''on'''
        else ' ''log_disconnections'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_executor_stats_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_executor_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_executor_stats'
        then ' ''log_executor_stats'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_executor_stats' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''log_executor_stats'' database flag set to ''off'''
        else ' ''log_executor_stats'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_min_duration_statement_database_flag_disabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_duration_statement' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = '-1'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_min_duration_statement'
        then ' ''log_min_duration_statement'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_duration_statement' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = '-1'
        then ' ''log_min_duration_statement'' database flag set to disabled'
        else ' ''log_min_duration_statement'' database flag set to enabled'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_duration_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_duration' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_duration'
        then ' ''log_duration'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_duration' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_duration'' database flag set to ''on'''
        else ' ''log_duration'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_sql_contained_database_authentication_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'SQLSERVER%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'contained database authentication' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'SQLSERVER%'
        then ' not a SQL Server database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'contained database authentication'
        then ' ''contained database authentication'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'contained database authentication' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''contained database authentication'' database flag set to ''off'''
        else ' ''contained database authentication'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_log_lock_waits_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'POSTGRES%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_lock_waits' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'POSTGRES%'
        then ' not a PostgreSQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'log_lock_waits'
        then ' ''log_lock_waits'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_lock_waits' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on'
        then ' ''log_lock_waits'' database flag set to ''on'''
        else ' ''log_lock_waits'' database flag set to ''off'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_mysql_local_infile_database_flag_off" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when coalesce(trim((arguments ->> 'database_version')), '') = '' then 'alarm'
        when (arguments ->> 'database_version') not like 'MYSQL%' then 'skip'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'local_infile' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then 'ok'
        else 'alarm'
      end as status,
      name || case
        when coalesce(trim((arguments ->> 'database_version')), '') = ''
        then ' ''database_version'' is not defined'
        when (arguments ->> 'database_version') not like 'MYSQL%'
        then ' not a MySQL database'
        when (arguments -> 'settings') is null then ' ''settings'' is not defined' 
        when (arguments -> 'settings' -> 'database_flags') is null then ' ''settings.database_flags'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'name')), '') = ''
        then ' ''settings.database_flags.name'' is not defined'
        when coalesce(trim((arguments -> 'settings' -> 'database_flags' ->> 'value')), '') = ''
        then ' ''settings.database_flags.value'' is not defined'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') <> 'local_infile'
        then ' ''local_infile'' database flag not set'
        when (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'local_infile' and
          (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off'
        then ' ''local_infile'' database flag set to ''off'''
        else ' ''local_infile'' database flag set to ''on'''
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_automated_backups_enabled" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then 'ok' else 'alarm'
      end as status,
      name || case
        when (arguments -> 'settings') is null then ' ''settings'' is not defined'
        when (arguments -> 'settings' -> 'backup_configuration') is null then ' ''settings.backup_configuration'' is not defined'
        when (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled') is null
        then ' ''settings.backup_configuration.enabled'' is not defined'
        when (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then ' automatic backups configured'
        else ' automatic backups not configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance';
  EOQ
}

query "sql_instance_postgresql_pgaudit_database_flag_on" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'cloudsql.enable_pgaudit' and (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on' then 'ok' 
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'cloudsql.enable_pgaudit' and (flags ->> 'value') = 'on') then 'ok'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'cloudsql.enable_pgaudit' and (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off' then 'alarm' 
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'cloudsql.enable_pgaudit' and (flags ->> 'value') = 'off') then 'alarm'
        else 'alarm'
      end as status,
      name || case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'cloudsql.enable_pgaudit' and (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'on' then ' pgaudit database flag set to on'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'cloudsql.enable_pgaudit' and (flags ->> 'value') = 'on') then ' pgaudit database flag set to on'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'cloudsql.enable_pgaudit' and (arguments -> 'settings' -> 'database_flags' ->> 'value') = 'off' then ' pgaudit database flag set to off'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'cloudsql.enable_pgaudit' and (flags ->> 'value') = 'off') then ' pgaudit database flag set to off'
        else ' pgaudit database flag not set'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance' and
      (arguments ->> 'database_version') like 'POSTGRES%';
  EOQ
}

query "sql_instance_postgresql_log_min_error_statement_flag_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_error_statement' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('debug5', 'debug4', 'debug3', 'debug2', 'debug1', 'info', 'notice', 'warning', 'error') then 'ok' 
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_min_error_statement' and (flags ->> 'value')  in ('debug5', 'debug4', 'debug3', 'debug2', 'debug1', 'info', 'notice', 'warning', 'error')) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_error_statement' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('debug5', 'debug4', 'debug3', 'debug2', 'debug1', 'info', 'notice', 'warning', 'error') then ' log min error statement database flag value set to debug5, debug4, debug3, debug2, debug1, info, notice, warning, error'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_min_error_statement' and (flags ->> 'value') in ('debug5', 'debug4', 'debug3', 'debug2', 'debug1', 'info', 'notice', 'warning', 'error')) then ' log min error statement database flag value set to debug5, debug4, debug3, debug2, debug1, info, notice, warning, error'
        else ' log min error statement database flag value not set'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance' and
      (arguments ->> 'database_version') like 'POSTGRES%';
  EOQ
}

query "sql_instance_postgresql_log_min_messages_flag_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_messages' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('fatal', 'panic', 'log', 'error', 'warning', 'notice', 'info', 'debug1', 'debug2', 'debug3', 'debug4', 'debug5') then 'ok' 
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_min_messages' and (flags ->> 'value') in ('fatal', 'panic', 'log', 'error', 'warning', 'notice', 'info', 'debug1', 'debug2', 'debug3', 'debug4', 'debug5')) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_min_messages' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('fatal', 'panic', 'log', 'error', 'warning', 'notice', 'info', 'debug1', 'debug2', 'debug3', 'debug4', 'debug5') then ' log min messages database flag value set to fatal, panic, log, error, warning, notice, info, debug1, debug2, debug3, debug4, debug5'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_min_messages' and (flags ->> 'value') in ('fatal', 'panic', 'log', 'error', 'warning', 'notice', 'info', 'debug1', 'debug2', 'debug3', 'debug4', 'debug5')) then ' log min messages database flag value set to fatal, panic, log, error, warning, notice, info, debug1, debug2, debug3, debug4, debug5'
        else ' log min messages database flag value not set'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance' and
      (arguments ->> 'database_version') like 'POSTGRES%';
  EOQ
}

query "sql_instance_postgresql_log_statement_flag_set" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_statement' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('ddl', 'mod', 'all') then 'ok' 
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_statement' and (flags ->> 'value') in ('ddl', 'mod', 'all')) then 'ok'
        else 'alarm'
      end as status,
      name || case
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'object' and (arguments -> 'settings' -> 'database_flags' ->> 'name') = 'log_statement' and (arguments -> 'settings' -> 'database_flags' ->> 'value') in ('ddl', 'mod', 'all') then ' log min messages database flag value set to fatal, panic, log, error, warning, notice, info, debug1, debug2, debug3, debug4, debug5'
        when jsonb_typeof(arguments -> 'settings' -> 'database_flags') = 'array' and exists(select 1 from jsonb_array_elements(arguments -> 'settings' -> 'database_flags') as flags where (flags ->> 'name') = 'log_statement' and (flags ->> 'value') in ('ddl', 'mod', 'all')) then ' log min messages database flag value set to fatal, panic, log, error, warning, notice, info, debug1, debug2, debug3, debug4, debug5'
        else ' log min messages database flag value not set'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance' and
      (arguments ->> 'database_version') like 'POSTGRES%';
  EOQ
}

query "sql_instance_sql_with_no_public_ip" {
  sql = <<-EOQ
    select
      type || ' ' || name as resource,
      case
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'ipv4_enabled') is null then 'alarm'
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'ipv4_enabled')::boolean then 'alarm' 
        else 'ok'
      end as status,
      name || case
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'ipv4_enabled') is null then ' ipv4_enabled is not defined'
        when (arguments -> 'settings' -> 'ip_configuration' ->> 'ipv4_enabled')::boolean then ' public IP address configured'
        else ' no public IP address configured'
      end || '.' reason
      ${local.common_dimensions_sql}
    from
      terraform_resource
    where
      type = 'google_sql_database_instance' and
      (arguments ->> 'database_version') like 'SQLSERVER%';;
  EOQ
}