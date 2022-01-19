select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'database_version'), '') = '' then 'alarm'
    when arguments ->> 'database_version' not like 'SQLSERVER%' then 'skip'
    when arguments -> 'settings' -> 'database_flags' ->> 'name' = 'user options'
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'database_version'), '') = ''
    then ' ''database_version'' is not defined.'
    when arguments ->> 'database_version' not like 'SQLSERVER%'
    then ' not a SQL Server database.'
    when arguments -> 'settings' -> 'database_flags' ->> 'name' = 'user options'
      then ' ''user options'' database flag set.'
    else ' ''user options'' database flag not set.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';