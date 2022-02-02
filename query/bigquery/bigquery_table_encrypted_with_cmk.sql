select
  type || ' ' || name as resource,
  case
    when (arguments -> 'encryption_configuration') is null then 'alarm' 
    else 'ok'
  end as status,
  name || case
    when (arguments -> 'encryption_configuration') is null then ' encrypted with Google managed cryptographic keys' 
    else ' encrypted with customer-managed encryption keys'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_bigquery_table';