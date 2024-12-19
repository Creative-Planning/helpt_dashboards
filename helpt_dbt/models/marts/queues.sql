
SELECT * FROM {{ ref('stg_ringcentral_call_queues') }}
UNION
SELECT * FROM {{ ref('stg_tmetric_projects') }}