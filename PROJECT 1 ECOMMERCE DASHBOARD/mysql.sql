CREATE DATABASE olist;
USE olist;

-- KPI 1
SELECT CASE
WHEN dayofweek(o.order_purchase_timestamp) IN (1,7) THEN "Weekend"
ELSE "Weekday"
END AS Weekend_Weekday_payments,
ROUND(sum(p.payment_value),2) AS Total_payments,
ROUND(sum(p.payment_value)/(SELECT sum(payment_value)FROM olist_order_payments_dataset)*100,2) AS payment_percentage
FROM olist_orders_dataset AS o
JOIN olist_order_payments_dataset AS p
ON o.order_id = p.order_id
GROUP BY Weekend_Weekday_payments;

-- KPI 2
SELECT count(distinct order_id) AS Number_of_orders , review_score , payment_type
FROM olist_order_reviews_dataset 
JOIN olist_order_payments_dataset 
USING(order_id)
WHERE review_score = 5
AND payment_type = "credit_card"
GROUP BY review_score , payment_type;

-- KPI 3
SELECT product_category_name, 
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) AS avg_delivery_days
FROM olist_orders_dataset
JOIN olist_order_items_dataset USING(order_id)
JOIN olist_products_dataset USING(product_id)
WHERE product_category_name = "pet_shop"
GROUP BY product_category_name;

-- KPI 4
SELECT c.customer_city , round(avg(i.price),0)  AS Avg_price , round(avg(p.payment_value),0) AS Avg_paymentvalue
FROM olist_customers_dataset c
JOIN olist_orders_dataset o ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_order_payments_dataset p ON i.order_id = p.order_id
WHERE c.customer_city = "sao paulo"
GROUP BY c.customer_city;

-- KPI 5 
SELECT
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp)),0) AS Avg_shipping_days,
review_score
FROM olist_orders_dataset
JOIN olist_order_reviews_dataset USING(order_id)
GROUP BY review_score;

-- KPI 6
SELECT 
   concat(round(sum(CASE
     WHEN order_delivered_customer_date > order_estimated_delivery_date
     THEN 1 ELSE 0
     END) *100/count(*),2),"%") AS late_delivery_percentage
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;
	

-- KPI 7 
SELECT pr.product_category_name AS Product_Category , round(sum(pa.payment_value),2) AS Total_revenue
FROM olist_products_dataset pr
JOIN olist_order_items_dataset oi ON pr.product_id = oi.product_id
JOIN olist_order_payments_dataset pa ON pa.order_id = oi.order_id
GROUP BY pr.product_category_name
ORDER BY Total_revenue DESC
LIMIT 5;


-- KPI 8
SELECT p.payment_type AS Payment_type , 
round(sum(CASE
   WHEN oi.freight_value = 0 THEN 1 ELSE 0 END)*100/count(distinct o.order_id),2) AS free_shipping_percentage
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
JOIN olist_order_items_dataset oi ON p.order_id = oi.order_id
GROUP BY p.payment_type;























