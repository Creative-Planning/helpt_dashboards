{% macro get_dynamic_columns(schema, table, column_prefix) %}
    {% set query %}
        SELECT string_agg(column_name, ', ')
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE table_name = '{{ table }}'
          AND table_schema = '{{ schema }}'
          AND column_name LIKE '{{ column_prefix }}%'
    {% endset %}

    {% set results = run_query(query) %}

    {{ return(query) }}
{% endmacro %}
