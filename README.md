# Sakila Analytics Warehouse  
**OLTP → OLAP Migration | Snowflake Schema Modeling | KPI Optimization**

---

## 🌍 Project Overview

This project transforms the normalized **Sakila OLTP database** into a **Snowflake-style analytical warehouse** optimized for reporting and KPI analysis.

The objective was to simulate a production-grade data engineering workflow:

- Extract transactional data  
- Design dimensional model  
- Build optimized fact table  
- Validate referential integrity  
- Optimize aggregation queries  
- Support BI dashboard analytics  

This project demonstrates how operational systems are converted into structured analytical platforms for decision-making.

---

## 🏗 Architecture Design

### Source System  
Normalized OLTP schema (Sakila)

### Target System  
Snowflake-style OLAP warehouse

### Core Components

**Fact Table**
- `orders_fact`

**Dimension Tables**
- `dim_customer`
- `dim_film`
- `dim_store`
- `dim_staff`
- `dim_date`

---

### 🎯 Why Snowflake Schema?

The Snowflake schema was chosen to:

- Reduce redundancy
- Improve dimensional clarity
- Support hierarchical drill-down queries
- Enable scalable KPI aggregation
- Reflect enterprise BI warehouse patterns

---

## 🔄 OLTP → OLAP Transformation

### 1️⃣ Transactional Flattening

Normalized transactional joins were transformed into measurable analytical events.

Example transformation:

Payments + Customer + Film + Store  
→ Consolidated into `orders_fact`

This reduces repeated joins during analytical queries.

---

### 2️⃣ Fact Table Modeling

`orders_fact` includes:

- `payment_id`
- `customer_id`
- `staff_id`
- `store_id`
- `film_id`
- `date_id`
- `amount`

Optimized for:

- Revenue aggregation  
- Trend analysis  
- Store-level performance tracking  
- Staff productivity metrics  

---

### 3️⃣ Referential Integrity Validation

Simulated ETL validation steps:

- Verified dimension key consistency  
- Checked for orphan fact records  
- Enforced surrogate key alignment  
- Validated foreign key relationships  

These steps mirror real-world data quality enforcement in production pipelines.

---

## 📊 Analytical Query Layer

### Example: Revenue by Month

```sql
SELECT d.year,
       d.month,
       SUM(f.amount) AS total_revenue
FROM orders_fact f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
```

---

### Example: Revenue by Store

```sql
SELECT s.store_name,
       SUM(f.amount) AS revenue
FROM orders_fact f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.store_name
ORDER BY revenue DESC;
```

---

## ⚡ Performance Optimization Strategy

Optimization focused on:

- Fact table aggregation design
- Reduced join complexity
- Dimension indexing
- Query structure efficiency

Compared to OLTP queries:

| Metric | OLTP | OLAP |
|--------|------|------|
| Join Depth | High | Reduced |
| Aggregation Speed | Slower | Faster |
| Reporting Scalability | Limited | Scales for BI |
| Query Readability | Complex | Structured |

---

## 🧠 Engineering Focus

### Data Engineering

- ETL simulation
- Dimensional modeling
- Snowflake schema design
- Fact table optimization
- KPI aggregation

### Analytical Systems

- Revenue analysis
- Store performance metrics
- Film ranking insights
- Staff productivity reporting

---

## 📈 BI Dashboard Integration (Conceptual Layer)

Dashboards designed on top of the warehouse:

- Revenue Overview  
- Store Performance  
- Film Insights  
- Staff KPIs  

This simulates executive-level reporting environments.

---

## 🔍 Architectural Reasoning

This warehouse design:

- Separates operational and analytical workloads
- Optimizes for aggregation-heavy reporting
- Reduces query complexity
- Improves performance under scale
- Reflects enterprise BI architecture patterns

---

## 🚀 Future Enhancements

- Add incremental ETL simulation
- Introduce partitioning strategies
- Implement materialized view optimization
- Add indexing comparison benchmarks
- Connect to live BI dashboard deployment

---

## 👤 Author

Samuel Nono  
M.S. Data Science  

Data Engineering | Distributed Systems | Applied AI  
