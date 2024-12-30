
SELECT 
    id,
    'ringcentral' as queue_type,
    name as nname,
    name
FROM {{ source('ringcentral', 'call_queues')}}
