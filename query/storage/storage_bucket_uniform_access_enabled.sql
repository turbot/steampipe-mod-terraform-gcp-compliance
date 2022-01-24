select
  type || ' ' || name as resource,
  case
    when (arguments ->> 'uniform_bucket_level_access')::boolean then 'ok' else 'alarm'
  end as status,
  name || case
    when arguments -> 'uniform_bucket_level_access' is null then ' ''uniform_bucket_level_access'' is not defined'
    when (arguments ->> 'uniform_bucket_level_access')::boolean then ' uniform bucket-level access enabled'
    else ' uniform bucket-level access not enabled'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_storage_bucket';