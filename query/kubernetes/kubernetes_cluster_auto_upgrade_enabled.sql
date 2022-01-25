select
  type || ' ' || name as resource,
  case
    when (arguments -> 'management' ->> 'auto_upgrade')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when (arguments -> 'management') is null then ' ''management'' is not defined'
    when (arguments -> 'management' ->> 'auto_upgrade') is null then ' ''management.auto_upgrade'' is not defined'
    when (arguments -> 'management' ->> 'auto_upgrade')::boolean then ' node pool auto upgrade enabled'
    else ' node pool auto upgrade disabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_container_node_pool';