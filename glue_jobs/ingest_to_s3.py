import boto3
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
import io
import os
from datetime import datetime

BUCKET = "workforce-intel-platform-wip01"
DOMAINS = ["fintech", "ecommerce", "healthcare"]
TABLES = ["compensation", "headcount", "payroll"]
s3_client = boto3.client("s3", region_name="us-east-1")

def read_csv(domain, table):
    filepath = f"sample_data/{domain}/{table}.csv"
    df = pd.read_csv(filepath)
    print(f"  📂 Read {len(df)} rows from {filepath}")
    return df

def add_metadata(df, domain, table):
    df["_ingested_at"] = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
    df["_source_domain"] = domain
    df["_source_table"] = table
    return df

def upload_parquet_to_s3(df, domain, table):
    now = datetime.utcnow()
    s3_key = f"raw/{domain}/{table}/year={now.year}/month={now.month:02d}/{table}.parquet"
    table_pa = pa.Table.from_pandas(df)
    buffer = io.BytesIO()
    pq.write_table(table_pa, buffer)
    buffer.seek(0)
    s3_client.put_object(
        Bucket=BUCKET,
        Key=s3_key,
        Body=buffer.getvalue(),
        ContentType="application/octet-stream"
    )
    print(f"  ✅ Uploaded to s3://{BUCKET}/{s3_key}")
    return s3_key

def run_pipeline():
    print(f"\n🚀 Starting ELT ingestion pipeline - {datetime.utcnow()}")
    print(f"   Target bucket: s3://{BUCKET}\n")
    results = []
    for domain in DOMAINS:
        print(f"📦 Processing domain: {domain.upper()}")
        for table in TABLES:
            try:
                df = read_csv(domain, table)
                df = add_metadata(df, domain, table)
                s3_key = upload_parquet_to_s3(df, domain, table)
                results.append({"domain": domain, "table": table, "status": "SUCCESS", "rows": len(df)})
            except Exception as e:
                print(f"  ❌ Failed: {e}")
                results.append({"domain": domain, "table": table, "status": "FAILED", "error": str(e)})
        print()
    print("=" * 50)
    print("📊 PIPELINE SUMMARY")
    print("=" * 50)
    success = [r for r in results if r["status"] == "SUCCESS"]
    failed = [r for r in results if r["status"] == "FAILED"]
    print(f"✅ Successful: {len(success)}/{len(results)} jobs")
    if failed:
        print(f"❌ Failed: {len(failed)} jobs")
        for f in failed:
            print(f"   - {f['domain']}/{f['table']}: {f.get('error')}")
    print(f"\n🎉 Pipeline complete!")

if __name__ == "__main__":
    run_pipeline()
