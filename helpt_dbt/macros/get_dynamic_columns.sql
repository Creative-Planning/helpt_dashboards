{% macro get_dynamic_columns(schema, table, column_prefix) %}
    {% if execute %}
        {% set query %}
            SELECT column_name
            FROM information_schema.columns
            WHERE table_name = '{{ table }}'
              AND table_schema = '{{ schema }}'
              AND column_name LIKE '{{ column_prefix }}%'
            ORDER BY column_name
        {% endset %}

        {% set results = run_query(query) %}
        {% set columns = results.columns[0].values() %}
        
        {{ log("Found columns: " ~ columns, info=True) }}  -- Good to keep this debug log
        
        {%- set column_list = [] -%}
        {%- for column in columns -%}
            {% do column_list.append(column) %}
        {%- endfor -%}

        {{ return(column_list|join(', ')) }}
    {% else %}
        {{ return('') }}  -- Changed from '1' to empty string as it's more appropriate for SQL concatenation
    {% endif %}
{% endmacro %}
