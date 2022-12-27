Use [Pizza Runner];

-- Displaying customer_orders table
select * from customer_orders;

-- updating nulls properly
Update customer_orders 
set exclusions = NULL
where exclusions is NULL or exclusions = 'null' or exclusions = '';

Update customer_orders 
set extras = NULL
where extras is NULL or extras = 'null' or extras = '';

-- Displaying runner_orders
select * from runner_orders;

--Update null values in runner_orders
Update runner_orders
set cancellation = NULL
where cancellation is NULL or cancellation = 'null' or cancellation = '';

Update runner_orders
set pickup_time = NULL
where pickup_time is NULL or pickup_time = 'null';

Update runner_orders
set duration = NULL
where duration is NULL or duration = 'null';

Update runner_orders
set distance = NULL
where distance is NULL or distance = 'null';

-- 1.How many pizzas were ordered?
select count(*) as total_orders from customer_orders;

-- 2.How many unique customer orders were made?
select count(distinct customer_id) as [Unique Customers] from customer_orders;

-- 3.How many successful orders were delivered by each runner?
select count(*) as [successful delivery] from runner_orders 
where cancellation is NULL
;

-- 4.How many of each type of pizza was delivered?
select customer_orders.pizza_id,count(*) as [successful delivery] 
from runner_orders
join
customer_orders
on customer_orders.order_id = runner_orders.order_id
where cancellation is NULL
group by customer_orders.pizza_id;

-- 5.How many Vegetarian and Meatlovers were ordered by each customer?
select pizza_name, count(order_id) as [pizza type count]
from customer_orders
full outer join pizza_names 
on customer_orders.pizza_id = pizza_names.pizza_id
group by pizza_name;

-- 6.What was the maximum number of pizzas delivered in a single order?
select runner_orders.runner_id,runner_orders.pickup_time,count(*) as cnt 
from runner_orders
join
customer_orders
on customer_orders.order_id = runner_orders.order_id
where cancellation is NULL
group by runner_orders.runner_id,runner_orders.pickup_time
order by cnt desc;


-- 7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select had_changes, count(*)
from
(
	select (case when exclusions is not NULL or extras is not NULL then 'Has Changes' else 'No Changes' end) as had_changes
	from runner_orders
	join
	customer_orders
	on customer_orders.order_id = runner_orders.order_id
	where cancellation is NULL
) as temp
group by had_changes
;

-- 8.How many pizzas were delivered that had both exclusions and extras?
select had_both_changes, count(*)
from
(
	select (case when exclusions is not NULL and extras is not NULL then 'Has Changes' else 'No Changes' end) as had_both_changes
	from runner_orders
	join
	customer_orders
	on customer_orders.order_id = runner_orders.order_id
	where cancellation is NULL
) as temp
group by had_both_changes
;

-- 9.What was the total volume of pizzas ordered for each hour of the day?
select DATEPART(HOUR, order_time)  as Time_of_Day_inhour, count(*) as volume_count
from customer_orders
group by DATEPART(HOUR, order_time);

-- 10.What was the volume of orders for each day of the week?
select DATENAME(weekday, order_time)  as Week_Day, count(*) as volume_count
from customer_orders
group by DATENAME(weekday, order_time);
