select
  type || ' ' || name as resource,
  case
    when (arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'node_config') is null then ' ''node_config'' is not defined'
    when (arguments -> 'node_config' -> 'metadata') is null then ' ''node_config.metadata'' is not defined'
    when coalesce(trim((arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints')), '') = ''
    then ' ''node_config.metadata.disable-legacy-endpoints'' is not defined'
    when (arguments -> 'node_config' -> 'metadata' ->> 'disable-legacy-endpoints') = 'true' then ' legacy endpoints disabled'
    else ' legacy endpoints enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_container_cluster';