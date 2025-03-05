-- Retail Sales Analysis
-- SQL Project 1
-- lets create database
create database sql_project_1


-- Create Tables
drop table if exists retail_sales;
create table retail_sales ( 
                           transactions_id INT PRIMARY KEY ,
						    sale_date DATE,
							sale_time TIME,
							customer_id INT,
							gender VARCHAR (10),
							age INT,
							category VARCHAR(30),
 							quantity INT,
							price_per_unit FLOAT,
							cogs FLOAT,
							total_sale FLOAT
                          );


-- Lets Check the table:
select * from retail_sales
limit 10;


-- lets check for any null values in the data
SELECT * 
FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Retail Sales dataset has intotal 2000 rows of data
-- In this dataset, there are 13 rows which has null values particularly in Age, Category, Quantity, Price_Per_Unit, Cogs and Total_Sales rows
-- We can fill or delete the null values, but the number of null values are low so we can move forward with deleting null values

-- Deleting Null Values
Delete from retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- Lets get the count, after deleting the null rows
select count(*)
from retail_sales;

-- There are in total '1987' Rows after deleting 13 NULL rows

-- Lets perform exploration data analysis (EDA):

-- How many sales we have ?
select * from retail_sales;

select count(distinct transactions_id) as total_Sales_Made
from retail_sales;

-- How many unique customers we have
select count(distinct customer_id) as total_number_of_customers
from retail_sales;

-- How many categories we have
select distinct category
from retail_sales;

-- Business Analysis and answering key insights from the data --

-- Find all sales data, made on '01 Nov 2022'
select * from retail_sales;

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-01';


-- Find all sales data, made after '10 Dec 2022'

SELECT *
FROM retail_sales
WHERE sale_date >= Date '2022-12-10';


-- write a SQL query to retrieve all transactions where the category is 'clothing' 
-- and quantity is more than 4 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


-- Write a SQL query to calculate the total sales for each category

SELECT 
category,
sum(total_sale) as total_sale_as_per_category
FROM retail_sales
group by category;


-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select * from retail_sales;

select
gender,
avg(age) as AVG_Beauty_Category_Buyer
from retail_sales
where category ='Beauty'
group by gender;

-- Write a SQL query to find all the transactions where total_sale is greater than 1000.

select * from retail_sales


select transactions_id,customer_id,age,gender
from retail_sales
where total_sale >= 1000


-- Write a SQL query to find all the total number of transactions (transactions_id) made by each gender in each category

select * from retail_sales

select 
    category,
    gender,
    count (transactions_id) as total_transactions
from retail_sales
group by category, gender
order by category, total_transactions desc;



-- Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year

select
extract (YEAR from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as avg_total_sale
from retail_sales
group by 1,2
order by 1,2 desc

-- I need one month from each year

select * from 
(
select 
extract (year from sale_date) as Year,
extract (month from sale_date) as Month,
avg(total_sale) as Avg_Total_Sale,
rank() 
over(partition by extract(Year from sale_date) order by avg(total_sale) desc) as Rank
from retail_sales
group by 1,2
) as average_sale_by_month
where Rank = 1;


-- Write SQL Query to find the top 5 customers based on highest total sales

select 
distinct(customer_id), gender,
sum(total_sale) as highest_total_sales
from retail_sales
group by customer_id,gender 
order by highest_total_sales desc
limit 5



-- Write SQL query to find number of unique customers who purchased items from each catgeory

select 
    customer_id, 
    category, 
    count(total_sale) as total_purchases
from retail_sales
group by customer_id, category
order by customer_id, total_purchases DESC;


-- write a SQL query to create each shift and numbers of orders i.e
-- (example morning <=12, afternoon between 12 and 17 and evening > 17)


with hourly_sales as
(
select *,
case
    when extract (Hour from sale_time) < 12 then 'Morning'
	when extract (Hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as shift
from retail_sales
)
select 
shift,
count (transactions_id) as total_orders
from hourly_sales
group by shift









































