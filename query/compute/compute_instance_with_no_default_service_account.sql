select
  type || ' ' || name as resource,
  case
    when (arguments -> 'service_account') is null then 'alarm'
    when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'service_account') is null then ' not configured with default service account'
    when (arguments -> 'service_account' ->> 'email') like '%-compute@developer.gserviceaccount.com' then ' configured to use default service account'
    else ' not configured with default service account'
  end || '.' reason,
  path
from
  terraform_resource
where
  type = 'google_compute_instance';