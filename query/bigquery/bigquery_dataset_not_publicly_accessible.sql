select
  type || ' ' || name as resource,
  case
    when jsonb_typeof(arguments -> 'access') = 'object' and ((arguments -> 'access' ->> 'special_group') = 'allAuthenticatedUsers') then 'alarm' 
    when jsonb_typeof(arguments -> 'access') = 'array' and ((arguments ->> 'access') like '%allAuthenticatedUsers%') then 'alarm' 
    else 'ok'
  end as status,
  name || case
    when jsonb_typeof(arguments -> 'access') = 'object' and ((arguments -> 'access' ->> 'special_group') = 'allAuthenticatedUsers') then ' is publicly accessible' 
    when jsonb_typeof(arguments -> 'access') = 'array' and ((arguments ->> 'access') like '%allAuthenticatedUsers%') then ' is publicly accessible' 
    else ' is not publicly accessible'
  end || '.' reason, 
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_bigquery_dataset';