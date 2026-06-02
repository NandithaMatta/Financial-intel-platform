WITH source AS (
    SELECT * FROM {{ source('fintech_raw', 'compensation') }}
),

renamed AS (
    SELECT
        CAST(employee_id AS VARCHAR)                    AS employee_id,
        CAST(employee_name AS VARCHAR)                  AS employee_name,
        CAST(department AS VARCHAR)                     AS department,
        CAST(job_band AS VARCHAR)                       AS job_band,
        CAST(location AS VARCHAR)                       AS location,
        CAST(employment_type AS VARCHAR)                AS employment_type,
        CAST(base_salary AS DOUBLE)                     AS base_salary,
        CAST(bonus_amount AS DOUBLE)                    AS bonus_amount,
        CAST(equity_value AS DOUBLE)                    AS equity_value,
        CAST(effective_date AS VARCHAR)                 AS effective_date,
        CAST(currency AS VARCHAR)                       AS currency,
        CAST(domain AS VARCHAR)                         AS domain,
        CAST(_ingested_at AS VARCHAR)                   AS ingested_at,
        CAST(_source_domain AS VARCHAR)                 AS source_domain,
        CAST(_source_table AS VARCHAR)                  AS source_table
    FROM source
),

deduped AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY employee_id
            ORDER BY effective_date DESC
        ) AS row_num
    FROM renamed
)

SELECT * FROM deduped WHERE row_num = 1
