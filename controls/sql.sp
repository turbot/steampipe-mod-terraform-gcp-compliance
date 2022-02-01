locals {
  policy_bundle_sql_common_tags = {
    service = "sql"
  }
}

locals {
  sql_compliance_common_tags = merge(local.compliance_common_tags, {
    service = "sql"
  })
}

benchmark "sql" {
  title       = "Cloud SQL"
  description = "This benchmark provides a set of controls that detect Terraform GCP Cloud SQL resources deviating from security best practices."

  children = [
    control.sql_instance_automated_backups_enabled,
    control.sql_instance_mysql_local_infile_database_flag_off,
    control.sql_instance_mysql_skip_show_database_flag_on,
    control.sql_instance_postgresql_log_checkpoints_database_flag_on,
    control.sql_instance_postgresql_log_connections_database_flag_on,
    control.sql_instance_postgresql_log_disconnections_database_flag_on,
    control.sql_instance_postgresql_log_duration_database_flag_on,
    control.sql_instance_postgresql_log_executor_stats_database_flag_off,
    control.sql_instance_postgresql_log_hostname_database_flag_configured,
    control.sql_instance_postgresql_log_lock_waits_database_flag_on,
    control.sql_instance_postgresql_log_min_duration_statement_database_flag_disabled,
    control.sql_instance_postgresql_log_parser_stats_database_flag_off,
    control.sql_instance_postgresql_log_planner_stats_database_flag_off,
    control.sql_instance_postgresql_log_statement_stats_database_flag_off,
    control.sql_instance_postgresql_log_temp_files_database_flag_0,
    control.sql_instance_require_ssl_enabled,
    control.sql_instance_sql_3625_trace_database_flag_off,
    control.sql_instance_sql_contained_database_authentication_database_flag_off,
    control.sql_instance_sql_cross_db_ownership_chaining_database_flag_off,
    control.sql_instance_sql_external_scripts_enabled_database_flag_off,
    control.sql_instance_sql_remote_access_database_flag_off,
    control.sql_instance_sql_user_options_database_flag_not_configured
  ]

  tags = local.sql_compliance_common_tags
}

