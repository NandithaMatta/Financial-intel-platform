WITH headcount AS (
    SELECT * FROM {{ ref('int_headcount__enriched') }}
),

comp AS (
    SELECT
        employee_id,
        domain,
        job_band,
        employment_type,
        location
    FROM {{ ref('int_compensation__enriched') }}
),

final AS (
    SELECT
        hc.employee_id,
        hc.full_name,
        hc.department,
        hc.manager_id,
        hc.hire_date,
        hc.termination_date,
        hc.is_active,
        hc.domain,
        hc.headcount_date,
        comp.job_band,
        comp.employment_type,
        comp.location
    FROM headcount hc
    LEFT JOIN comp
        ON hc.employee_id = comp.employee_id
        AND hc.domain = comp.domain
)

SELECT * FROM final
