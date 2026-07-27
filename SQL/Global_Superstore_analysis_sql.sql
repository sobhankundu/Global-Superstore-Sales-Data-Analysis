/*====================================================================
                    GLOBAL SUPERSTORE SALES ANALYSIS

Author      : Sobhan Kundu
Project     : Global Superstore Sales Analysis
Tools Used  : MySQL, Python, Power BI

Description:
This SQL script is part of an end-to-end data analytics project that
analyzes Global Superstore sales data. The script covers database
creation, data import, validation, KPI calculations, business analysis,
and customer/product insights.

====================================================================*/


/*====================================================================
1. Database Setup
====================================================================*/
use global_superstore;

show tables;

CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(30),
    customer_name VARCHAR(150),
    segment VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    market VARCHAR(50),
    region VARCHAR(100),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2),
    shipping_cost DECIMAL(12,2),
    order_priority VARCHAR(30),
    order_year INT,
    order_month VARCHAR(20),
    order_quarter INT,
    shipping_days INT
);

desc orders;

/*====================================================================
2. Data Import
====================================================================*/
LOAD DATA LOCAL INFILE 'C:/Users/SOBHAN KUNDU/Global_Superstore_Cleaned.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
row_id,
order_id,
@order_date,
@ship_date,
ship_mode,
customer_id,
customer_name,
segment,
city,
state,
country,
postal_code,
market,
region,
product_id,
category,
sub_category,
product_name,
sales,
quantity,
discount,
profit,
shipping_cost,
order_priority,
order_year,
order_month,
order_quarter,
shipping_days
)
SET
order_date = STR_TO_DATE(@order_date,'%Y-%m-%d'),
ship_date = STR_TO_DATE(@ship_date,'%Y-%m-%d');

/*====================================================================
3. Data Validation
====================================================================*/

select * from orders limit 10;
select count(*) from orders;

/*====================================================================
4. KPI Calculation 
====================================================================*/
-- total sales , profit and total no. of orders
select 
	sum(sales) as Total_Sales,
    sum(profit)as Total_Profit,
    count(distinct order_id)as Total_Orders
from orders;


SELECT * from orders LIMIT 10;

/*====================================================================
5. Product Analysis
====================================================================*/
-- Top Selling Product
select product_id,product_name,sum(sales) as total_sales FROM orders GROUP BY product_id,product_name order by total_sales desc LIMIT 1;

-- Most Profitable Product
select product_id,product_name,sum(profit) as total_profit FROM orders GROUP BY product_id,product_name order by total_profit desc LIMIT 1;

-- Least Profitable Product
select product_id,product_name,sum(profit)  FROM orders GROUP BY product_id,product_name order by sum(profit) asc LIMIT 1;

-- Market Wise Total Profit
SELECT market,sum(profit) from orders GROUP BY market order by SUM(profit) desc limit 1; 

/*====================================================================
6. Sales Analysis
====================================================================*/
-- Yearly Sales
SELECT order_year, sum(sales) as Yearly_sales from orders group by order_year order by order_year asc;

-- Monthly Sales
SELECT order_month, SUM(sales) as Monthly_sales FROM orders group by order_month ;

-- Quaterly Sales
SELECT order_quarter, SUM(sales) as quaterly_sales FROM orders group by order_quarter order by order_quarter asc ;

-- Highest Sales Month
SELECT order_month ,sum(sales) as highest_sales from orders group by order_month order by highest_sales desc limit 1;

/*====================================================================
7. Profit Analysis
====================================================================*/
-- Highest Profit Year
SELECT order_year, SUM(profit) as highest_profit from orders group by order_year order by highest_profit desc limit 1;

-- Yearly Profit
SELECT order_year , SUM(profit) as Yearly_profit from orders group by order_year order by order_year asc;

-- Market with Highest Profit
SELECT market, SUM(profit) AS Total_Profit FROM orders GROUP BY market ORDER BY Total_Profit DESC LIMIT 1;

-- Average Profit by Category
SELECT category, AVG(profit) AS Average_Profit FROM orders GROUP BY category HAVING AVG(profit)>50;

/*====================================================================
6. Customer & Market Analysis
====================================================================*/
-- Countries with Sales above 500K
SELECT country , sum(sales) FROM orders GROUP BY country HAVING SUM(sales) > 500000;

