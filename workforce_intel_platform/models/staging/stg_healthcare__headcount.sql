WITH source AS (
    SELECT * FROM {{ source('healthcare_raw', 'headcount') }}
),

renamed AS (
    SELECT
        CAST(employee_id AS VARCHAR)        AS employee_id,
        CAST(full_name AS VARCHAR)          AS full_name,
        CAST(department AS VARCHAR)         AS department,
        CAST(manager_id AS VARCHAR)         AS manager_id,
        CAST(hire_date AS VARCHAR)          AS hire_date,
        CAST(termination_date AS VARCHAR)   AS termination_date,
        CAST(is_active AS BOOLEAN)          AS is_active,
        CAST(headcount_date AS VARCHAR)     AS headcount_date,
        CAST(domain AS VARCHAR)             AS domain,
        CAST(_ingested_at AS VARCHAR)       AS ingested_at
    FROM source
)

SELECT * FROM renamed