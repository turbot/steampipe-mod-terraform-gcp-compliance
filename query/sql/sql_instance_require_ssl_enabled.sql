select
  type || ' ' || name as resource,
  case
    when
      (arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when 
      arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl' is null then ' ''require_ssl'' is not defined.'
    when 
      (arguments -> 'settings' -> 'ip_configuration' ->> 'require_ssl')::boolean then ' enforces SSL connections.'
    else ' does not enforce SSL connections.'
  end as reason,
  path
from
  terraform_resource
where
  type = 'google_sql_database_instance';