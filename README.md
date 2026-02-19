#  Sakila Analytics Warehouse  
OLTP → ETL → OLAP → BI Reporting

This project simulates a production-style data engineering pipeline transforming a normalized OLTP database (Sakila) into an analytical warehouse optimized for KPI reporting and dashboard analytics.

---

# 🏗 Architecture Overview

Pipeline Flow:

OLTP (MySQL Sakila)
→ SQL Extraction Queries
→ Python ETL Scripts
→ MongoDB Staging Layer
→ Snowflake-Style Analytical Warehouse
→ Power BI Dashboard Layer

The system separates transactional data from analytical workloads to simulate real-world data platform design.

---

# 📐 Data Modeling Strategy

## Source System
Normalized OLTP schema (Sakila)

## Target System
Snowflake-style OLAP warehouse

### Fact Table
- orders_fact

### Dimensions
- dim_customer
- dim_film
- dim_store
- dim_staff
- dim_date

Model designed for:

- Time-based trend analysis
- Store-level performance tracking
- Staff productivity analysis
- Film revenue ranking

An ERD diagram was created to validate table relationships and enforce referential integrity during transformation.

---

# 🔄 ETL Implementation

### SQL
- Extracted transactional data
- Flattened multi-table joins
- Built dimensional transformation queries

### Python
- Simulated ETL workflow
- Managed transformation logic
- Structured fact + dimension loading

### MongoDB
- Used as intermediate staging layer
- Organized transformed records prior to warehouse load
- Simulated flexible storage in hybrid environments

---

# 📈 Analytical Query Optimization

Warehouse optimized for aggregation-heavy workloads.

Example:

```sql
SELECT d.year, d.month, SUM(f.amount) AS total_revenue
FROM orders_fact f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
```

KPIs optimized for:

- Monthly Revenue
- Revenue by Store
- Revenue by Film
- Staff Performance

---

# 📊 BI Layer (Power BI)

Dashboards built on top of the warehouse:

- Revenue Overview
- Store Performance
- Film Insights
- Staff Productivity

This simulates executive-level reporting using structured analytical data.

---

# 🛠 Skills Demonstrated

### Data Engineering
- OLTP → OLAP migration
- Snowflake schema modeling
- Fact & dimension design
- ETL pipeline simulation
- Referential integrity validation

### Query Engineering
- Analytical SQL
- Aggregation optimization
- Join reduction strategies
- KPI query tuning

### Hybrid Data Systems
- SQL + MongoDB integration
- Structured + semi-structured data handling
- Staging layer design

### BI Integration
- Power BI dashboard modeling
- KPI metric structuring
- Reporting layer abstraction

---

# 🎯 Engineering Principles Applied

- Separation of transactional and analytical workloads
- Dimensional modeling best practices
- Surrogate key implementation
- Performance-first query design
- Architecture-driven development

---

## 👤 Author

Samuel Nono  
M.S. Data Science  

Data Engineering | Distributed Systems | Applied AI
