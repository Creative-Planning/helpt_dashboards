
SELECT * FROM {{ source('ringcentral', 'call_queues')}}
UNION
SELECT * FROM {{ source('tmetric', 'projects')}}
