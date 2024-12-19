
select
    id::varchar,
    'tmetric' as eng_source,
    "startTime"::timestamp as eng_start,
    "endTime"::timestamp as eng_end,
    extract(EPOCH from ("endTime"::timestamp - "startTime"::timestamp)) * 1000 as time_spent,
    NULL as to_number,
    NULL as from_number,
    NULL as result,
    NULL as direction,
    project->>'id' as eng_queue_id
from {{ source('tmetric','time_entries')}}
