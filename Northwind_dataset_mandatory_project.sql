use northwind;
select * from categories;
select * from customers;
select * from employees;
select * from order_details;
select * from orders;
select * from products;
select * from shippers;
select * from suppliers;

-- 1. Calculate average Unit Price for each CustomerId.
select cs.customerid, od.unitprice, ROUND(avg(od.unitprice) over (partition by cs.customerid),2)
average_Unit_Price  from customers cs 
inner join orders ordr on cs.customerid=ordr.customerid
inner join order_details od on ordr.orderid=od.orderid;

-- 2. Calculate average Unit Price for each group of CustomerId AND EmployeeId.
select cs.customerid,e.employeeid, avg(od.unitprice) 
over (partition by cs.customerid, ordr.employeeid order by cs.customerid) average_Unit_Price 
from customers cs 
inner join orders ordr on cs.customerid=ordr.customerid
inner join order_details od on ordr.orderid=od.orderid
inner join employees e on e.employeeid=ordr.employeeid;

select cs.customerid, round(avg(od.unitprice) 
over (partition by cs.customerid order by cs.customerid),2) cs_average_Unit_Price, e.employeeid,
round(avg(od.unitprice) over (partition by ordr.employeeid order by ordr.employeeid),2) emp_average_Unit_Price 
from customers cs 
inner join orders ordr on cs.customerid=ordr.customerid
inner join order_details od on ordr.orderid=od.orderid
inner join employees e on e.employeeid=ordr.employeeid;

-- Q.3 Rank Unit Price in descending order for each CustomerId.
select cs.customerid, od.unitprice, dense_rank() over (order by od.unitprice desc) 
dense_Unit_Price_rank, rank() over (order by od.unitprice desc) Unit_Price_ran  
from customers cs 
inner join orders ordr on cs.customerid=ordr.customerid
inner join order_details od on ordr.orderid=od.orderid;

-- Q.4. How can you pull the previous order date’s Quantity for each ProductId.
select od.productid, o.orderdate, lag(od.quantity) 
over (partition by od.productid order by o.orderdate ) previous_order_date’s_Quantity
from order_details od inner join orders o on o.orderid=od.orderid;

-- Q. 5. How can you pull the following order date’s Quantity for each ProductId.
select od.productid, o.orderdate, lead(od.quantity) 
over (partition by od.productid order by o.orderdate) next_order_date’s_Quantity
from order_details od inner join orders o on o.orderid=od.orderid;

-- 6. Pull out the very first Quantity ever ordered for each ProductId.
select productid, od.quantity,
first_value(o.orderdate) over (partition by o.orderid) first_quantity_order_date
from order_details od inner join orders o on o.orderid=od.orderid;

-- Q. 7. Calculate a cumulative moving average UnitPrice for each CustomerId.
select cs.CustomerID, od.unitprice, round(avg(od.unitprice) over 
(order by customerid ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2) cumulative_moving_average
from orders o inner join order_details od on o.OrderID=od.OrderID
inner join customers cs on cs.CustomerID=o.CustomerID;
--- --------------------------------------------------------------------
/* Theoratical Questions
Q.1. Can you define a trigger that is invoked automatically before a new row is inserted into a 
table?
-- BEFORE INSERT triggers are automatically fired before an insert event occurs on the table.

Q. 2. What are the different types of triggers?
-- We can define 6 types of triggers for each table: 
BEFORE INSERT: activated before data is inserted into the table.
AFTER INSERT activated after data is inserted into the table. 
BEFORE UPDATE: activated before data in the table is modified.
AFTER UPDATE: activated after data in the table is modified. 
BEFORE DELETE: activated before data is deleted/removed from the table. 
AFTER DELETE: activated after data is deleted/removed from the table.

Q. 3. How is Metadata expressed and structured? 
-- MySQL stores metadata in a Unicode character set, namely UTF-8. This does not cause any 
disruption if you never use accented or non-Latin characters.
A given metadata statement can be expressed in any of a variety of encodings. On the Web, these 
presently include HTML, XML, and RDF-XML.
-- Structural metadata is metadata that describes the types, versions, relationships and other 
characteristics of digital materials. Structural metadata is used for creation and maintenance of the 
information warehouse. It fully describes information warehouse structure and content. The basic building block of structural metadata 
is a model that describes its data entities, their characteristics, and how they are related to one 
another.
Eg. Structural metadata is data that indicates how a digital asset is organized, such as how pages in a 
book are organized to form chapters, or the notes that make up a notebook in Evernote or OneNote. 

Q.4. Explain RDS and AWS key management services.
AWS KMS:
AWS Key Management Service (KMS) gives a centralized control over the cryptographic keys used 
to protect the data. The service is integrated with other AWS services making it easier to encrypt 
data you store in these services and control access to the keys that decrypt it.

Amazon AWS:
AWS Key Management Service (AWS KMS) is a managed service that makes it easy to create and 
control the cryptographic keys that are used to protect the data.
Amazon RDS: 
Amazon Relational Database Service (Amazon RDS) can encrypt data using an AWS managed key or a 
Customer managed key (CMK).

Amazon RDS:
It a Relational Database Cloud Service
It minimizes relational database management by automation
It creates multiple instances for high availability and failovers
It supports PostgreSQL, MySQL, Maria DB, Oracle, SQL Server, and Amazon Aurora
Amazon AWS:
AWS (Amazon Web Services) is a comprehensive, evolving cloud computing platform provided by Amazon that 
includes a mixture of infrastructure-as-a-service (IaaS), platform-as-a-service (PaaS) and 
packaged-software-as-a-service (SaaS) offerings. AWS services can offer an organization tools 
such as compute power, database storage and content delivery services.

Q. 5. What is the difference between amazon RDS and EC2 ?
** Both RDS and EC2 can be used to build a database within a secure environment that supports 
high-performance applications and is scalable as well.
* RDS automatically manages time-consuming tasks such as configuration, backups, and patches.
* Amazon EC2  (Elastic Compute Cloud) cloud computing platform lets you create as many virtual servers 
as you needed. We should manually configure security, networking and manage the stored data.
* Apart from that 
PERFORMANCE: Specific number of IOPS is managed by us, it gives fast and consistent Input and Output Performance.
             VS we have to pick up the storage volume with the right size in order to get the latency and IOPS we need. 
SCALABILITY: RDS integrates with Amazon’s scaling tools for both horizontal and vertical scaling. VS
			 In EC2, we have to set up the scalable architecture manually.
STORAGE:     cost-effective option to choose, the SSD volumes can handle up to 3000 Input-output Operation Per Second
             Per Second (IOPS). VS IOPS and the latency we get depends on the EC2 instance type.
SECURITY:    RDS provides encryption at both rest and transit. VS configured at the database level
LICENCING:  Amazon RDS supports only the “License Included” model for licensing for SQL Server. 
            VS Development charts can be viewed by users in GitLab.
COST:       Mostly expensive. VS Cheaper
BACKUPS:    The backups can be automated. VS The backups must be enabled by us here. 

*/
-- -------------------------------------------------------
-- or
select productid, od.quantity,
first_value(o.orderdate) over (partition by o.orderdate) first_quantity_order_date
from order_details od inner join orders o on o.orderid=od.orderid
group by ProductId
order by ProductId;