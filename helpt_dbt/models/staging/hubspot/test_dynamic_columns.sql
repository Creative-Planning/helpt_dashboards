with source_data as (
    select 
        {{ get_dynamic_columns(
            schema='source',
            table='hubspot_companies',
            column_prefix='properties_plan_'
        ) }}
    from {{ source('hubspot', 'companies') }}
)

select 
    'Found columns' as test_name,
    count(*) as row_count,
    {% set cols = get_dynamic_columns(
        schema='source',
        table='hubspot_companies',
        column_prefix='properties_plan_'
    ) %}
    '{{ cols }}' as column_names
from source_data