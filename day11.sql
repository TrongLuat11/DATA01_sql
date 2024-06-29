---baitap1---
  SELECT COUNTRY.CONTINENT,
FLOOR(AVG(CITY.POPULATION))
FROM CITY
INNER JOIN COUNTRY 
ON CITY.COUNTRYCODE= COUNTRY.CODE
GROUP BY  COUNTRY.CONTINENT
---baitap2---
SELECT COUNT(t.signup_action),
ROUND(SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 ELSE 0 END)*1.0 / COUNT(t.signup_action),2)
FROM emails e LEFT JOIN texts t  
ON e.email_id  = t.email_id
WHERE 
  e.email_id IS NOT NULL
---baitap3---
