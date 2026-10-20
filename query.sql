use restaurant_db;

--
SELECT 
    *
FROM
    menu_items;

--
SELECT 
    *
FROM
    order_details
LIMIT 10;

--
SELECT 
    COUNT(*) AS total_records
FROM
    order_details;
    
--
describe order_details;
--
describe menu_items;

-- 1. How many items are on the menu?
SELECT 
    COUNT(*) AS total_menu_items
FROM
    menu_items;


-- What are the least and most expensive items?
SELECT 
    MAX(price) AS highest_price, MIN(price) AS lowest_price
FROM
    menu_items;

SELECT 
    item_name, category, price
FROM
    menu_items
WHERE
    price = (SELECT 
            MAX(price)
        FROM
            menu_items);


SELECT 
    item_name, category, price
FROM
    menu_items
WHERE
    price = (SELECT 
            MIN(price)
        FROM
            menu_items);


-- How many Italian dishes are on the menu, and what are their lowest and highest prices?

SELECT 
    COUNT(*) AS total_italian_items,
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM
    menu_items
WHERE
    category LIKE '%Italian%';

--
SELECT 
    item_name, price
FROM
    menu_items
WHERE
    category = 'Italian'
        AND price = (SELECT 
            MIN(price)
        FROM
            menu_items
        WHERE
            category = 'Italian');
            
--
SELECT 
    item_name, price
FROM
    menu_items
WHERE
    category = 'Italian'
        AND price = (SELECT 
            MAX(price)
        FROM
            menu_items
        WHERE
            category = 'Italian');

-- How many dishes are in each category, and what is the average price?
-- Calculate the number of dishes and average price per category
SELECT 
    category,
    COUNT(*) AS total_dishes,
    ROUND(AVG(price), 2) AS average_price
FROM
    menu_items
GROUP BY category
ORDER BY total_dishes DESC;


--
DESCRIBE order_details;
--
SELECT *
FROM order_details
LIMIT 10;

--
-- What is the date range of the table?
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM
    order_details;
    
-- How many orders were made, and how many items were ordered?
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(item_id) AS total_items_ordered
FROM
    order_details;

-- Which orders had the most items?
-- Find orders with the most items
SELECT
    order_id,
    COUNT(item_id) AS total_items
FROM order_details
GROUP BY order_id
ORDER BY total_items DESC
LIMIT 10;

-- How many orders had more than 12 items?
SELECT 
    COUNT(*) AS total_orders_12
FROM
    (SELECT 
        order_id, COUNT(item_id) AS total_items
    FROM
        order_details
    GROUP BY order_id
    HAVING total_items > 12) AS large_orders;
    
    
SELECT
    COUNT(*) AS orders_with_more_than_12_items
FROM (
    SELECT
        order_id,
        COUNT(item_id) AS total_items
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
) AS large_orders;


-- Which menu items were ordered most frequently?
SELECT 
    mi.item_name,
    mi.category,
    COUNT(od.item_id) AS times_ordered
FROM
    order_details AS od
        JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY mi.menu_item_id , mi.item_name , mi.category
ORDER BY times_ordered DESC
LIMIT 10;

-- Which menu items were ordered least frequently?
SELECT 
    mi.item_name,
    mi.category,
    COUNT(od.item_id) AS times_ordered
FROM
    menu_items AS mi
        LEFT JOIN
    order_details AS od ON mi.menu_item_id = od.item_id
GROUP BY mi.menu_item_id , mi.item_name , mi.category
ORDER BY times_ordered ASC , mi.item_name ASC
LIMIT 10;


-- Find the Five Highest-Spending Orders

SELECT 
    od.order_id, ROUND(SUM(mi.price), 2) AS order_total
FROM
    order_details AS od
        JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
GROUP BY od.order_id
ORDER BY order_total DESC
LIMIT 5;










