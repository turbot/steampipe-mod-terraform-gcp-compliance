select
  type || ' ' || name as resource,
  case
    when (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when arguments -> 'settings' is null then ' ''settings'' is not defined'
    when arguments -> 'settings' -> 'backup_configuration' is null then ' ''settings.backup_configuration'' is not defined'
    when arguments -> 'settings' -> 'backup_configuration' ->> 'enabled' is null
    then ' ''settings.backup_configuration.enabled'' is not defined'
    when (arguments -> 'settings' -> 'backup_configuration' ->> 'enabled')::boolean then ' automatic backups configured'
    else ' automatic backups not configured'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';