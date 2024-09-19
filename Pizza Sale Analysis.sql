create database Pizza_Sales;
use Pizza_sales;
-- Q1 The total number of order place

select count(distinct(order_id)) as Total_orders from orders;

-- Q2 The total revenue generated from pizza sales

select  round(sum(od. quantity*P.price),2 )as Total_Revenue
from order_details as od 
join
pizzas as P on od.Pizza_id = p.pizza_id;

-- Q3 The highest priced pizza.
select pt.name, p.price from
pizza_types as pt
join
pizzas as p on pt.pizza_type_id = p. pizza_type_id
order by price desc
limit 1;

-- Q4 The most common pizza size ordered.

select p.size, count(od.order_id) as order_count from 
order_details as od
 join 
pizzas as p
on od.pizza_id = p.pizza_id
group by size
order by order_count desc;

-- Q5 The top 5 most ordered pizza types along their quantities.

select p.pizza_type_id, pt.name, count(od. quantity) as total_quantites 
from
pizzas as p
left join 
pizza_types as pt
on p.pizza_type_id= pt.pizza_type_id
left join
order_details as od 
on p.pizza_id=od.pizza_id
group by pizza_type_id, name
order by total_quantites desc
limit 5;

-- Q6 The quantity of each pizza categories ordered.
select pt.category, count(od.quantity) as total_quantity
from
pizzas as p
left join 
pizza_types as pt
on p.pizza_type_id= pt.pizza_type_id
left join
order_details as od 
on p.pizza_id=od.pizza_id
group by category
order by total_quantity desc;

-- Q7 The distribution of orders by hours of the day.
select hour(`time`) as hours , count(order_id) as total_orders
from orders
group by hours;

-- Q 8 The category-wise distribution of pizzas
select category, count(name) as total_pizzas from 
pizza_types
group by category
order by total_pizzas desc;

-- Q 9 The average number of pizzas ordered per day.
	select avg(quantity)
    from
    (select o.`date` as order_quantity, sum(od.quantity) as quantity 
    from order_details as od
    join orders as o on od.order_id=o.order_id
    group by 1) as order_quantity;

-- Q10 Top 3 most ordered pizza type base on revenue
select pt.name, sum(od.quantity*p.price) as Revenue from
pizza_types as pt
join
pizzas as p on pt.pizza_type_id=p.pizza_type_id

join order_details as od 
on p.pizza_id=od.pizza_id
group by name
order by revenue desc
limit 3;

-- Q11: The percentage contribution of each pizza type to revenue.	

select pt.category,round((sum(od.quantity*p.price)/(select round(sum(od.quantity*p.price),2) as total_revenue
from order_details as od join
pizzas as p on od.pizza_id=p.pizza_id))*100,2) as Revenue_percentage
from pizza_types as pt 
join pizzas as p 
on pt.pizza_type_id=p.pizza_type_id
join order_details as od 
on od.pizza_id=p.pizza_id
group by category
order by revenue_percentage desc;

-- Q12 The cumulative revenue generated over time
select `date`,
sum(revenue) over (order by `date`) as cum_revenue
from
(select o.`date`,round(sum(od.quantity*p.price),2) as revenue
from orders as o
join order_details as od
on o.order_id= od.order_id
join pizzas as p 
on p.pizza_id=od.pizza_id
group by o.`date`) as sales;

-- Q13: The top 3 most ordered pizza type based on revenue for each pizza category.

select name, category, Total_revenue
from
(select name, category, Total_revenue, 
rank()  over (partition by category order by Total_revenue desc) as rn
from
(select pt.name,pt.category,round(sum(od. quantity*P.price),2 )as Total_Revenue
 from pizza_types as pt 
join pizzas as p 
on pt.pizza_type_id=p.pizza_type_id
join order_details as od 
on od.pizza_id=p.pizza_id
group by name,category) as a)as b
where rn<=3;


