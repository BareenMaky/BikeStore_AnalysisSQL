USE BikeStores
SELECT * FROM production.brands
SELECT * FROM production.categories
SELECT * FROM PRODUCTION.PRODUCTS
SELECT * FROM PRODUCTION.STOCKS
SELECT * FROM SALES.CUSTOMERS
SELECT * FROM SALES.ORDER_ITEMS
SELECT * FROM SALES.ORDERS
SELECT * FROM SALES.STAFFS
SELECT * FROM SALES.STORES


-- (1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
Select product_name,product_id,list_price from production.products 
where list_price=(
Select Max(list_price) 'Max.Price'  from production.products)

--May be the motive behind the pricing is the brand reputation,features or materials.


-- (2) How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
 Select Count( customer_id)'Total Customers' from sales.customers

 -- Yes,They are considered Customers as their data is store and some of them placed orders again after being rejected.
-- (3) How many stores does BikeStore have?
Select count(store_name) '#STORES' from sales.stores 


-- (4) What is the total price spent per order? Select order_id,[list_price] *[quantity]*(1-[discount]) 'Total_price' from sales.order_items


-- (5) What’s the sales/revenue per store? Sales revenue = ([list_price] *[quantity]*(1-[discount]))Select SS.store_id,SUM(list_price *quantity*(1*discount)) 'Sales Rev.' from sales.order_items S inner join sales.orders SOon S.order_id=SO.order_id INNER JOIN sales.stores SS on SO.store_id=SS.store_id Where SO.order_status=4 group by SS.store_id 


-- (6) Which category is most sold?
Select Top 1 categ.category_id,categ.category_name,Sum(SO.quantity) 'SOLD_CATEG' from production.categories Categ inner join Production.products PP
on Categ.category_id=PP.category_id inner join sales.order_items SO on PP.product_id=So.product_id inner join sales.orders S
on SO.order_id=S.order_id Where order_status=4 Group by categ.category_id,categ.category_name 



-- (7) Which category rejected more orders?Select Top 1 categ.category_id,categ.category_name,count(*) 'Rej_orders' from production.categories Categ 
inner join Production.products PP on Categ.category_id=PP.category_id inner join sales.order_items SO 
on PP.product_id=So.product_id inner join sales.orders S on SO.order_id=S.order_id Where S.order_status=3 
GROUP BY Categ.category_id, Categ.category_name order by Rej_orders
-- (8) Which bike is the least sold?Select Top 1 PP.product_id,PP.product_name,Sum(SO.quantity) 'Total_sold' from production.products PP left join Sales.order_items SO on PP.product_id=SO.product_id  inner join sales.orders S on SO.order_id=S.order_id Where order_status=4Group by PP.product_id,PP.product_name  Order by Total_sold Asc



-- (9) What’s the full name of a customer with ID 259?
Select Concat(first_name,' ' ,last_name)Full_name from sales.customers Where customer_id=259


-- (10) What did the customer on question 9 buy and when? What’s the status of this order?
Select SO.order_id,PP.product_name,SO.order_status,SO.order_date 
from sales.orders SO inner join sales.order_items S 
on SO.order_id=S.order_id
inner join production.products PP 
on PP.product_id=S.product_id where customer_id=259



-- (11) Which staff processed the order of customer 259? And from which store?
Select SO.staff_id,SF.first_name,SF.last_name,SO.store_id  from sales.orders SO inner join sales.staffs SF 
on SO.staff_id=SF.staff_id inner join SALES.stores SS on SF.store_id=SS.store_id where customer_id=259



-- (12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
Select COUNT(staff_id) '#Staff' from sales.staffs 

Select staff_id,first_name,last_name from sales.staffs Where manager_id is null


-- (13) Which brand is the most liked?
Select TOP 1 B.brand_id,B.brand_name,COUNT(SO.order_id) 'Orders' from production.brands B 
inner join production.products PP on B.brand_id=PP.brand_id
inner join SALES.order_items SO On PP.product_id=SO.product_id
Group by B.brand_name,B.brand_id
order by Orders DESC

        

-- (14) How many categories does BikeStore have, and which one is the least liked?
Select COUNT(category_id) '#Categ.' from production.categories

Select Top 1 categ.category_id, categ.category_name, Sum(SO.quantity) 'SOLD_CATEG' from production.categories Categ inner join Production.products PP
on Categ.category_id=PP.category_id inner join sales.order_items SO on PP.product_id=So.product_id inner join sales.orders S
on SO.order_id=S.order_id
Group by categ.category_id,categ.category_name Order by SOLD_CATEG ASC



-- (15) Which store still have more products of the most liked brand?
Select Top 1 SS.store_name,B.brand_name,SUM(PS.quantity) 'QUANTITY' from production.brands B inner join production.products PP 
on B.brand_id = PP.brand_id inner join  production.stocks PS on PS.product_id = PP.product_id inner join sales.stores SS on PS.store_id = SS.store_id
inner join sales.order_items SO on PP.product_id = SO.product_id where B.brand_id=(Select TOP 1 B.brand_id from production.brands B inner join production.products PP
on B.brand_id=PP.brand_id inner join SALES.order_items SO On PP.product_id=SO.product_id Group by B.brand_id
order by Count(SO.order_id) DESC) Group by SS.store_name, B.brand_name Order by QUANTITY DESC



-- (16) Which state is doing better in terms of sales?
Select TOP 1 SC.state,SUM(S.list_price *S.quantity*(1-[discount]))'SALES.REV' from  sales.customers SC
inner join Sales.orders SO ON SC.customer_id=SO.customer_id
INNER JOIN SALES.order_items S on SO.order_id=S.order_id Group by SC.state



-- (17) What’s the discounted price of product id 259?
Select list_price* (1-discount)'discounted price' from sales.order_items where product_id=259



-- (18) What’s the product name, quantity, price, category, model year and brand name of product number 44?
Select PP.product_name,PS.quantity,PP.list_price,C.category_name,PP.model_year,PB.brand_name from production.products PP 
inner join Production.brands PB on PP.brand_id=PB.brand_id inner join production.categories C 
on C.category_id=PP.category_id inner join production.stocks PS On PS.product_id=PP.product_id WHERE PP.product_id=44


-- (19) What’s the zip code of CA?
Select zip_code from sales.customers Where state='CA'



-- (20) How many states does BikeStore operate in?
Select COUNT(state) '#States' from sales.stores
Select COUNT(DISTINCT state) '#States' from sales.customers


-- (21) How many bikes under the children category were sold in the last 8 months?
Select PC.category_name, sum(quantity) '#Bikes' from sales.order_items SO inner join sales.orders S
on S.order_id=SO.order_id inner join production.products PP
on SO.product_id=PP.product_id INNER JOIN production.categories PC ON PP.category_id=PC.category_id WHERE PC.category_name='Children Bicycle'
and S.order_date >= DATEADD(MONTH, -8, GETDATE())  Group by PC.category_name



-- (22) What’s the shipped date for the order from customer 523?
Select shipped_date from sales.orders Where customer_id=523


-- (23) How many orders are still pending?
Select Count(order_status) 'still pending' from sales.orders Where order_status=1



-- (24) What’s the names of category and brand does "Electra white water 3i -2018" fall under?
Select pp.product_name, PC.category_name,PB.brand_name from production.products PP inner join production.categories PC
on PP.category_id=PC.category_id INNER JOIN production.brands Pb 
on PP.brand_id=PB.brand_id where PP.product_name like '%Electra white%' 



    