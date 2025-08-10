-- Data Cleaning 
ALTER TABLE nike
CHANGE `ï»¿Order_ID` Order_ID INT;

-- Handling blanks, Cleaning date format and pulling selected columns from nike table
SELECT 
    Order_ID,
    Gender_Category,
    Product_Line,
    Product_Name,
    Size,
    NULLIF(Units_Sold, '') AS Units_Sold,
    NULLIF(MRP, '') AS MRP,
    NULLIF(Discount_Applied, '') AS Discount_Applied,
    NULLIF(Revenue, '') AS Revenue,
    STR_TO_DATE(NULLIF(Order_Date, ''), '%Y-%m-%d') AS Order_Date,
    Sales_Channel,
    Region,
    NULLIF(Profit, '') AS Profit
FROM nike;

-- Replacing NULL Revenue with 0
UPDATE nike
SET Revenue = 0
WHERE Revenue IS NULL;

-- Calculating Average Profit
SELECT AVG(Profit) AS Avg_Profit
FROM nike
WHERE Profit IS NOT NULL;

-- This Fills Null Profit with Average which is 256.42
UPDATE nike
SET Profit = 256.42
WHERE Profit IS NULL;

-- Calculating Average Discount_Applied 
SELECT AVG(Discount_Applied) AS Avg_Discount
FROM nike
WHERE Discount_Applied IS NOT NULL;

-- This Fills Null Discount_Applied with the Average which is 0.63
UPDATE nike
SET Discount_Applied = 0.63
WHERE Discount_Applied IS NULL;

-- Calculating Average MRP 
SELECT AVG(MRP) AS Avg_MRP
FROM nike
WHERE MRP IS NOT NULL;

-- This Fills Null MRP with the Average which is 6039.86
UPDATE nike
SET MRP = 6039.86
WHERE MRP IS NULL;

-- Calculating Average Units_Sold
SELECT AVG(Units_Sold) AS Avg_Units
FROM nike
WHERE Units_Sold IS NOT NULL;

-- This Fills Null Units_Sold with the Average which is 2
UPDATE nike
SET Units_Sold = 2
WHERE Units_Sold IS NULL;

-- Correcting the error in the Region
UPDATE nike
SET Region = 'Hyderabad'
WHERE Region IN ('Hyd', 'hyderbad');

UPDATE nike
SET Region = 'Bangalore'
WHERE Region = 'bengaluru';

-- Exploratory Analysis
	DESCRIBE nike;

-- Getting the total row count
SELECT 
    COUNT(*) AS total_rows
FROM
    nike;

-- Checking the Null count per column
SELECT 
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN Gender_Category IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN Product_Line IS NULL THEN 1 ELSE 0 END) AS null_product_line,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN Size IS NULL THEN 1 ELSE 0 END) AS null_size,
    SUM(CASE WHEN Units_Sold IS NULL THEN 1 ELSE 0 END) AS null_units_sold,
    SUM(CASE WHEN MRP IS NULL THEN 1 ELSE 0 END) AS null_mrp,
    SUM(CASE WHEN Discount_Applied IS NULL THEN 1 ELSE 0 END) AS null_discount,
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS null_revenue,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN Sales_Channel IS NULL THEN 1 ELSE 0 END) AS null_channel,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_profit
FROM nike;


-- Most Sold Product 
SELECT Product_Name, SUM(Units_Sold) AS total_units
FROM nike
GROUP BY Product_Name
ORDER BY total_units DESC
LIMIT 10;

-- Revenue Product Line(Product Line that generates the highest revenue)
SELECT Product_Line, ROUND(SUM(Revenue), 2) AS total_revenue
FROM nike
GROUP BY Product_Line
ORDER BY total_revenue DESC;

-- Profit by region (Regions that generates the highest profit)
SELECT Region, ROUND(SUM(Profit), 2) AS total_profit
FROM nike
GROUP BY Region
ORDER BY total_profit DESC;

-- Sales Over Time (Monthly)
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS month,
    SUM(Revenue) AS monthly_revenue,
    SUM(Units_Sold) AS monthly_units
FROM nike
GROUP BY month
ORDER BY month;


-- Best Sales Channels
SELECT Sales_Channel, COUNT(*) AS total_orders, SUM(Revenue) AS total_revenue
FROM nike
GROUP BY Sales_Channel
ORDER BY total_revenue DESC;


-- Discount Applied
SELECT 
    ROUND(AVG(Discount_Applied), 2) AS avg_discount
FROM
    nike;


--  Profitability by Product & Region (Shows how each product performs in each region)
SELECT 
    Product_Name,
    Region,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Name, Region
ORDER BY Total_Profit DESC;


-- Products with Poor Regional Performance (It shows alll product-region combinations where the business is not making profit.)
SELECT 
    Product_Name,
    Region,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Name, Region
HAVING Total_Profit <= 0
ORDER BY Total_Profit ASC;


-- Analysing the Sales Volume Context to determinre factors affecting low sales (If Units_Sold is low, it’s likely a product mismatch for that region, 
-- If Units_Sold is high but profit is negative, probably discounting is too much.)
SELECT 
    Product_Name,
    Region,
    SUM(Units_Sold) AS Units_Sold,
    SUM(Profit) AS Total_Profit,
    ROUND(AVG(Discount_Applied), 2) AS Avg_Discount
FROM sales_data
GROUP BY Product_Name, Region
HAVING Total_Profit <= 0
ORDER BY Total_Profit ASC;

--  Group Products by Category Product_Line, Region, Unit_Sold, Revenue, Profit, Discount (To identify which product line performs best in which region 
-- and also identify where a category is failling)
SELECT 
    Product_Line,
    Region,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit,
    ROUND(AVG(Discount_Applied), 2) AS Avg_Discount
FROM sales_data
GROUP BY Product_Line, Region
ORDER BY Total_Profit DESC;


-- To identify how each category in each region performed across quarters
SELECT 
    Product_Line,
    Region,
    CONCAT('Q', QUARTER(Order_Date), '-', YEAR(Order_Date)) AS Quarter,
    SUM(Units_Sold) AS Total_Units_Sold,
    SUM(Revenue) AS Total_Revenue,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Line, Region, Quarter
ORDER BY Quarter, Region, Product_Line;

-- identify which category-region combinations were consistently losing money
SELECT 
    Product_Line,
    Region,
    CONCAT('Q', QUARTER(Order_Date), '-', YEAR(Order_Date)) AS Quarter,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Line, Region, Quarter
HAVING Total_Profit <= 0
ORDER BY Quarter, Total_Profit;








