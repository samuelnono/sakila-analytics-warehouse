# Power BI Layer (Reporting)

This project’s final layer is the BI dashboard layer, where OLAP tables are used to generate KPI reporting.

## Data Source
The Power BI model is designed to connect to the warehouse tables:

- `fact_orders`
- `dim_date`
- `dim_customer`
- `dim_film`

## KPI Examples (Portfolio Targets)
- Monthly Revenue Trend
- Revenue by Store
- Revenue by Film
- Staff Performance (optional extension)

## Why This Matters
This matches a real analytics workflow:

OLTP systems are optimized for transactions, while dashboards require fast aggregations and stable dimensional modeling.

This repo demonstrates that shift by building an OLAP-ready schema first, then validating it with analytical SQL.
