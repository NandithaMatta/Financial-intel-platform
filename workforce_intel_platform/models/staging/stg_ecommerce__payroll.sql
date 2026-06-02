WITH source AS (
    SELECT * FROM {{ source('ecommerce_raw', 'payroll') }}
),

renamed AS (
    SELECT
        CAST(payroll_id AS VARCHAR)         AS payroll_id,
        CAST(employee_id AS VARCHAR)        AS employee_id,
        CAST(pay_period_start AS VARCHAR)   AS pay_period_start,
        CAST(pay_period_end AS VARCHAR)     AS pay_period_end,
        CAST(gross_pay AS DOUBLE)           AS gross_pay,
        CAST(net_pay AS DOUBLE)             AS net_pay,
        CAST(tax_withheld AS DOUBLE)        AS tax_withheld,
        CAST(payment_date AS VARCHAR)       AS payment_date,
        CAST(payment_status AS VARCHAR)     AS payment_status,
        CAST(domain AS VARCHAR)             AS domain,
        CAST(_ingested_at AS VARCHAR)       AS ingested_at
    FROM source
)

SELECT * FROM renamed