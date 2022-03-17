select
  type || ' ' || name as resource,
  case
    when (arguments -> 'default_encryption_configuration') is null then 'alarm' 
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'default_encryption_configuration') is null then ' not encrypted with CMEK' 
    else ' encrypted with CMEK'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_bigquery_dataset';