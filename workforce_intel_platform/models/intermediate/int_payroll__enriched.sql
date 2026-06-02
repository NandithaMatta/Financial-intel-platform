WITH fintech_pay AS (
    SELECT * FROM {{ ref('stg_fintech__payroll') }}
),

ecommerce_pay AS (
    SELECT * FROM {{ ref('stg_ecommerce__payroll') }}
),

healthcare_pay AS (
    SELECT * FROM {{ ref('stg_healthcare__payroll') }}
),

all_payroll AS (
    SELECT * FROM fintech_pay
    UNION ALL
    SELECT * FROM ecommerce_pay
    UNION ALL
    SELECT * FROM healthcare_pay
)

SELECT
    payroll_id,
    employee_id,
    pay_period_start,
    pay_period_end,
    gross_pay,
    net_pay,
    tax_withheld,
    payment_date,
    payment_status,
    domain,
    gross_pay - net_pay                        AS total_deductions,
    tax_withheld / NULLIF(gross_pay, 0) * 100  AS effective_tax_rate,
    ingested_at
FROM all_payroll
