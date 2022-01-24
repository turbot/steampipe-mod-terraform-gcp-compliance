select
  type || ' ' || name as resource,
  case
    when coalesce(trim(arguments ->> 'entity'), '') like any (array ['', '%allAuthenticatedUsers%','%allUsers%'])
    then 'alarm'
    else 'ok'
  end as status,
  name || case
    when coalesce(trim(arguments ->> 'entity'), '') = '' then ' ''entity'' is not defined'
    when arguments ->> 'entity' like any (array ['%allAuthenticatedUsers%','%allUsers%']) then ' publicly accessible'
    else ' not publicly accessible'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_storage_bucket_access_control';