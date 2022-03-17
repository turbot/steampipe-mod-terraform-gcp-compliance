select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'enable_legacy_abac')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments ->> 'enable_legacy_abac') is null then ' ''enable_legacy_abac'' is not defined'
    when (arguments ->> 'enable_legacy_abac')::boolean then ' legacy authorization enabled'
    else ' legacy authorization disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_container_cluster';