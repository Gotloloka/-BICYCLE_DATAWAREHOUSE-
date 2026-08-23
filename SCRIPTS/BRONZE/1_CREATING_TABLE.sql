-- This SQL script will create table that will bw linked to the Bronze SCHEMA 
-- The DROP TABLE will delete the if this script is re-run again and create new table with empty info
USE MASTER;
USE bicycledata;
DROP TABLE IF EXISTS bronze.brands; 
CREATE TABLE bronze.brands (
	brand_id INT PRIMARY KEY NOT NULL,
	brand_name NVARCHAR(250)  UNIQUE
);

DROP TABLE IF EXISTS bronze.categories;
CREATE TABLE bronze.categories (
	category_id INT PRIMARY KEY NOT NULL,
	category_name NVARCHAR(250)  
);

DROP TABLE IF EXISTS bronze.stocks;
CREATE TABLE bronze.stocks (
	store_id INT,
	product_id INT,
	quantity INT	
);

DROP TABLE IF EXISTS bronze.stores;
CREATE TABLE bronze.stores (
	store_id INT,
	store_name NVARCHAR(250),
	phone NVARCHAR(50),
	email  NVARCHAR(250),
	street NVARCHAR(250),
	city   NVARCHAR(250),
	states NVARCHAR(250)
	zip_code INT
	);
DROP TABLE IF EXISTS bronze.customers;
CREATE TABLE bronze.customers  (
	customer_id INT PRIMARY KEY NOT NULL,
	first_name NVARCHAR(250),
	last_name NVARCHAR(250),
	phone NVARCHAR(50),
	email NVARCHAR(250),
	street NVARCHAR(250),
	city NVARCHAR(250),
	state NVARCHAR(250),
	zip_code INT
);

DROP TABLE IF EXISTS bronze.order_items;
CREATE TABLE bronze.order_items (
	order_id INT,
	item_id INT,
	product_id INT,
	quantity INT,
	list_price FLOAT,
	discount FLOAT
);
DROP TABLE IF EXISTS bronze.staffs;
CREATE TABLE bronze.staffs (
	staff_id INT PRIMARY KEY NOT NULL,
	first_name NVARCHAR(250),
	last_name NVARCHAR(250),
	email NVARCHAR(250),
	phone NVARCHAR(50),
	active INT,
	store_id INT,
	manager_id INT 
);

DROP TABLE IF EXISTS bronze.orders;
CREATE TABLE bronze.orders (
	order_id INT PRIMARY KEY NOT NULL,
	customer_id INT,
	order_status INT,
	order_date DATE,
	require_date DATE,
	shippped_date NVARCHAR(50),
	store_id INT,
	staff_id INT
); 

DROP TABLE IF EXISTS bronze.products;
CREATE TABLE bronze.products (
	product_id INT PRIMARY KEY NOT NULL,
	product_name NVARCHAR(250),
	brand_id INT,
	category_id INT,
	model_year INT, 
	list_price FLOAT

	);
