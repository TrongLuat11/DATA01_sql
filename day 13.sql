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
---baitap6 
