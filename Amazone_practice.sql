
-- 1 what is the total amount each customer spend on zomato?
select a.userid,sum(b.price) from product b inner join sales a on b.product_id = a.product_id group by a.userid;

-- 2 how many days has each customer visited zomato?
select userid,count(distinct created_date) from sales group by userid;

-- 3 what was the first product purchased by each customers?
select * from (select *,rank() over(partition by userid order by created_date) rnk from sales) a where rnk = 1;

-- 4 what is the most purchased item on the menu and how many  times was it purchased by all customers?
select userid,count(product_id) cnt from sales where product_id =
(select product_id from sales group by product_id limit 1) group by userid;

-- 5 which item was the most popular  for each  customers?
select * from 
(select *,rank() over(partition by userid order by cnt desc) rnk from 
(select userid,product_id,count(product_id) cnt from sales group by userid,product_id)a)b
where rnk = 1;

-- 6 which item  was purchased first by the customer after become  a member?
select * from
(select c.*,rank() over(partition by userid order by created_date) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from 
sales a inner join goldusers_signup b on a.userid = b.userid and created_date>=gold_signup_date) c)d where rnk = 1;

-- 7 which item was purchased just before the customer become a member?
select * from
(select c.*,rank() over(partition by userid order by created_date desc) rnk from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from 
sales a inner join goldusers_signup b on a.userid = b.userid and created_date<=gold_signup_date) c)d where rnk = 1;

-- 8 what is the total orders  and amount spend for each member before they become member?
select userid,count(created_date) order_puchased,sum(price) total_amt_spend from
(select c.*,d.price from
(select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a inner join 
goldusers_signup b on a.userid = b.userid and created_date<= gold_signup_date) c inner join product d on c.product_id = d.product_id)e
group by userid;  