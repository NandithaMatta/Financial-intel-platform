# workforce-intel-platform DBT Style Guide

## Naming Conventions
| Layer | Prefix | Materialization | Example |
|---|---|---|---|
| Staging | stg_ | view | stg_fintech__compensation |
| Intermediate | int_ | view | int_compensation__enriched |
| Marts - Fact | fct_ | table | fct_compensation |
| Marts - Dimension | dim_ | table | dim_employee |

## Model Rules
- Staging: cast types, rename columns, deduplicate ONLY
- Intermediate: joins, business logic, derived fields
- Marts: final analytics tables consumed by BI tools

## SQL Style
- ALL SQL keywords UPPERCASE
- snake_case for all column names
- Always alias subqueries
- One column per line in SELECT statements

## Testing Requirements
- All primary keys: not_null + unique
- All foreign keys: not_null
- All amount fields: not_null + custom positive value test
