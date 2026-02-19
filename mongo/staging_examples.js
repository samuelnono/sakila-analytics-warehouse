/*
MongoDB Staging Layer - Example Queries
--------------------------------------

Collection: sakila_staging.payments_staging

Purpose:
Show how MongoDB can be used as a staging / intermediate layer
for exploratory analysis before loading into a SQL warehouse.
*/

// Switch DB (Mongo Shell)
use sakila_staging;

// Basic sanity check
db.payments_staging.findOne();

// Example 1: Total revenue by store
db.payments_staging.aggregate([
  { $group: { _id: "$store_id", total_revenue: { $sum: "$amount" } } },
  { $sort: { total_revenue: -1 } }
]);

// Example 2: Revenue by rating
db.payments_staging.aggregate([
  { $group: { _id: "$film.rating", total_revenue: { $sum: "$amount" } } },
  { $sort: { total_revenue: -1 } }
]);

// Example 3: Most common customers by total spend
db.payments_staging.aggregate([
  { $group: { _id: "$customer_id", total_spend: { $sum: "$amount" } } },
  { $sort: { total_spend: -1 } },
  { $limit: 10 }
]);

