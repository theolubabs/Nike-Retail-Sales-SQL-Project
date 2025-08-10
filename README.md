# Nike-Retail-Sales-SQL-Project
SQL was used to clean and analyze a disorganized retail sales dataset. concentrated on creating insights, cleaning data, and exploring it all within MySQL.


![](https://github.com/theolubabs/Nike-Retail-Sales-SQL-Project/blob/main/s-l400.jpg)

## Introduction: 
This project explores a synthetic retail dataset using pure SQL. The dataset mimics real-world Nike sales data and includes key business variables like product lines, discounts, regions, revenue, and profit.

## Key Metrics

•	What is the Total Revenue by product and region

•	What is the Total Profit by product and region

•	Whats are the Units Sold per product line

•	What is the Average Discount applied per region

•	What are the missing value counts and data quality stats

•	What Products records consistent loss in certain regions


## Tools & Concepts Used

•	SQL

•	SQL Server

•	Data Exploration

•	Data Cleaning 

•	Aggregation

This [Dataset](https://www.kaggle.com/datasets/nayakganesh007/nike-sales-uncleaned-dataset) was compiled by NayakGanesh uploaded on Kaggle, it’s a synthetic dataset that simulates retail and online sales transactions from Nike, one of the world's leading sportswear and footwear brands. 
It is intentionally filled with messy, uncleaned records to replicate real world business data perfect for practicing data cleaning, exploratory data analysis (EDA), and building dashboards or portfolio projects.

The objective of this analysis is to explore the dataset, conduct exploratory analysis and also to extract insights related to the synthetic Nike retail sales dataset using only SQL.
The project begins by addressing common data quality issues such as missing values, inconsistent region names, and irregular size or discount entries. 
Once cleaned, the dataset is analyzed at both the product and regional levels to understand performance patterns. It investigates product profitability, sales volume, and discount behavior across different markets. Subsequently, the analysis narrows its focus to identify underperforming products in specific regions, evaluate how discounting strategies affect revenue and profit, and assess which regions and product categories drive the most value. 

# Data Profilling
The dataset contains 2500 rows and 12 columns of transactional sales data for Nike products. It includes 6 categorical variables of the VARCHAR datatype — Order_ID, Gender_Category, Product_Line, Product_Name, Size, Sales_Channel, and Region and 6 numerical/date variables: Units_Sold, MRP (Maximum Retail Price), Discounts_Applied, Revenue, Profit, and Order_Date. 

Several columns contained missing values, with the entire dataset having 5,283 blank entries. After removing rows with null values, the final dataset consists of 1491 clean records ready for analysis. 

Data issues included inconsistent text formatting in categorical fields, anomalies in numerical values such as negative profits and discounts exceeding 100%, and duplicate records that were removed. 

This cleaned dataset now provides a reliable foundation for SQL-based analysis to explore sales performance, assess discount effectiveness, and uncover region-specific product opportunities within Nike’s retail operations.

### Number of Columns
```
SELECT COUNT(*) AS column_count
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'nike';
```
| column_count |
|--------------|
| 13           |

### Number of Rows
```
SELECT COUNT(*) AS row_count
FROM nike;
```
| row_count |
|--------------|
| 1491          |

### Column and data types 
```
SELECT 
    column_name, data_type
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_NAME = 'nike';
```
| column_name        | data_type |
|-------------------|----------- |
| Discount_Applied   | text      |
| Gender_Category    | text      |
| MRP                | int       |
| Order_Date         | date      |
| Order_ID           | int       |
| Product_Line       | text      |
| Product_Name       | text      |
| Profit             | double    |
| Region             | text      |
| Revenue            | int       |
| Sales_Channel      | text      |
| Size               | varchar   |    
| Units_Sold         | int       |  

It was discovered that the MRP, Order_Date, and Units_Sold columns had incorrect data types, so we converted them to their appropriate formats.

### Altering the data type
```
UPDATE nike
SET MRP = REPLACE(MRP, ',', '.');
```

```
ALTER TABLE nike 
MODIFY COLUMN MRP DECIMAL(10,2);
```

```
UPDATE nike
SET Order_Date = STR_TO_DATE(Order_Date, '%d-%m-%y');
```

```
ALTER TABLE nike 
MODIFY COLUMN Order_Date DATE;
```

```
ALTER TABLE nike 
MODIFY COLUMN units_sold INT;
```

### Cleaned Nike Sales Data After cleaning
```
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
    CASE 
        WHEN TRIM(Order_Date) = '' OR Order_Date IS NULL THEN NULL
        ELSE STR_TO_DATE(Order_Date, '%d-%m-%y')
    END AS Order_Date,
    Sales_Channel,
    Region,
    NULLIF(Profit, '') AS Profit
FROM nike;
```
It was discovered that some columns such as Revenue, MRP, Profit, Discount_Applied, and Units_Sold contained NULL values.
The NULL values in the Revenue column were replaced with 0, while the NULL values in the other columns were replaced with their respective averages.

### Replacing NULL Revenue with 0
```
UPDATE nike
SET Revenue = 0
WHERE Revenue IS NULL;
```

### Calculating Average Profit
```
SELECT AVG(Profit) AS Avg_Profit
FROM nike
WHERE Profit IS NOT NULL;
```
### This Fills Null Profit with Average which is 256.42
```
UPDATE nike
SET Profit = 256.42
WHERE Profit IS NULL;
```

### Calculating Average Discount_Applied 
```
SELECT AVG(Discount_Applied) AS Avg_Discount
FROM nike
WHERE Discount_Applied IS NOT NULL;
```

### This Fills Null Discount_Applied with the Average which is 0.63
```
UPDATE nike
SET Discount_Applied = 0.63
WHERE Discount_Applied IS NULL;
```

### Calculating Average MRP
```
SELECT AVG(MRP) AS Avg_MRP
FROM nike
WHERE MRP IS NOT NULL;
```

### This Fills Null MRP with the Average which is 6039.86
```
UPDATE nike
SET MRP = 6039.86
WHERE MRP IS NULL;
```

### Calculating Average Units_Sold
```
SELECT AVG(Units_Sold) AS Avg_Units
FROM nike
WHERE Units_Sold IS NOT NULL;
```

### This Fills Null Units_Sold with the Average which is 2
```
UPDATE nike
SET Units_Sold = 2
WHERE Units_Sold IS NULL;
``` 

It was also discovered that some region names were misspelled, so we corrected them to ensure consistency in the dataset.

### Correcting the error in the Region
```
UPDATE nike
SET Region = 'Hyderabad'
WHERE Region IN ('Hyd', 'hyderbad');
```

```
UPDATE nike
SET Region = 'Bangalore'
WHERE Region = 'bengaluru';
```

### Checking for nulls after cleaning 
```
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
```
| null_order_id | null_gender | null_product_line | null_product_name | null_size | null_units_sold | null_mrp | null_discount | null_revenue  | null_order_date | null_channel | null_region | null_profit  |
|--------------|-------------|-------------------|--------------------|----------------|----------|-----------|----------------|---------------|-----------------|---------------|------------|--------------|
| 0            | 0           | 0                 | 0                  | 0          | 0     | 0      | 0           |0              |0                | 0             |0           |0             |


### Identify most Sold Product 
```
SELECT Product_Name, SUM(Units_Sold) AS total_units
FROM nike
GROUP BY Product_Name
ORDER BY total_units DESC
LIMIT 10;
```
| Product_Name      | total_units   |
|-------------------|-------------- |
| Blazer Mid        | 162           |
| Air Jordan        | 159           |
| SuperRep Go       | 154           |
| React Infinity    | 149           |
| Flex Trainer      | 149           |
| Dunk Low          | 146           |
| Waffle One        | 145           |
| LeBron 20         | 142           |
| Zoom Freak        | 137           |
| Premier III       | 132           |


### Revenue generated by Product Line
```
SELECT Product_Line, ROUND(SUM(Revenue), 2) AS total_revenue
FROM nike
GROUP BY Product_Line
ORDER BY total_revenue DESC;
```
| Product_Line      | total_revenue  |
|-------------------|--------------- |
| Training          | 134754         |
| Lifestyle         | 96176          |
| Soccer            | 95336          |
| Basketball        | 78220          |
| Running           | 23021          |


### Profit generated by region 
```
SELECT Region, ROUND(SUM(Profit), 2) AS total_profit
FROM nike
GROUP BY Region
ORDER BY total_profit DESC;
```
| Region            | total_profit   |
|-------------------|--------------- |
| Mumbai            | 366654.97      |
| Bangalore         | 366361.74      |
| Kolkata           | 358891.36      |
| Hyderabad         | 312566.96      |
| Pune              | 309632.31      |
| Delhi             | 305791.77      |


### Identifying Sales Over Time (Monthly)
```
SELECT 
    DATE_FORMAT(Order_Date, '%Y-%m') AS month,
    SUM(Revenue) AS monthly_revenue,
    SUM(Units_Sold) AS monthly_units
FROM nike
GROUP BY month
ORDER BY month;
```
| month   | monthly_revenue | monthly_units |
| ------- | ---------------- | -------------- |
| 2023-07 | 0                | 8              |
| 2023-08 | 0                | 29             |
| 2023-09 | 21,196           | 29             |
| 2023-10 | 0                | 22             |
| 2023-11 | 5,666            | 33             |
| 2023-12 | 21,587           | 25             |
| 2024-01 | 23,825           | 57             |
| 2024-02 | -112             | 37             |
| 2024-03 | -2,652           | 48             |
| 2024-04 | 0                | 21             |
| 2024-05 | 7,954            | 45             |
| 2024-06 | 158              | 27             |
| 2024-07 | 2,455            | 83             |
| 2024-08 | 21,834           | 188            |
| 2024-09 | 39,833           | 174            |
| 2024-10 | 17,527           | 198            |
| 2024-11 | 44,355           | 205            |
| 2024-12 | 29,280           | 198            |
| 2025-01 | 18,854           | 178            |
| 2025-02 | 18,400           | 143            |
| 2025-03 | 28,335           | 157            |
| 2025-04 | 51,880           | 198            |
| 2025-05 | 29,876           | 209            |
| 2025-06 | 29,051           | 196            |
| 2025-07 | 18,205           | 116            |


### Best Sales Channels
```
SELECT Sales_Channel, COUNT(*) AS total_orders, SUM(Revenue) AS total_revenue
FROM nike
GROUP BY Sales_Channel
ORDER BY total_revenue DESC;
```
| Sales_Channel | total_orders | total_revenue |
|---------------|--------------|---------------|
| Online        | 753          | 225889        |
| Retail        | 734          | 201618        |


### Profitability by Product & Region Showing how each product performs in each region
```
SELECT 
    Product_Name,
    Region,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Name, Region
ORDER BY Total_Profit DESC
LIMIT 10;
```
| Product_Name | Region | Total_Profit |
|--------------|--------|---------------|
| React Infinity | Bangalore | 8457.64 |
| Tiempo Legend |	Delhi |	8218.4 |
| LeBron 20 |	Kolkata	| 7869.96 |
| Air Jordan |	Delhi |	7490.97 |
| Tiempo Legend |	Mumbai |	6515.52 |
| Zoom Freak |	Bangalore	| 5948.6 |
| Air Zoom | Hyderabad |	5835.56 |
| Air Force 1	| Kolkata |	5819.21 |
| Kyrie Flytrap |	Bangalore |	5605.66 |
| Flex Trainer |	Bangalore |	5545.94 |


### Products with Poor Regional Performance showing all product-region combinations where the business is not making profit.
```
SELECT 
    Product_Name,
    Region,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Name, Region
HAVING Total_Profit <= 0
ORDER BY Total_Profit ASC;
```
| Product_Name |	Region |	Total_Profit |
|---------------|---------|---------------|
| Air Zoom |	Delhi	| -1793.63 |
| Waffle One | Mumbai |	-1554.18 |
| Kyrie Flytrap	| Mumbai | -1372.21 |
| Air Jordan	| Kolkata	| -1197.6 |
| Air Zoom	| Pune |	-1121.02 |
| Free RN |	Hyderabad |	-1120.49|
| Kyrie Flytrap |	Hyderabad |	-960.94 |
| Free RN	| Mumbai	| -861.44 |
| LeBron 20 |	Delhi	| -633.81 |
| Premier III	| Delhi	| -506.22 |
| Premier III	| Hyderabad	| -494.53 |
| ZoomX Invincible	| Kolkata |	-445.1 |
| ZoomX Invincible	| Pune	| -440.44 |
| Air Force 1	| Mumbai	| -411.55 |
| Zoom Freak	| Kolkata	| -396.04 |
| Dunk Low	| Bangalore |	-202.12 |
| Air Jordan |	Mumbai	| -175.76 |


### Products by Region with Zero or Negative Profit, taking the discount into consideration
```
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
```
| Product_Name    | Region    | Units_Sold | Total_Profit | Avg_Discount |
| ---------------- | --------- | ----------- | ------------- | ------------- |
| Air Zoom         | Delhi     | 0           | -1793.63      | 0.19          |
| Waffle One       | Mumbai    | 7           | -1554.18      | 0.49          |
| Kyrie Flytrap    | Mumbai    | 1           | -1372.21      | 0.80          |
| Air Jordan       | Kolkata   | 1           | -1197.60      | 1.04          |
| Air Zoom         | Pune      | 4           | -1121.02      | 0.01          |
| Free RN          | Hyderabad | -1          | -1120.49      | 0.66          |
| Kyrie Flytrap    | Hyderabad | 3           | -960.94       | 0.90          |
| Free RN          | Mumbai    | 1           | -861.44       | 0.90          |
| LeBron 20        | Delhi     | 3           | -633.81       | 1.17          |
| Premier III      | Delhi     | 8           | -506.22       | 0.55          |
| Premier III      | Hyderabad | 3           | -494.53       | 0.75          |
| ZoomX Invincible | Kolkata   | 11          | -445.10       | 0.66          |
| ZoomX Invincible | Pune      | 1           | -440.44       | 0.47          |
| Air Force 1      | Mumbai    | 3           | -411.55       | 0.89          |
| Zoom Freak       | Kolkata   | 5           | -396.04       | 0.49          |
| Dunk Low         | Bangalore | 4           | -202.12       | 0.84          |
| Air Jordan       | Mumbai    | 1           | -175.76       | 0.39          |


### Product Line Performance by Region
```
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
```
| Product_Line | Region    | Total_Units_Sold | Total_Revenue | Total_Profit | Avg_Discount |
| ------------- | --------- | ------------------ | -------------- | ------------- | ------------- |
| Basketball    | Bangalore | 6                  | 13882          | 15877.43      | 0.58          |
| Soccer        | Mumbai    | 17                 | 8599           | 15828.81      | 0.71          |
| Soccer        | Pune      | 11                 | 33654          | 14515.09      | 0.47          |
| Running       | Bangalore | 9                  | 13419          | 14117.57      | 0.50          |
| Training      | Mumbai    | 14                 | 43110          | 12784.60      | 0.39          |
| Soccer        | Delhi     | 24                 | 34479          | 12613.71      | 0.62          |
| Training      | Bangalore | 21                 | 40457          | 12371.69      | 0.76          |
| Lifestyle     | Kolkata   | 11                 | 53466          | 10754.51      | 0.45          |
| Soccer        | Kolkata   | 16                 | 28891          | 10602.59      | 0.63          |
| Training      | Kolkata   | 18                 | 41903          | 8967.48       | 0.44          |
| Basketball    | Delhi     | 12                 | 14274          | 8938.59       | 0.90          |
| Training      | Hyderabad | 11                 | 34040          | 6840.78       | 0.65          |
| Basketball    | Kolkata   | 14                 | 46264          | 6276.32       | 0.56          |
| Basketball    | Hyderabad | 19                 | 57271          | 6246.79       | 0.52          |
| Lifestyle     | Bangalore | 11                 | 28982          | 5881.40       | 0.65          |
| Basketball    | Pune      | 5                  | 11915          | 5780.89       | 0.63          |
| Lifestyle     | Pune      | 14                 | 10136          | 5212.63       | 0.79          |
| Lifestyle     | Delhi     | 14                 | 15893          | 4866.99       | 0.80          |
| Running       | Hyderabad | 8                  | 14148          | 4715.07       | 0.63          |
| Soccer        | Bangalore | 4                  | 6008           | 4594.65       | 0.60          |
| Running       | Pune      | 6                  | 36924          | 4069.36       | 0.67          |
| Running       | Delhi     | 5                  | 2831           | 3938.04       | 0.52          |
| Lifestyle     | Hyderabad | 9                  | 15469          | 3937.64       | 0.66          |
| Training      | Pune      | 3                  | 8548           | 3060.03       | 0.43          |
| Basketball    | Mumbai    | 3                  | 11687          | 2206.33       | 0.71          |
| Running       | Kolkata   | 0                  | -1922          | 2152.09       | 0.42          |
| Training      | Delhi     | 18                 | 27496          | 1810.74       | 0.75          |
| Running       | Mumbai    | 3                  | 6677           | 1669.29       | 0.64          |
| Lifestyle     | Mumbai    | 10                 | 24926          | 1364.68       | 0.53          |
| Soccer        | Hyderabad | 3                  | 3761           | -494.53       | 0.75          |


### Identify which category-region combinations were consistently losing money
```
SELECT 
    Product_Line,
    Region,
    CONCAT('Q', QUARTER(Order_Date), '-', YEAR(Order_Date)) AS Quarter,
    SUM(Profit) AS Total_Profit
FROM sales_data
GROUP BY Product_Line, Region, Quarter
HAVING Total_Profit <= 0
ORDER BY Quarter, Total_Profit;
```
| Product\_Line | Region    | Quarter | Total\_Profit |
| ------------- | --------- | ------- | ------------- |
| Lifestyle     | Pune      | Q1-2030 | -874.96       |
| Lifestyle     | Mumbai    | Q1-2000 | -227.68       |
| Running       | Delhi     | Q1-2001 | -687.56       |
| Lifestyle     | Pune      | Q1-2008 | -780.66       |
| Running       | Kolkata   | Q1-2010 | -238.90       |
| Lifestyle     | Pune      | Q1-2012 | -882.96       |
| Soccer        | Pune      | Q1-2015 | -514.90       |
| Basketball    | Mumbai    | Q1-2018 | -175.76       |
| Lifestyle     | Delhi     | Q1-2022 | -776.21       |
| Basketball    | Mumbai    | Q1-2026 | -1011.68      |
| Training      | Delhi     | Q1-2027 | -746.28       |
| Training      | Hyderabad | Q1-2030 | -757.47       |
| Soccer        | Delhi     | Q1-2030 | -673.94       |
| Training      | Mumbai    | Q2-2007 | -259.55       |
| Soccer        | Pune      | Q2-2008 | -1067.96      |
| Training      | Kolkata   | Q2-2008 | -615.48       |
| Lifestyle     | Hyderabad | Q2-2012 | -665.22       |
| Running       | Mumbai    | Q2-2014 | -861.44       |
| Training      | Bangalore | Q2-2016 | -68.53        |
| Soccer        | Bangalore | Q2-2019 | -1152.86      |
| Soccer        | Bangalore | Q2-2030 | -1076.72      |
| Running       | Delhi     | Q3-2008 | -1106.07      |
| Lifestyle     | Mumbai    | Q3-2014 | -642.02       |
| Lifestyle     | Hyderabad | Q3-2026 | -1199.45      |
| Training      | Mumbai    | Q4-2002 | -1076.66      |
| Basketball    | Kolkata   | Q4-2004 | -823.80       |
| Training      | Pune      | Q4-2007 | -440.44       |
| Training      | Bangalore | Q4-2011 | -855.08       |
| Basketball    | Hyderabad | Q4-2012 | -751.05       |
| Lifestyle     | Bangalore | Q4-2012 | -202.12       |
| Basketball    | Hyderabad | Q4-2014 | -960.94       |
| Running       | Hyderabad | Q4-2019 | -1120.49      |
| Basketball    | Mumbai    | Q4-2024 | -360.53       |
| Soccer        | Hyderabad | Q4-2026 | -494.53       |


### Connect with me on socials:
[Linkedln](https://www.linkedin.com/in/babatunde-oluwatimilehin/)

[Twitter](https://x.com/theolu_babs)

[Github](https://github.com/theolubabs)


