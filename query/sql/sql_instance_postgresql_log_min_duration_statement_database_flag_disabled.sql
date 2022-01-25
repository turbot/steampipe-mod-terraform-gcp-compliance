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
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';