WITH payroll AS (
    SELECT * FROM {{ ref('int_payroll__enriched') }}
),

employees AS (
    SELECT
        employee_id,
        full_name,
        department,
        domain
    FROM {{ ref('int_headcount__enriched') }}
),

final AS (
    SELECT
        pay.payroll_id,
        pay.employee_id,
        emp.full_name,
        emp.department,
        pay.domain,
        pay.pay_period_start,
        pay.pay_period_end,
        pay.gross_pay,
        pay.net_pay,
        pay.tax_withheld,
        pay.total_deductions,
        pay.effective_tax_rate,
        pay.payment_date,
        pay.payment_status,
        pay.ingested_at
    FROM payroll pay
    LEFT JOIN employees emp
        ON pay.employee_id = emp.employee_id
        AND pay.domain = emp.domain
)

SELECT * FROM final
