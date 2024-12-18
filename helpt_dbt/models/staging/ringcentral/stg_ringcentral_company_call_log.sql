WITH call_logs AS (
    SELECT
        id,
        'ringcentral' AS eng_source,
        startTime AS eng_start,
        NULL AS eng_end,
        durationMs AS time_spent,
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
    q.queue_name AS eng_queue
FROM call_logs cl
LEFT JOIN {{ source('ringcentral', 'call_queues') }} q
    ON cl.extension_id = q.extensionId;