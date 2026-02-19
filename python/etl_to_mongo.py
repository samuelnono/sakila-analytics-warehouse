"""
Sakila Analytics Warehouse - ETL Staging Layer (Python)
------------------------------------------------------

Goal:
Extract sample OLTP data from MySQL (Sakila),
transform it into clean documents,
and load into MongoDB as a staging layer.

This simulates a common real-world pattern:
MySQL (OLTP) -> Python ETL -> MongoDB (staging) -> SQL Warehouse -> Power BI

Notes:
- This script is intentionally "portfolio friendly":
  it documents what you'd do in production even if you don't run it today.
- Replace connection values with your own if you want to execute locally.
"""

from dataclasses import dataclass
from typing import List, Dict, Any
import datetime as dt


# -----------------------------
# Config (edit if running)
# -----------------------------
@dataclass
class MySQLConfig:
    host: str = "localhost"
    user: str = "root"
    password: str = "password"
    database: str = "sakila"


@dataclass
class MongoConfig:
    uri: str = "mongodb://localhost:27017"
    database: str = "sakila_staging"


MYSQL_QUERY_EXTRACT = """
SELECT
  p.payment_id,
  p.customer_id,
  p.staff_id,
  p.rental_id,
  p.amount,
  p.payment_date,
  c.store_id,
  f.film_id,
  f.title,
  f.rating
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LIMIT 500;
"""


# -----------------------------
# Transform helpers
# -----------------------------
def to_date_key(payment_date: dt.datetime) -> int:
    return int(payment_date.strftime("%Y%m%d"))


def transform_rows_to_docs(rows: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
    docs = []
    for r in rows:
        payment_date = r["payment_date"]
        if isinstance(payment_date, str):
            payment_date = dt.datetime.fromisoformat(payment_date)

        docs.append(
            {
                "payment_id": r["payment_id"],
                "customer_id": r["customer_id"],
                "staff_id": r["staff_id"],
                "rental_id": r["rental_id"],
                "store_id": r["store_id"],
                "film": {
                    "film_id": r["film_id"],
                    "title": r["title"],
                    "rating": r["rating"],
                },
                "amount": float(r["amount"]),
                "payment_date": payment_date,
                "date_key": to_date_key(payment_date),
                "loaded_at": dt.datetime.utcnow(),
            }
        )
    return docs


# -----------------------------
# Main ETL (optional execution)
# -----------------------------
def run_etl(mysql_cfg: MySQLConfig, mongo_cfg: MongoConfig) -> None:
    """
    If you want to run this:
    pip install mysql-connector-python pymongo
    Ensure MySQL Sakila + MongoDB are running locally.
    """
    import mysql.connector
    from pymongo import MongoClient

    # Extract
    conn = mysql.connector.connect(
        host=mysql_cfg.host,
        user=mysql_cfg.user,
        password=mysql_cfg.password,
        database=mysql_cfg.database,
    )
    cur = conn.cursor(dictionary=True)
    cur.execute(MYSQL_QUERY_EXTRACT)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    # Transform
    docs = transform_rows_to_docs(rows)

    # Load to MongoDB staging
    client = MongoClient(mongo_cfg.uri)
    db = client[mongo_cfg.database]
    col = db["payments_staging"]

    # Idempotent demo: clear and reload
    col.delete_many({})
    col.insert_many(docs)

    # Indexes to simulate production staging tuning
    col.create_index([("customer_id", 1)])
    col.create_index([("store_id", 1), ("date_key", 1)])

    print(f"Loaded {len(docs)} documents into MongoDB staging: {mongo_cfg.database}.payments_staging")


if __name__ == "__main__":
    # Keep as documentation-first.
    # Uncomment to run locally.
    # run_etl(MySQLConfig(), MongoConfig())
    print("ETL script ready. This file documents the MySQL -> Python -> MongoDB staging layer.")
