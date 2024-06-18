---baitap1--
select distinct CITY FROM STATION 
WHERE ID%2=0
---baitap2---
select 
COUNT(CITY )- COUNT(DISTINCT CITY )
FROM STATION
---baitap3---
---baitap4--- 
---phân tích đề 
---1 output (gốc/phát sinh):mean = tổng/ số đơn hàng
--- tổng bằng item_count * order_occurrences
---2 in put 
---3 điều kiện lọc theo trường nào(gốc hay phát sinh)
SELECT 
ROUND( CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL),1) AS mean
FROM items_per_order;
---baitap5---
---1 output (gốc/phát sinh):candidate_id
---2 input: candidate_id, skill
---3 điều kiện lọc theo trường nào(gốc hay phát sinh): Python, Tableau, and PostgreSQL.
SELECT candidate_id   
from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id 
having count(skill) = 3 ---loc nhung ng co ca 3 skil---
---bbaitap6---
---1.output: user_id, days_between(phats sinh)
---days_between = max(day) - min(day)
---group by user 
---2.input
---3.dieukien loc trong nam 2021
SELECT user_id,
Date(max(post_date)) - date(min(post_date)) as days_between ---date ham xu li thoi gian---
FROM posts
where post_date >='2021-01-01' and post_date <'2022-01-01'
group by user_id
having count(post_id) >=2
---baitap7---
---1.output: card_name,  
---difference: chênh lệch số lượng thẻ phát hành cao nhất và thấp nhất trong 1 tháng 
---2.input
---3. điều kiện 
select card_name, 
max(issued_amount)-min(issued_amount) as difference 
from monthly_cards_issued
group by card_name
order by difference desc 
---baitap8---
---1.output: manufacturer(gốc)
---total_loss
---drug_count
---2.input
---3. điều kiện lọc theo trường nào( gốc hay phát sinh) total_sales < cogs 
--- COGS : cost of goods sold: giá vốn hàng bán 
SELECT manufacturer,
count(drug) as drug_count,
abs(sum(cogs - total_sales))	as total_loss
FROM pharmacy_sales
where total_sales < cogs 
group by manufacturer
order by total_loss desc 
---baitap9---
