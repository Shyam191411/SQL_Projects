### Analysis on Sample-Superstore Dataset in SQL

# 1. Which is the most loss making category in the East region?

select Region, Category, Sub_Category, Profit from orders
where Region = 'East'
order by Profit asc limit 1;

# 2.  Give me the top 3 product ids by most returns?

select o.Order_ID, count(r.Returned) from orders as o inner join returns_ as r
on o.Order_ID = r.Order_ID
group by r.Order_ID
order by count(r.Returned) desc limit 3;

# 3.  In which city the most number of returns are being recorded?

select l.City, count(r.Returned) as Return_ from orders as o inner join returns_ as r
on o.Order_ID = r.Order_ID inner join location as l on o.Postal_Code = l.Postal_Code
group by l.City 
order by count(r.Returned) desc limit 1;

# 4. Find the relationship between days between order date , ship date and profit?

select Order_Date, Ship_Date, round(avg(Profit)) as Profit from orders
group by Order_Date, Ship_Date 
order by 3 desc;

# another way
select  (Ship_Date - Order_Date) as Diff_bw_Date, Profit from orders
order by 1 desc, 2 desc;


# 5. Find the region wise profits for all the regions and give the output of the most profitable region

select Region, round(sum(Profit)) as Profit from orders
group by 1
order by 2 desc; # limit 1;


# 6. Which month observe the highest number of orders placed and return placed for each year?        # 2017-11 and 2017-9

select  Year(Order_Date) as Year_, Month(Order_Date) as Month_ , count(o.Order_ID) as Orders, count(r.returned) as Return_ from  orders as o left join returns_ as r 
on o.Order_ID = r.Order_ID 
group by 1, 2
order by 3 desc;    


/* # 7. Calculate percentage change in sales for the entire dataset?
            X axis should be year_month
            Y axis percent change
        Find out if any sales pattern exists for all the region?*/
        
select  Year(Order_Date) as Year_, Month(Order_Date) as Month_, Sales, (select round(sum(Sales)) from orders) as Total,
Sales * 100 / (select sum(Sales) from orders) as 'Percentage of Total' from  orders 
group by 1, 2, 3
order by 1, 2;  


select  Year(Order_Date) as Year_, Month(Order_Date) as Month_, Sales, Region from  orders 
group by  4
order by  3 desc;    


# 8.  Top and bottom selling product for each region? 

# Top
select * from
(select Region, Product_Name, count(Product_Name) as Count from orders
group by Region, Product_Name
order by count(Product_Name) desc) as a
group by Region;

# Bottom
select * from
(select Region, Product_Name, count(Product_Name) as Count from orders
group by Region, Product_Name
order by count(Product_Name) asc) as a
group by Region;



# 9.  Why are returns initiated? Are there any specific characteristics for all the returns?
#     Hint: Find return across all categories to observe any pattern

select o.Category, o.Sub_Category, count(o.Order_ID) as Orders, count(r.Returned) as Return_ from orders as o left join  returns_ as r 
on o.Order_ID = r.Order_ID 
group by 1, 2
order by 3;

select o.Category, count(r.Returned) as Return_ from orders as o left join  returns_ as r 
on o.Order_ID = r.Order_ID 
group by 1
order by 2;

/* # 10 Create a table having two columns ( date and sales), Date should start with the min date
		of data and end at max date - in between we need all the dates
        If date is available show sales for that date else show date and NA as sales */
        

create function get_list_of_dates (@fromdate datetime, @todate datetime) returns
@result table (date datetime)
as
begin
	declare @rdate datetime;
    set @rdate = @fromdate;
    while @rdate <= @todate
		begin
			insert into @result values (@rdate);
            set @rdate = dateadd (d, 1, @rdate);
        end
	return;
end
# generator function
select * from get_list_of_dates ('03-01-2014', '30-12-2017');