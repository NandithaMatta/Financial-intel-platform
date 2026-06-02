import csv
import random
import os
from datetime import datetime, timedelta

# Sample data generators
departments = ["Engineering", "Sales", "Finance", "HR", "Operations", "Marketing"]
job_bands = ["L1", "L2", "L3", "L4", "L5", "L6"]
locations = ["New York", "San Francisco", "Chicago", "Austin", "Remote"]
employment_types = ["Full-Time", "Part-Time", "Contract"]

def random_date(start_year=2023):
    start = datetime(start_year, 1, 1)
    end = datetime(2026, 1, 1)
    return (start + timedelta(days=random.randint(0, (end - start).days))).strftime("%Y-%m-%d")

def generate_compensation_data(domain, num_records=50):
    records = []
    for i in range(1, num_records + 1):
        band = random.choice(job_bands)
        base = {"L1": 60000, "L2": 80000, "L3": 100000, "L4": 130000, "L5": 160000, "L6": 200000}[band]
        records.append({
            "employee_id": f"{domain[:3].upper()}-{i:04d}",
            "employee_name": f"Employee_{i}",
            "department": random.choice(departments),
            "job_band": band,
            "location": random.choice(locations),
            "employment_type": random.choice(employment_types),
            "base_salary": base + random.randint(-5000, 15000),
            "bonus_amount": round(base * random.uniform(0.05, 0.20)),
            "equity_value": round(base * random.uniform(0, 0.50)),
            "effective_date": random_date(),
            "currency": "USD",
            "domain": domain
        })
    return records

def generate_headcount_data(domain, num_records=50):
    records = []
    for i in range(1, num_records + 1):
        records.append({
            "employee_id": f"{domain[:3].upper()}-{i:04d}",
            "full_name": f"Employee_{i}",
            "department": random.choice(departments),
            "manager_id": f"{domain[:3].upper()}-{random.randint(1, 10):04d}",
            "hire_date": random_date(2020),
            "termination_date": None,
            "is_active": True,
            "headcount_date": datetime.now().strftime("%Y-%m-%d"),
            "domain": domain
        })
    return records

def generate_payroll_data(domain, num_records=50):
    records = []
    for i in range(1, num_records + 1):
        base = random.randint(50000, 200000)
        records.append({
            "payroll_id": f"PAY-{domain[:3].upper()}-{i:04d}",
            "employee_id": f"{domain[:3].upper()}-{i:04d}",
            "pay_period_start": random_date(),
            "pay_period_end": random_date(),
            "gross_pay": round(base / 24, 2),
            "net_pay": round(base / 24 * 0.75, 2),
            "tax_withheld": round(base / 24 * 0.25, 2),
            "payment_date": random_date(),
            "payment_status": random.choice(["Processed", "Pending", "Failed"]),
            "domain": domain
        })
    return records

def save_csv(data, filepath):
    os.makedirs(os.path.dirname(filepath), exist_ok=True)
    with open(filepath, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=data[0].keys())
        writer.writeheader()
        writer.writerows(data)
    print(f"✅ Created: {filepath} ({len(data)} records)")

# Generate data for all 3 domains
for domain in ["fintech", "ecommerce", "healthcare"]:
    save_csv(generate_compensation_data(domain), f"sample_data/{domain}/compensation.csv")
    save_csv(generate_headcount_data(domain), f"sample_data/{domain}/headcount.csv")
    save_csv(generate_payroll_data(domain), f"sample_data/{domain}/payroll.csv")

print("\n🎉 All sample data generated successfully!")
