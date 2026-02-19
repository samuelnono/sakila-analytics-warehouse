/*
=========================================================
Sakila Analytics Warehouse
ETL Simulation Script (OLTP → OLAP Transformation)
=========================================================

Purpose:
Simulate a production-style ETL process that transforms
the normalized Sakila OLTP schema into a Snowflake-style
analytical warehouse.

Pipeline:
MySQL (Sakila) → SQL Extraction → Warehouse Tables
(Optional: Python + MongoDB staging handled separately)
=========================================================
*/


-- =====================================================
-- 1. CREATE TARGET WAREHOUSE TABLES
-- =====================================================

-- -------------------------
-- Dimension: Date
-- -------------------------
CREATE TABLE IF NOT EXISTS dim_date (
    date_key    INT PRIMARY KEY,      -- YYYYMMDD format
    full_date   DATE NOT NULL,
    year_num    INT NOT NULL,
    month_num   INT NOT NULL,
    day_num     INT NOT NULL
);


-- -------------------------
-- Dimension: Customer
-- -------------------------
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    store_id     INT NOT NULL,
    active       INT NOT NULL
);


-- -------------------------
-- Dimension: Film
-- -------------------------
CREATE TABLE IF NOT EXISTS dim_film (
    film_key INT PRIMARY KEY,
    film_id  INT NOT NULL,
    title    VARCHAR(255) NOT NULL,
    rating   VARCHAR(16)
);


-- -------------------------
-- Fact Table: Orders / Payments
-- -------------------------
CREATE TABLE IF NOT EXISTS fact_orders (
    order_fact_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    date_key      INT NOT NULL,
    customer_key  INT NOT NULL,
    film_key      INT NOT NULL,
    store_id      INT NOT NULL,
    staff_id      INT NOT NULL,
    rental_id     INT NOT NULL,
    payment_id    INT NOT NULL,
    amount        DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_fact_date
        FOREIGN KEY (date_key)
        REFERENCES dim_date(date_key),

    CONSTRAINT fk_fact_customer
        FOREIGN KEY (customer_key)
        REFERENCES dim_customer(customer_key),

    CONSTRAINT fk_fact_film
        FOREIGN KEY (film_key)
        REFERENCES dim_film(film_key)
);


-- =====================================================
-- 2. INDEXING FOR ANALYTICAL PERFORMANCE
-- =====================================================

CREATE INDEX idx_fact_date
    ON fact_orders(date_key);

CREATE INDEX idx_fact_customer
    ON fact_orders(customer_key);

CREATE INDEX idx_fact_store_date
    ON fact_orders(store_id, date_key);


-- =====================================================
-- 3. POPULATE DIMENSIONS (ETL SIMULATION)
-- =====================================================

-- -------------------------
-- Date Dimension
-- -------------------------
INSERT IGNORE INTO dim_date
(date_key, full_date, year_num, month_num, day_num)
SELECT
    (YEAR(p.payment_date) * 10000)
    + (MONTH(p.payment_date) * 100)
    + DAY(p.payment_date) AS date_key,
    DATE(p.payment_date),
    YEAR(p.payment_date),
    MONTH(p.payment_date),
    DAY(p.payment_date)
FROM payment p;


-- -------------------------
-- Customer Dimension
-- -------------------------
INSERT IGNORE INTO dim_customer
(customer_key, customer_id, store_id, active)
SELECT
    c.customer_id,
    c.customer_id,
    c.store_id,
    c.active
FROM customer c;


-- -------------------------
-- Film Dimension
-- -------------------------
INSERT IGNORE INTO dim_film
(film_key, film_id, title, rating)
SELECT
    f.film_id,
    f.film_id,
    f.title,
    f.rating
FROM film f;


-- =====================================================
-- 4. POPULATE FACT TABLE
-- =====================================================

/*
Join path:
payment → rental → inventory → film
payment → customer → staff
*/

INSERT INTO fact_orders
(date_key, customer_key, film_key, store_id,
 staff_id, rental_id, payment_id, amount)

SELECT
    (YEAR(p.payment_date) * 10000)
    + (MONTH(p.payment_date) * 100)
    + DAY(p.payment_date) AS date_key,
    c.customer_id AS customer_key,
    f.film_id     AS film_key,
    c.store_id,
    p.staff_id,
    r.rental_id,
    p.payment_id,
    p.amount

FROM payment p
JOIN customer c  ON p.customer_id = c.customer_id
JOIN rental r    ON r.rental_id = p.rental_id
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film f      ON f.film_id = i.film_id;


-- =====================================================
-- 5. VALIDATION QUERIES
-- =====================================================

-- Row counts
SELECT 'dim_date' AS table_name, COUNT(*) FROM dim_date
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM dim_customer
UNION ALL
SELECT 'dim_film', COUNT(*) FROM dim_film
UNION ALL
SELECT 'fact_orders', COUNT(*) FROM fact_orders;


-- Example OLAP Query: Revenue by Month
SELECT
    d.year_num,
    d.month_num,
    SUM(f.amount) AS total_revenue
FROM fact_orders f
JOIN dim_date d ON f.date_key = d.date_key
GROUP BY d.year_num, d.month_num
ORDER BY d.year_num, d.month_num;
