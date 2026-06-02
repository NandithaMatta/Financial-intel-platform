WITH fintech_comp AS (
    SELECT
        employee_id,
        employee_name,
        department,
        job_band,
        location,
        employment_type,
        domain,
        currency,
        effective_date,
        base_salary,
        bonus_amount,
        equity_value,
        ingested_at
    FROM {{ ref('stg_fintech__compensation') }}
),

ecommerce_comp AS (
    SELECT
        employee_id,
        employee_name,
        department,
        job_band,
        location,
        employment_type,
        domain,
        currency,
        effective_date,
        base_salary,
        bonus_amount,
        equity_value,
        ingested_at
    FROM {{ ref('stg_ecommerce__compensation') }}
),

healthcare_comp AS (
    SELECT
        employee_id,
        employee_name,
        department,
        job_band,
        location,
        employment_type,
        domain,
        currency,
        effective_date,
        base_salary,
        bonus_amount,
        equity_value,
        ingested_at
    FROM {{ ref('stg_healthcare__compensation') }}
),

all_compensation AS (
    SELECT * FROM fintech_comp
    UNION ALL
    SELECT * FROM ecommerce_comp
    UNION ALL
    SELECT * FROM healthcare_comp
),

enriched AS (
    SELECT
        employee_id,
        employee_name,
        department,
        job_band,
        location,
        employment_type,
        domain,
        currency,
        effective_date,
        base_salary,
        bonus_amount,
        equity_value,
        base_salary + bonus_amount + equity_value   AS total_compensation,
        bonus_amount / NULLIF(base_salary, 0) * 100 AS bonus_pct_of_base,
        equity_value / NULLIF(base_salary, 0) * 100 AS equity_pct_of_base,
        ingested_at
    FROM all_compensation
)

SELECT * FROM enriched
