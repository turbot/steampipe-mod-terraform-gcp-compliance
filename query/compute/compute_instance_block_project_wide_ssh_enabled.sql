select
  type || ' ' || name as resource,
  case
    when (arguments -> 'metadata') is null then 'alarm'
     when (arguments -> 'metadata' -> 'block-project-ssh-keys') is null then 'alarm'
    when (arguments -> 'metadata' ->> 'block-project-ssh-keys') = 'true' then 'ok'
    else 'alarm'
  end status,
  name || case
    when (arguments -> 'metadata') is null then ' ''metadata'' property is not defined'
    when (arguments -> 'metadata' -> 'block-project-ssh-keys') is null then ' ''block-project-ssh-keys'' property is not defined'
    when (arguments -> 'metadata' ->> 'block-project-ssh-keys') = 'true' then ' has Block Project-wide SSH keys enabled'
    else ' has Block Project-wide SSH keys disabled'
  end || '.' reason,
  path || ':' || start_line
from
  terraform_resource
where
  type = 'google_compute_instance';