control "sql_instance_automated_backups_enabled" {
  title         = "Ensure that Cloud SQL database instances are configured with automated backups"
  description   = "It is recommended to have all SQL database instances set to enable automated backups."
  sql           = query.sql_instance_automated_backups_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.7"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_mysql_local_infile_database_flag_off" {
  title         = "Ensure that the 'local_infile' database flag for a Cloud SQL Mysql instance is set to 'off'"
  description   = "It is recommended to set the local_infile database flag for a Cloud SQL MySQL instance to off."
  sql           = query.sql_instance_mysql_local_infile_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.1.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_mysql_skip_show_database_flag_on" {
  title         = "Ensure 'skip_show_database' database flag for Cloud SQL Mysql instance is set to 'on'"
  description   = "It is recommended to set skip_show_database database flag for Cloud SQL Mysql instance to on."
  sql           = query.sql_instance_mysql_skip_show_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.1.2"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_checkpoints_database_flag_on" {
  title         = "Ensure that the 'log_checkpoints' database flag for Cloud SQL PostgreSQL instance is set to 'on'"
  description   = "Ensure that the log_checkpoints database flag for the Cloud SQL PostgreSQL instance is set to on."
  sql           = query.sql_instance_postgresql_log_checkpoints_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_connections_database_flag_on" {
  title         = "Ensure that the 'log_connections' database flag for Cloud SQL PostgreSQL instance is set to 'on'"
  description   = "Enabling the log_connections setting causes each attempted connection to the server to be logged, along with successful completion of client authentication. This parameter cannot be changed after the session starts."
  sql           = query.sql_instance_postgresql_log_connections_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.3"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_disconnections_database_flag_on" {
  title         = "Ensure that the 'log_disconnections' database flag for Cloud SQL PostgreSQL instance is set to 'on'"
  description   = "Enabling the log_disconnections setting logs the end of each session, including the session duration."
  sql           = query.sql_instance_postgresql_log_disconnections_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_duration_database_flag_on" {
  title         = "Ensure 'log_duration' database flag for Cloud SQL PostgreSQL instance is set to 'on'"
  description   = "Enabling the log_duration setting causes the duration of each completed statement to be logged. This does not logs the text of the query and thus behaves different from the log_min_duration_statement flag. This parameter cannot be changed after session start."
  sql           = query.sql_instance_postgresql_log_duration_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.5"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "sql_instance_postgresql_log_executor_stats_database_flag_off" {
  title         = "Ensure 'log_executor_stats' database flag for Cloud SQL PostgreSQL instance is set to 'off'"
  description   = "The PostgreSQL executor is responsible to execute the plan handed over by the PostgreSQL planner. The executor processes the plan recursively to extract the required set of rows. The log_executor_stats flag controls the inclusion of PostgreSQL executor performance statistics in the PostgreSQL logs for each query."
  sql           = query.sql_instance_postgresql_log_executor_stats_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.11"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_hostname_database_flag_configured" {
  title         = "Ensure 'log_hostname' database flag for Cloud SQL PostgreSQL instance is set appropriately"
  description   = "PostgreSQL logs only the IP address of the connecting hosts. The log_hostname flag controls the logging of hostnames in addition to the IP addresses logged. The performance hit is dependent on the configuration of the environment and the host name resolution setup. This parameter can only be set in the postgresql.conf file or on the server command line."
  sql           = query.sql_instance_postgresql_log_hostname_database_flag_configured.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.8"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_lock_waits_database_flag_on" {
  title         = "Ensure that the 'log_lock_waits' database flag for Cloud SQL PostgreSQL instance is set to 'on'"
  description   = "Enabling the log_lock_waits flag for a PostgreSQL instance creates a log for any session waits that take longer than the alloted deadlock_timeout time to acquire a lock."
  sql           = query.sql_instance_postgresql_log_lock_waits_database_flag_on.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_min_duration_statement_database_flag_disabled" {
  title         = "Ensure that the 'log_min_duration_statement' database flag for Cloud SQL PostgreSQL instance is set to '-1' (disabled)"
  description   = "The log_min_duration_statement flag defines the minimum amount of execution time of a statement in milliseconds where the total duration of the statement is logged. Ensure that log_min_duration_statement is disabled, i.e., a value of -1 is set."
  sql           = query.sql_instance_postgresql_log_min_duration_statement_database_flag_disabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.16"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_parser_stats_database_flag_off" {
  title         = "Ensure 'log_parser_stats' database flag for Cloud SQL PostgreSQL instance is set to 'off'"
  description   = "The PostgreSQL planner/optimizer is responsible to parse and verify the syntax of each query received by the server. If the syntax is correct a parse tree is built up else an error is generated. The log_parser_stats flag controls the inclusion of parser performance statistics in the PostgreSQL logs for each query."
  sql           = query.sql_instance_postgresql_log_parser_stats_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.9"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_planner_stats_database_flag_off" {
  title         = "Ensure 'log_planner_stats' database flag for Cloud SQL PostgreSQL instance is set to 'off'"
  description   = "The same SQL query can be executed in multiple ways and still produce different results. The PostgreSQL planner/optimizer is responsible to create an optimal execution plan for each query. The log_planner_stats flag controls the inclusion of PostgreSQL planner performance statistics in the PostgreSQL logs for each query."
  sql           = query.sql_instance_postgresql_log_planner_stats_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.10"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_statement_stats_database_flag_off" {
  title         = "Ensure 'log_statement_stats' database flag for Cloud SQL PostgreSQL instance is set to 'off'"
  description   = "The log_statement_stats flag controls the inclusion of end to end performance statistics of a SQL query in the PostgreSQL logs for each query. This cannot be enabled with other module statistics (log_parser_stats, log_planner_stats, log_executor_stats)."
  sql           = query.sql_instance_postgresql_log_statement_stats_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.12"
    cis_level   = "2"
    cis_type    = "automated"
  })
}

control "sql_instance_postgresql_log_temp_files_database_flag_0" {
  title         = "Ensure that the 'log_temp_files' database flag for Cloud SQL PostgreSQL instance is set to '0'"
  description   = "PostgreSQL can create a temporary file for actions such as sorting, hashing and temporary query results when these operations exceed work_mem. The log_temp_files flag controls logging names and the file size when it is deleted. Configuring log_temp_files to 0 causes all temporary file information to be logged, while positive values log only files whose size is greater than or equal to the specified number of kilobytes. A value of -1 disables temporary file information logging."
  sql           = query.sql_instance_postgresql_log_temp_files_database_flag_0.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.2.15"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_require_ssl_enabled" {
  title         = "Ensure that the Cloud SQL database instance requires all incoming connections to use SSL"
  description   = "It is recommended to enforce all incoming connections to SQL database instance to use SSL."
  sql           = query.sql_instance_require_ssl_enabled.sql

  tags = merge(local.sql_compliance_common_tags, {
    cft_scorecard_v1   = "true"
    cis                = "true"
    cis_item_id        = "6.4"
    cis_level          = "1"
    cis_type           = "automated"
    severity           = "high"
  })
}

control "sql_instance_sql_3625_trace_database_flag_off" {
  title         = "Ensure '3625 (trace flag)' database flag for Cloud SQL SQL Server instance is set to 'off'"
  description   = "It is recommended to set 3625 (trace flag) database flag for Cloud SQL SQL Server instance to off."
  sql           = query.sql_instance_sql_3625_trace_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_sql_contained_database_authentication_database_flag_off" {
  title         = "Ensure that the 'contained database authentication' database flag for Cloud SQL on the SQL Server instance is set to 'off'"
  description   = "It is recommended to set contained database authentication database flag for Cloud SQL on the SQL Server instance is set to off."
  sql           = query.sql_instance_sql_contained_database_authentication_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.7"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_sql_cross_db_ownership_chaining_database_flag_off" {
  title         = "Ensure that the 'cross db ownership chaining' database flag for Cloud SQL SQL Server instance is set to 'off'"
  description   = "It is recommended to set cross db ownership chaining database flag for Cloud SQL SQL Server instance to off."
  sql           = query.sql_instance_sql_cross_db_ownership_chaining_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.2"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_sql_external_scripts_enabled_database_flag_off" {
  title         = "Ensure 'external scripts enabled' database flag for Cloud SQL SQL Server instance is set to 'off'"
  description   = "It is recommended to set external scripts enabled database flag for Cloud SQL SQL Server instance to off."
  sql           = query.sql_instance_sql_external_scripts_enabled_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_sql_remote_access_database_flag_off" {
  title         = "Ensure 'remote access' database flag for Cloud SQL SQL Server instance is set to 'off'"
  description   = "It is recommended to set remote access database flag for Cloud SQL SQL Server instance to off."
  sql           = query.sql_instance_sql_remote_access_database_flag_off.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "sql_instance_sql_user_options_database_flag_not_configured" {
  title         = "Ensure 'user options' database flag for Cloud SQL SQL Server instance is not configured"
  description   = "It is recommended that, user options database flag for Cloud SQL SQL Server instance should not be configured."
  sql           = query.sql_instance_sql_user_options_database_flag_not_configured.sql

  tags = merge(local.sql_compliance_common_tags, {
    cis         = "true"
    cis_item_id = "6.3.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}