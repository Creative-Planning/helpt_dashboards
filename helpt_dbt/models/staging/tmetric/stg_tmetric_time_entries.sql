
select
    id,
    'tmetric' as eng_source,
    startTime as eng_start,
    endTime as eng_end,
    extract('epoch' from age(startTime, endTime)) as time_spent,
    project_name as eng_queue
from {{ source('tmetric','time_entries')}}
