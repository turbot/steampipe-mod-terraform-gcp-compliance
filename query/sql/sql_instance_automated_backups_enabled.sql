select
  type || ' ' || name as resource,
  case
    when
      (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when 
      arguments -> 'settings' -> 'backup_configuration' ->> 'enabled' is null then ' ''enabled'' is not defined.'
    when 
      (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then ' automatic backups configured.'
    else ' automatic backups not configured.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';