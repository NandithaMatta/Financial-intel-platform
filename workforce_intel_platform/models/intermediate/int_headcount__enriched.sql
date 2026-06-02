WITH fintech_hc AS (
    SELECT * FROM {{ ref('stg_fintech__headcount') }}
),

ecommerce_hc AS (
    SELECT * FROM {{ ref('stg_ecommerce__headcount') }}
),

healthcare_hc AS (
    SELECT * FROM {{ ref('stg_healthcare__headcount') }}
),

all_headcount AS (
    SELECT * FROM fintech_hc
    UNION ALL
    SELECT * FROM ecommerce_hc
    UNION ALL
    SELECT * FROM healthcare_hc
)

SELECT
    employee_id,
    full_name,
    department,
    manager_id,
    hire_date,
    termination_date,
    is_active,
    headcount_date,
    domain,
    ingested_at
FROM all_headcount
