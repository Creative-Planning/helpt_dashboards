SELECT 
    id,
    properties_name AS name,
    properties_closedate AS closed_date,
    {{ get_dynamic_columns(
        schema='source',
        table='hubspot_companies',
        column_prefix='properties_plan_'
    ) }}
FROM {{ source('hubspot', 'companies') }}