/* lets find out how many distinct productline we have*/
select distinct(Productline)
      FROM superstore.sales_data_sample;
/*We have 7 Productline in this dataset*/
##################################################################################################################################
/*  GETTING THE TOTAL ORDERS AND  TOTAL QUANTITY ORDERED BY EACH  Productline*/
SELECT count(*) as total_orders, sum(Quantityordered) as total_quantity
FROM superstore.sales_data_sample;
/* we have total orders as 2763 and total Quantityorderd as 96869*/
###################################################################################################################
/*lets break it down to each Productline to know the total orders and Total Quantityordered*/
SELECT  Productline,count(*) as total_orders, sum(Quantityordered) as total_quantity
FROM superstore.sales_data_sample
group by Productline
ORDER BY 2 DESC;
/* we have Classic cars being the highest productline ordered with a total of 33284, followed by Vintage 20736 and Motorcycles 11504*\
/*we have Classic cars with total orders of 949,Vintage 557 and Motorcycles as 327*/
#######################################################################################################################
/*Lets see the Productline that made the highest revenue*\
/*The Top selling Productline*/
select Productline, round(sum(Sales),2) as Total_Sales
FROM superstore.sales_data_sample
group by 1
order by 2 desc;
/* we have the Classica cars with the highest revenue 3842746.4 ,Vintage 187129.41,Motorcycles 1154293.74*/
##############################################################
/* the top country with the highest revenue*/
select Country,round(sum(Sales),2) as Total_sales
FROM superstore.sales_data_sample
group by 1
order by 2 desc;
/* USA had the  3 highest revenue by Country are USA 3546745.95 Spain 1176911.02 and France with1089834.96*/
#####################################################################################################################
/* lets find out which city in USA had the highest revenue*/
select
 City,
Country,
round(sum(Sales),2) as Total_sales
FROM superstore.sales_data_sample
group by City,Country
having Country = 'USA'
order by 3 desc;
/* This shows that  the City San Rafael in USA had the largest revenue*/

#################################################################################################################################
/*THE TOP CITY WITH THE HIGEST SALES*/
select City,round(sum(Sales),2) as Total_sales
FROM superstore.sales_data_sample
group by 1
order by 2 desc
limit 10;
/* MADRID HAD THE HIGHEST SALES OF 1064396.28,SAN RAFAEL 644181.82 NYC 545552.65*/
##############################################################################################################################################se

/* Which year had the highest revenue and lowest revenue*/
select 
    Year_Id,
	round(sum(Sales),2) as Total_Sales
    FROM superstore.sales_data_sample
    group by 1
    order by 2 desc;
/* We have the Year 2004 as the highest for Revenue with 4628345.91,  and Year 2005 had the least revenue*/
##################################################################################################################
/* find out why 2005 was the least in revenue
lets find out how many months sales were made in the Year 2005*/
select distinct(Year_Id),Month_Id
FROM superstore.sales_data_sample
where Year_Id = 2005
order by 2 desc;
/* For the Year 2005 sales were only for 5 months in the year which accounts for low revenue*/
/* lets find out  for the year 2004*/
select distinct(Year_Id),Month_Id
FROM superstore.sales_data_sample
where Year_Id = 2004
order by 2 desc;
/*for the year 2004 sales was recorded for the 12 months of the year*/
/*  lets find out for the year 2003*/
select distinct(Year_Id),Month_Id
FROM superstore.sales_data_sample
where Year_Id = 2003
order by 2 desc;
/* for the year 2003 sales was recorded for the 12 months of the year*/
/* lets find out revenue by dealsize*/
select Dealsize,round(sum(Sales),2) as Total_Sales
FROM superstore.sales_data_sample
group by Dealsize
order by 2 desc;
/*This shows that medium had the highest revenue */
#############################################################################################################################

/* The Top 3 Customers their country and Prouctline purchase*/
select
     distinct(Customername),
     Country, 
     Productline,
     round(sum(Sales),2) as Total_sales
     FROM superstore.sales_data_sample
     group by 1,2,3
     order by 4 desc
     limit 3;
/* we have the Customername Euro Shopping Channel as the top customer from Spain that purchased Classic Cars and Total revenue generated as 
407741.84*/
/*FIND WHICH MONTH HAD THE TOTAL SALES AND TOTAL  QUANTITYORDERES FOR THE YEAR 2014*/
select 
Year_Id,
Month_Id,
round(sum(Sales),2)as Total_Sales,
sum(Quantityordered) as Total_Quantityordered
FROM superstore.sales_data_sample
Group by 1,2
having Year_Id ='2004'
order by 3 desc;
/* the highest revenue for the year 2004 was in the month of November with 1053854.4,followed by october 545217.21*/
#############################################################################################################################################
/*lets find out the productline that had the highest revenue  in November*/
select 
Month_Id,
Productline,
round(sum(Sales),2) as Total_sales,
count(distinct(Ordernumber)) as count_of_orders,
sum(Quantityordered) as Total_quantity
FROM superstore.sales_data_sample
group by Month_Id,Productline
having Month_Id =11
order by 3 desc;
/* Classic Cars had the highest revenue in the month of November*/
#############################################################################################################

/*THE THE TOP 100 CUSTOMERNAME RANKED BY SALES*/
select Customername, Sales,
rank () over(order by Sales desc) as Sales_Rank
FROM superstore.sales_data_sample
limit 100;
/* THE CUSTOMERNAME -The Sharp Gifts Warehouse IS THE FIRST IN  RANK  WITH SALES 14082.8,FOLLOWEED BY Online Diecast Creations Co.
WITH SALES 12536.5*/
/*aNALYZING SALES THE PREVIOUS AND CURRENT YEAR*/
WITH CTE AS
(select 
Year_id,
round(sum(Sales),2) as Total_Sales
FROM superstore.sales_data_sample
group by 1
order by 1, 2 desc)
select Year_Id,Total_Sales,
lag (Total_Sales) over() as Previous_Year_Sales
from CTE;
/* WE HAVE THE PREVIOUS YEAR SALES FOR YEAR 2004 AS 3446297.34 AND YEAR 2005 AS 4628345.91, THERE WAS NO RECORD FOR THE PREVIOUS YEAR 2003*/

/*------WE WANT THE AVERAGE NUMBER OF ORDERS PER CUSTOMER PER  Country*/
WITH CTE_Orders AS
(select Country,Customername,count(distinct(Ordernumber)) as Count_of_orders
FROM superstore.sales_data_sample
group by 1,2)
select Country,Customername,round(avg(count_of_orders)) as rounded_avg
from CTE_Orders
group by 1
order by 3 desc;
############################################################################################################################################

/*TO GET THE AVERAGE ORDERS VALUE */

SELECT Year_Id, Country,
COUNT(*) AS total_orders,SUM(Quantityordered) AS total_quantity,
Round(SUM(Sales),2) as Total_sales,
cast(Round(SUM(sales),2)/COUNT(*)AS SIgned)  AS Avg_order_value
FROM superstore.sales_data_sample
GROUP BY 1,2
having Year_Id =2004
order by 6 desc;
/* The average order value for Austria is 4308,Finland is 4163,