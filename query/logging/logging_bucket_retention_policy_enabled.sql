select
  type || ' ' || name as resource,
  case
    when (arguments -> 'retention_policy' ->> 'is_locked')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when arguments -> 'retention_policy' is null then ' ''retention_policy'' is not defined'
    when arguments -> 'retention_policy' ->> 'is_locked' is null then ' ''retention_policy.is_locked'' is not defined'
    when (arguments -> 'retention_policy' ->> 'is_locked')::boolean then ' has retention policies configured'
    else ' does not have retention policies configured.'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_storage_bucket';