---baitap1---
WITH duplicate_listings AS

(SELECT company_id, title, description, count(*)
FROM job_listings
GROUP BY company_id, title, description
HAVING count(*) > 1)
SELECT count(*) FROM duplicate_listings
---group by xong đếm xem có bao nhiều bộ dữ liệu trùng với nhau---
---baitap2---
