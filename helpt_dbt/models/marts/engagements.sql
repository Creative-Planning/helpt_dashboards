
SELECT * FROM {{ ref('stg_tmetric_time_entries') }}
UNION
SELECT * FROM {{ ref('stg_ringcentral_company_call_log') }}
