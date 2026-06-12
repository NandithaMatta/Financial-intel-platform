# Financial Intelligence Platform

An end-to-end ELT data platform for financial analytics — from raw ingestion on AWS to transformed, query-optimized models ready for reporting and analysis.

Built with a modern cloud-native stack: AWS Glue for ingestion, S3 as the data lake, Athena for querying, dbt for transformation, and Jenkins for CI/CD orchestration.

---

## Architecture Overview

```
Raw Financial Data
       │
       ▼
  AWS Glue (Crawlers + ETL Jobs)
       │
       ▼
  Amazon S3 (Data Lake)
       │
       ▼
  AWS Athena (Query Engine)
       │
       ▼
  dbt (Transformation Layer)
       │
       ▼
  Reporting / Analytics Layer
```

---


## Tech Stack

| Layer | Tool |
|---|---|
| Ingestion | AWS Glue (Crawlers + ETL Jobs) |
| Storage | Amazon S3 (Data Lake) |
| Query Engine | AWS Athena |
| Transformation | dbt (SQL models) |
| Orchestration / CI-CD | Jenkins |
| Language | Python, SQL |

---

## Project Structure

```
financial-intel-platform/
├── glue_jobs/           # AWS Glue ETL scripts
├── dbt_project/
│   ├── models/
│   │   ├── staging/     # Raw → cleaned source models
│   │   ├── intermediate/# Business logic transformations
│   │   └── marts/       # Final analytics-ready tables
│   ├── tests/           # dbt data quality tests
│   └── dbt_project.yml
├── sql/                 # Ad-hoc Athena queries and optimizations
├── pipelines/           # Jenkins pipeline definitions
└── README.md
```

---

## ELT Pipeline

### 1. Ingestion (AWS Glue)
- Glue Crawlers automatically catalog raw financial data landed in S3
- Glue ETL jobs handle schema normalization and file format conversion (CSV/JSON → Parquet)
- Partitioning strategy applied at ingestion to minimize downstream scan costs

### 2. Storage (Amazon S3)
- Raw, staged, and curated zones follow a medallion-style lake architecture
- Parquet with Snappy compression used throughout for cost and performance efficiency

### 3. Querying (AWS Athena)
- Athena used as serverless query engine on top of S3
- Query optimization techniques applied: partition pruning, predicate pushdown, columnar format
- Result: **35% cost reduction** on Athena query spend

### 4. Transformation (dbt)
- dbt models organized into staging → intermediate → marts layers
- Data quality tests (not_null, unique, accepted_values) enforced across critical fields
- Incremental models used where applicable to minimize full-refresh costs

### 5. Orchestration (Jenkins)
- Jenkins pipelines trigger Glue jobs and dbt runs on schedule
- Pipeline stages: ingest → validate → transform → test → notify
- Failure alerting and retry logic built into pipeline definitions

---

## Getting Started

### Prerequisites
- AWS account with Glue, S3, and Athena access
- Python 3.8+
- dbt Core (`pip install dbt-athena-community`)
- Jenkins (local or hosted)

### Setup

```bash
# Clone the repo
git clone https://github.com/NandithaMatta/financial-intel-platform.git
cd financial-intel-platform

# Install Python dependencies
pip install -r requirements.txt

# Configure dbt profile (update ~/.dbt/profiles.yml with your Athena details)
cp dbt_project/profiles_example.yml ~/.dbt/profiles.yml

# Run dbt models
cd dbt_project
dbt deps
dbt run
dbt test
```

### AWS Configuration
Set up your AWS credentials before running Glue jobs:
```bash
aws configure
# Enter your AWS Access Key, Secret Key, and preferred region
```

---

## dbt Models

| Model | Layer | Description |
|---|---|---|
| `stg_financial_transactions` | Staging | Cleaned raw transaction records |
| `stg_accounts` | Staging | Normalized account master data |
| `int_transaction_summary` | Intermediate | Aggregated transaction metrics by account/period |
| `fct_financial_performance` | Mart | Final fact table for reporting |
| `dim_accounts` | Mart | Account dimension with full attributes |

---

## Performance Optimizations

**Partition Strategy**
- Data partitioned by `year/month/day` in S3 to enable partition pruning in Athena
- Reduces data scanned per query significantly on time-series financial data

**File Format**
- Converted all raw files to Parquet with Snappy compression
- Columnar format allows Athena to scan only required columns

**Query Design**
- Avoided `SELECT *` patterns in dbt models
- Applied predicate pushdown and filter-early patterns throughout the SQL

---

## CI/CD Pipeline (Jenkins)

```
Jenkinsfile stages:
  1. Checkout
  2. AWS Glue Job Trigger
  3. Glue Job Status Check (poll)
  4. dbt run (staging models)
  5. dbt run (mart models)
  6. dbt test
  7. Notify (success/failure)
```

---

## Author

**Nanditha Matta**
Software Engineer | Data & AI
[github.com/NandithaMatta](https://github.com/NandithaMatta) · [LinkedIn](https://linkedin.com/in/nandithamc)
