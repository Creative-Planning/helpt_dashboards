DECLARE column_list TEXT;

SELECT string_agg(column_name, ', ') INTO column_list
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name = 'hubspot_companies'
        AND table_schema = 'source'
        AND column_name LIKE 'properties_plan_%';

query := 'SELECT id,
        properties_name AS name,
        properties_closeddate AS closed_date, ' ||
        column_list ||
    'FROM {{ source("hubspot", "companies")}}';

EXECUTE query;
