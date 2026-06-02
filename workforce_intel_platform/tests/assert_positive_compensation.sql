
-- Custom test: ensures all compensation amounts are positive
-- This test FAILS if any negative values are found

SELECT
    employee_id,
    base_salary,
    bonus_amount,
    equity_value,
    total_compensation
FROM {{ ref('fct_compensation') }}
WHERE
    base_salary <= 0
    OR bonus_amount < 0
    OR equity_value < 0
    OR total_compensation <= 0
