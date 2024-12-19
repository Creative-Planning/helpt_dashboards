WITH call_logs AS (
    SELECT
        id,
        'ringcentral' AS eng_source,
        "startTime"::timestamp AS eng_start,
        "startTime"::timestamp + make_interval(secs=>duration) AS eng_end,
        "durationMs"::decimal AS time_spent,
        "to"->>'phoneNumber' AS to_number,
        "from"->>'phoneNumber' AS from_number,
        result,
        direction,
        COALESCE("to"->>'extensionId', "from"->>'extensionId') AS extension_id
    FROM {{ source('ringcentral', 'company_call_log') }}
)

SELECT
    cl.id,
    cl.eng_source,
    cl.eng_start,
    cl.eng_end,
    cl.time_spent,
    cl.to_number,
    cl.from_number,
    cl.result,
    cl.direction,
    q.id::varchar AS eng_queue_id
FROM call_logs cl
LEFT JOIN {{ source('ringcentral', 'call_queues') }} q
    ON cl.extension_id = q.id