select
  type || ' ' || name as resource,
  case
    when (arguments -> 'disk_encryption_key') is null then 'alarm'
    else 'ok'
  end status,
  name || case
    when (arguments -> 'disk_encryption_key') is null then 'not encrypted with Customer Supplied Key'
    else ' encrypted with Customer Supplied Key'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_disk';