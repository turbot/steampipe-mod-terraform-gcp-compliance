select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'database_version'), '') = '' then 'alarm'
    when arguments ->> 'database_version' not like 'MYSQL%' then 'skip'
    when (arguments -> 'settings' -> 'database_flags' ->> 'name' = 'skip_show_database'
      and arguments -> 'settings' -> 'database_flags' ->> 'value' = 'on')
    then 'ok'
    else 'alarm'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'database_version'), '') = ''
    then ' ''database_version'' is not defined.'
    when arguments ->> 'database_version' not like 'MYSQL%'
    then ' not a MySQL database.'
    when (coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'name'), '') = ''
      and coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'value'), '') = '')
    then ' ''database_flags'' is not defined.'
    when coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'name'), '') = ''
    then ' ''database_flags.name'' is not defined.'
    when coalesce(trim(arguments -> 'settings' -> 'database_flags' ->> 'value'), '') = ''
    then ' ''database_flags.value'' is not defined.'
    when arguments -> 'settings' -> 'database_flags' ->> 'name' <> 'skip_show_database'
      then ' ''skip_show_database'' database flag not set.'
    when (arguments -> 'settings' -> 'database_flags' ->> 'name' = 'skip_show_database'
      and arguments -> 'settings' -> 'database_flags' ->> 'value' = 'on')
      then ' ''skip_show_database'' database flag set to ''on''.'
    else ' ''skip_show_database'' database flag set to ''off''.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';