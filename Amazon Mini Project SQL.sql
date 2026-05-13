create database amazon;
use amazon;
-- change text datatype to varchar
alter table customers modify column CustomerID varchar(50);
alter table order_details modify column OrderID varchar(50);
alter table order_details modify column ProductID varchar(50);
alter table orders modify column OrderID varchar(50);
alter table orders modify column CustomerID varchar(50);
alter table products modify column productID varchar(50);
alter table products modify column SupplierID varchar(50);
alter table reviews modify column reviewID varchar(50);
alter table reviews modify column ProductID varchar(50);
alter table reviews modify column CustomerID varchar(50);
alter table suppliers modify column SupplierID varchar(50);

-- TASK 2 
-- Identify the primary keys and foreign keys for each table and describe their relationships.
alter table customers add constraint new_constraint primary key(CustomerID);
alter table orders add constraint new_constraint primary key(OrderID);
alter table products add constraint new_constraint primary key(productID);
alter table reviews add constraint new_constraint primary key(reviewID);
alter table suppliers add constraint new_constraint primary key(SupplierID);

-- add foreign key
alter table order_details
add constraint fk_orders foreign key(OrderID)references orders(OrderID),
add constraint fk_products foreign key(ProductID)references products(ProductID);
alter table orders
add constraint fk_customers foreign key(customerID)references customers(customerID);
alter table products
add constraint fk_suppliers foreign key(supplierID)references suppliers(supplierID);
-- insert values 
insert into suppliers (SupplierID)
select distinct SupplierID
from products
where SupplierID not in(
select SupplierID from suppliers);
alter table reviews
add constraint fk_review foreign key(ProductID)references products(ProductID);
alter table reviews
add constraint fk_cust foreign key(CustomerID)references customers(CustomerID);

-- TASK 3
-- Retrieve all customers from a specific city.
select * from customers where city ="Lorimouth";
-- Fetch all products under the "Fruits" category.
select * from products where category = "Fruits";

-- TASK 4 
-- CustomerID as the primary key
alter table customers add constraint new_constraint primary key(CustomerID);
-- Ensure Age cannot be null and must be greater than 18
alter table customers modify column age int not null;
alter table customers add constraint chk_age check(age>=18);
-- Change data type in name
alter table customers modify column Name varchar(40);
-- Add a unique constraint for Name
alter table customers add constraint new_constraint unique(Name);

-- TASK 5 
-- Insert 3 new rows into the Products table using INSERT statements.
insert into products values
(101,"orange","fruit", "Sub-fruit-4", 300,20,"eafcc3e7-83b3-4392-b278-1cc6efc9a2a2"),
(102,"cake","snack", "Sub-Bakery-3", 240,30,"7524d174-62e4-468f-8b7b-b8e555f73638"),
(103,"beetroot","vegetable","Sub-Vegetables-4",350,25,"4a38a00e-3913-46a1-a2bb-896a3d877ac4");

-- TASK 6 
-- Update the stock quantity of a product where ProductID matches a specific ID.
update products set StockQuantity=60 where productID="cb890936-8142-4fa3-ac60-2ecba78f8aa8";

-- TASK 7
-- Delete a supplier from the Suppliers table where their city matches a specific value.
set sql_safe_updates=0;
delete from suppliers where city="Schneidermouth";

-- TASK 8
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
alter table reviews add constraint chk_rate check(rating between 1 and 5);
-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
alter table customers modify column PrimeMember varchar(10) default "no";

-- TASK 9
-- WHERE clause to find orders placed after 2024-01-01.
select * from orders where Orderdate>2024-01-01;
-- HAVING clause to list products with average ratings greater than 4.
select ProductID, avg(rating) as avg_rating from reviews group by ProductID having avg(rating)>4;

-- TASK 10
-- 1. calculate each customers total spending
select c.CustomerID, c.Name, sum(o.orderamount) as total_spending from orders as o 
join customers as c on o.CustomerID=c.CustomerID group by c.CustomerID order by total_spending desc;
-- 2. Rank customers based on their spending.
select CustomerID, OrderAmount from orders order by OrderAmount desc;
-- 3. Identify customers who have spent more than ₹5,000.
select CustomerID, OrderAmount from orders where OrderAmount>5000;

-- TASK 11
-- 1. Join the Orders and OrderDetails tables to calculate total revenue per order.
select od.OrderID, od.ProductID,o.CustomerID, (od.Quantity*od.Unitprice) as total_revenue from order_details as od 
left join orders as o on o.OrderID=od.OrderID;
-- 2. Identify customers who placed the most orders in a specific time period.
select CustomerID, OrderAmount from orders order by OrderAmount desc limit 3;
-- 3. Find the supplier with the most products in stock.
select productid, supplierid, productname, stockquantity from products order by stockquantity desc limit 1;
select max(stockquantity) from products;

-- TASK 12
-- Separate product categories and subcategories into a new table.
select * from category;
-- Create foreign keys to maintain relationships.
alter table category
add constraint fk_subcategory foreign key(Subcategory)references products(Subcategory);
 
 -- TASK 13
 -- Identify the top 3 products based on sales revenue.
 select productID, (Quantity*UnitPrice) as sales_revenue from order_details order by sales_revenue desc limit 3;
 -- Find customers who haven’t placed any orders yet.
 select CustomerID, OrderID, OrderAmount from orders where OrderAmount=0;
 
 -- TASK 14
 -- Which cities have the highest concentration of Prime members?
 select PrimeMember, city from customers group by PrimeMember, city having primemember="yes";
 -- What are the top 3 most frequently ordered categorie?
 select category, count(*) as total_orders from products group by category order by total_orders desc limit 3;