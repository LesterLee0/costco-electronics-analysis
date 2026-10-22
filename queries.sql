USE costco_electronics;
SELECT COUNT(*) FROM products;
SELECT COUNT(DISTINCT product_id) FROM products;

-- Q1: Which sub categories have the most products?
SELECT sub_category, COUNT(*) AS product_count
FROM products
GROUP BY sub_category
ORDER BY product_count DESC;

-- Q2: Which sub categories are the most expensive on average?
SELECT sub_category,
       COUNT(*) AS product_count,
       ROUND(AVG(price), 2) AS avg_price
FROM products
GROUP BY sub_category
HAVING COUNT(*) >= 5
ORDER BY avg_price DESC;

-- Q3: Which sub categories get discounted the most?
SELECT sub_category,
       COUNT(*) AS product_count,
       SUM(CASE WHEN discount_amount > 0 THEN 1 ELSE 0 END) AS discounted_products,
       ROUND(100 * SUM(CASE WHEN discount_amount > 0 THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_discounted
FROM products
GROUP BY sub_category
HAVING COUNT(*) >= 5
ORDER BY pct_discounted DESC;

-- Why do TVs show 0% discounted?
SELECT discount_type, COUNT(*) AS product_count
FROM products
WHERE sub_category = 'TVs'
GROUP BY discount_type;

-- Q3b: Which sub categories have any kind of promotion?
-- Counts Dollars Off, Limited Time Price, and Free Shipping
SELECT sub_category,
       COUNT(*) AS product_count,
       SUM(CASE WHEN discount_type <> 'No Discount' THEN 1 ELSE 0 END) AS promo_products,
       ROUND(100 * SUM(CASE WHEN discount_type <> 'No Discount' THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_promo
FROM products
GROUP BY sub_category
HAVING COUNT(*) >= 5
ORDER BY pct_promo DESC;

-- Q4: Do more expensive products get better ratings?
WITH unique_products AS (
    SELECT DISTINCT product_id, price, rating, review_count
    FROM products
)
SELECT CASE
           WHEN price < 100  THEN '1. Under $100'
           WHEN price < 500  THEN '2. $100 to $499'
           WHEN price < 1000 THEN '3. $500 to $999'
           WHEN price < 2000 THEN '4. $1,000 to $1,999'
           ELSE '5. $2,000 and up'
       END AS price_band,
       COUNT(*) AS product_count,
       ROUND(AVG(rating), 2) AS avg_rating
FROM unique_products
WHERE review_count >= 10
GROUP BY price_band
ORDER BY price_band;

-- Q5: What are the top 20 highest rated products?
SELECT DISTINCT product_id, title, price, rating, review_count
FROM products
WHERE review_count >= 100
ORDER BY rating DESC, review_count DESC
LIMIT 20;