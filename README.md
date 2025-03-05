# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis    
**Database**: `sql_project_1`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL queries to extract meaningful insights from sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `sql_project_1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sql_project_1;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE, 
    sale_time TIME,
    customer_id INT, 
    gender VARCHAR(10),
    age INT,
    category VARCHAR(30),
    quantity INT,
    price_per_unit FLOAT, 
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

#### Retrieve all columns for sales made on '2022-11-01'
```sql
SELECT * FROM retail_sales WHERE sale_date = '2022-11-01';
```

#### Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

#### Calculate the total sales (total_sale) for each category
```sql
SELECT category, SUM(total_sale) AS total_sales FROM retail_sales GROUP BY category;
```

#### Find the average age of customers who purchased items from the 'Beauty' category
```sql
SELECT gender, AVG(age) AS avg_age FROM retail_sales WHERE category = 'Beauty' GROUP BY gender;
```

#### Find all transactions where the total_sale is greater than 1000
```sql
SELECT transactions_id, customer_id, age, gender FROM retail_sales WHERE total_sale >= 1000;
```

#### Find the total number of transactions (transaction_id) made by each gender in each category
```sql
SELECT category, gender, COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, total_transactions DESC;
```

#### Calculate the average sale for each month. Find out the best selling month in each year
```sql
WITH MonthlySales AS (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale) AS avg_total_sale,
           RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
)
SELECT * FROM MonthlySales WHERE rank = 1;
```

#### Find the top 5 customers based on the highest total sales
```sql
SELECT customer_id, gender, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id, gender
ORDER BY total_sales DESC
LIMIT 5;
```

#### Find the number of unique customers who purchased items from each category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

#### Create each shift and number of orders (Morning <12, Afternoon 12-17, Evening >17)
```sql
WITH hourly_sales AS (
    SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(transactions_id) AS total_orders FROM hourly_sales GROUP BY shift;
```

## Findings

- **Total Sales**: 1987 transactions
- **Unique Customers**: 155 customers
- **Top Product Categories**: Electronics, Clothing, Beauty
- **Best Selling Month**: July 2022 (541.34 avg sale), Feb 2023 (535.53 avg sale)
- **Top Customer Spending**: Customer 3 (Male) - 24,895 total sales
- **Peak Sales Hours**: Evening shift had the most transactions (1062 orders)
- **High-Value Transactions**: 402 transactions had sales above 1000

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a structured introduction to SQL for data analysis. It covers database setup, data cleaning, exploratory analysis, and business-driven SQL queries. The insights derived can help businesses make data-driven decisions regarding sales trends, customer behavior, and product performance.