-- Orders by Market
SELECT market , count(distinct(order_id)) as Total_orders from orders GROUP BY  market having Total_orders > 2000;

-- Profit by Segment
SELECT segment,SUM(profit) FROM orders GROUP BY segment having SUM(profit) > 100000;

/*====================================================================
9. Discount Analysis
====================================================================*/
-- Average Discount by Category
SELECT category, AVG(discount) from orders GROUP BY category  having avg(discount) > 0.05;

/*====================================================================
10. Business Classification using CASE
====================================================================*/
-- Sales Classification
SELECT order_id,sales, 
CASE 
    WHEN sales > 1000 THEN 'High Sales'
    WHEN sales >= 500  THEN 'Medium Sales'	
    ELSE 'Low Sales'
END AS Order_Classificatin FROM orders ;

-- Profit Classification
SELECT order_id ,profit ,
CASE 
	WHEN profit > 0 THEN 'Profit'
  WHEN profit = 0 THEN 'Break Even'
	ELSE 'Loss'
END AS Profit_Classification from orders;

-- Discount Classification
SELECT order_id,discount,
CASE
  WHEN discount = 0.00 THEN 'No Discount'
  WHEN discount BETWEEN 0.01 AND 0.20 THEN 'Low Discount'
  ELSE 'High Discount'
  END AS Discount_classification From Orders;

/*====================================================================
11. Advanced Business Analysis
====================================================================*/
-- Top 10 Customers by Sales
SELECT
    customer_id,
    customer_name,
    SUM(sales) AS Total_Sales
FROM orders
GROUP BY customer_id, customer_name
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 10 Products by Profit
SELECT
    product_id,
    product_name,
    SUM(profit) AS Total_Profit
FROM orders
GROUP BY product_id, product_name
ORDER BY Total_Profit DESC
LIMIT 10;

-- Sales by Category
SELECT
    category,
    SUM(sales) AS Total_Sales
FROM orders
GROUP BY category
ORDER BY Total_Sales DESC;

-- Profit by Sub-Category
SELECT
    sub_category,
    SUM(profit) AS Total_Profit
FROM orders
GROUP BY sub_category
ORDER BY Total_Profit DESC;

-- Average Shipping Cost by Ship Mode
SELECT
    ship_mode,
    AVG(shipping_cost) AS Average_Shipping_Cost
FROM orders
GROUP BY ship_mode
ORDER BY Average_Shipping_Cost DESC;

-- Top 10 Countries by Profit
SELECT
    country,
    SUM(profit) AS Total_Profit
FROM orders
GROUP BY country
ORDER BY Total_Profit DESC
LIMIT 10;

-- Top 5 Cities by Sales
SELECT
    city,
    SUM(sales) AS Total_Sales
FROM orders
GROUP BY city
ORDER BY Total_Sales DESC
LIMIT 5;

-- Sales by Customer Segment
SELECT
    segment,
    SUM(sales) AS Total_Sales
FROM orders
GROUP BY segment
ORDER BY Total_Sales DESC;

-- Average Order Value (AOV)
SELECT
    ROUND(
        SUM(sales) / COUNT(DISTINCT order_id),
        2
    ) AS Average_Order_Value
FROM orders;

-- Profit Margin by Category
SELECT
    category,
    ROUND(
        (SUM(profit) / SUM(sales)) * 100,
        2
    ) AS Profit_Margin_Percentage
FROM orders
GROUP BY category
ORDER BY Profit_Margin_Percentage DESC;

-- Top 10 Customers by Profit
SELECT
    customer_id,
    customer_name,
    SUM(profit) AS Total_Profit
FROM orders
GROUP BY customer_id, customer_name
ORDER BY Total_Profit DESC
LIMIT 10;

/*====================================================================
12. Business Summary
====================================================================*/  
-- Order Classification Summary
SELECT 
CASE 
    WHEN sales > 1000 THEN 'High Sales'
    WHEN sales >= 500  THEN 'Medium Sales'	
    ELSE 'Low Sales'
END AS Order_Classification ,count(*) AS total_orders FROM orders GROUP BY Order_Classification;

-- Profit Status Summary
SELECT
CASE 
	WHEN profit > 0 THEN 'Profit'
  WHEN profit = 0 THEN 'Break Even'
	ELSE 'Loss'
END AS Profit_Status , SUM(sales) as total_sales  from orders GROUP BY Profit_Status;
  


