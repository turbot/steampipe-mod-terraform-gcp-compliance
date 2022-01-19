select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'database_version'), '') = '' then 'alarm'
    when arguments ->> 'database_version' not like 'POSTGRES%' then 'skip'
    when (arguments -> 'settings' -> 'database_flags' ->> 'name' = 'log_executor_stats'
      and arguments -> 'settings' -> 'database_flags' ->> 'value' = 'off')
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'database_version'), '') = ''
    then ' ''database_version'' is not defined.'
    when arguments ->> 'database_version' not like 'POSTGRES%'
    then ' not a PostgreSQL database.'
    when (coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'name'), '') = ''
      and coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'value'), '') = '')
    then ' ''database_flags'' is not defined.'
    when coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'name'), '') = ''
    then ' ''database_flags.name'' is not defined.'
    when coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'value'), '') = ''
    then ' ''database_flags.value'' is not defined.'
    when arguments -> 'settings' -> 'database_flags' ->> 'name' <> 'log_executor_stats'
      then ' ''log_executor_stats'' database flag not set.'
    when (arguments -> 'settings' -> 'database_flags' ->> 'name' = 'log_executor_stats'
      and arguments -> 'settings' -> 'database_flags' ->> 'value' = 'off')
      then ' ''log_executor_stats'' database flag set to ''off''.'
    else ' ''log_executor_stats'' database flag set to ''on''.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';