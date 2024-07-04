---baitap1---
WITH duplicate_listings AS

(SELECT company_id, title, description, count(*)
FROM job_listings
GROUP BY company_id, title, description
HAVING count(*) > 1)
SELECT count(*) FROM duplicate_listings
---group by xong đếm xem có bao nhiều bộ dữ liệu trùng với nhau---
---baitap2---
---baitap3---
with count_case as (
select 
count(policy_holder_id) as policy_holder_count
from callers
group by policy_holder_id
having count(case_id) >=3 
)
select count(policy_holder_count) from count_case 
---baitap4---
SELECT a.page_id 
FROM pages as a 
full join page_likes as b
on a.page_id=b.page_id
where b.liked_date is null
order by a.page_id 
---baitap5---
SELECT EXTRACT(MONTH FROM event_date), COUNT(DISTINCT user_id)
FROM user_actions
WHERE user_id in (select distinct user_id from user_actions where EXTRACT(month from event_date)=6)
---in ra danh sách mà hoạt động ở tháng 6 
and EXTRACT(month from event_date)=7
GROUP BY EXTRACT(MONTH FROM event_date);
---baitap6---
SELECT to_char(trans_date,'yyyy-mm') AS month, country, count(id) AS trans_count, 
        sum(case when state = 'approved' then 1 else 0 end) AS approved_count, 
        sum(amount) AS trans_total_amount,
        sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
FROM Transactions
GROUP BY month, country;
---baitap7---
select a. product_id,
min(year) as first_year,
min(quantity) as quantity,
a.price as price
from Sales as a 
join Product as b 
on a.product_id = b.product_id 
group by a.product_id, a.price
---baitap8---
select customer_id
from Customer 
group by customer_id
having count(product_key) =2
order by customer_id
---baitap9---
select employee_id
 from Employees
 where salary <30000 and manager_id not in ( select employee_id from employees)
 order by employee_id
---baitap10---
WITH duplicate_listings AS

(SELECT company_id, title, description, count(*)
FROM job_listings
GROUP BY company_id, title, description
HAVING count(*) > 1)

SELECT count(*) FROM duplicate_listings

---baitap11---
with solution1 as (
select a.name as results ,
count(rating)
from Users as a 
join MovieRating as b 
on a.user_id=b.user_id 
group by a.name
order by count(rating) desc, a.name 
limit 1 ),

solution2 as (
select title as results , 
avg(rating)
from MovieRating as c
join Movies as d 
on c.movie_id=d.movie_id
where created_at between '2020-02-01' and '2020-02-29'
group by d.title
order by avg(rating) desc, d.title 
limit 1 )
 select results 
 from solution1
 union 
 select results
 from solution2
 order by results
---baitap12---
-- Write your PostgreSQL query statement below
with a as (select requester_id, count(accepter_id) from RequestAccepted 
group by requester_id
union
select accepter_id, count(requester_id)  from RequestAccepted
group by accepter_id
order by requester_id),
b as (
select requester_id as id,
sum(count) as num
from a 
group by requester_id
)
select id,num
from b 
where num =(select max(num) from b )






