WITH expanded_call_logs AS (
    SELECT
        leg->>'telephonySessionId' as id,
        leg->'from'->>'name' AS from_name,
        leg->'from'->>'phoneNumber' AS from_number,
        coalesce(leg->'from'->>'extensionId', leg->'from'->>'extensionNumber') as from_extension,
        leg->'to'->>'name' AS to_name,
        leg->'to'->>'phoneNumber' AS to_number,
        coalesce(leg->'to'->>'extensionId', leg->'to'->>'extensionNumber') as to_extension,
        leg->>'result' as result,
        (leg->>'startTime')::timestamp AS eng_start,
        (leg->>'startTime')::timestamp + make_interval(secs=>(leg->>'durationMs')::decimal/1000) AS eng_end,
        ((leg->>'durationMs')::decimal /1000)::integer AS time_spent,
        leg->>'legType' AS leg_type,
        leg->>'direction' as call_direction,
        'ringcentral' AS eng_source
    FROM
        {{ source('ringcentral', 'company_call_log') }} calls,
        jsonb_array_elements(calls.legs) leg
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
    cl.call_direction as direction,
    q.id::varchar AS eng_queue_id
FROM expanded_call_logs cl
LEFT JOIN {{ source('ringcentral', 'call_queues') }} q
    ON q.id in (cl.from_extension, cl.to_extension)