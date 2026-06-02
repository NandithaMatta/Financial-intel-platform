WITH comp AS (
    SELECT * FROM {{ ref('int_compensation__enriched') }}
),

headcount AS (
    SELECT * FROM {{ ref('int_headcount__enriched') }}
),

final AS (
    SELECT
        comp.employee_id,
        headcount.full_name,
        comp.department,
        comp.job_band,
        comp.location,
        comp.employment_type,
        comp.domain,
        comp.currency,
        comp.effective_date,
        comp.base_salary,
        comp.bonus_amount,
        comp.equity_value,
        comp.total_compensation,
        comp.bonus_pct_of_base,
        comp.equity_pct_of_base,
        headcount.hire_date,
        headcount.is_active,
        headcount.manager_id,
        comp.ingested_at
    FROM comp
    LEFT JOIN headcount
        ON comp.employee_id = headcount.employee_id
        AND comp.domain = headcount.domain
)

SELECT * FROM final
