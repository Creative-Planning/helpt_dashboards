
select
    "projectId" as id,
    'tmetric' as queue_type,
    "projectCode" as nname,
    "projectName" as name
from {{ source('tmetric','projects')}}
