--Q1
SELECT *
FROM CITY
WHERE COUNTRY_CODE = 'USA'
AND POPULATION > 100000;

-- Q2
SELECT NAME
FROM CITY
WHERE COUNTRY_CODE = 'USA'
AND POPULATION > 100000;


--Q3
SELECT *
FROM CITY;


--Q4
SELECT *
FROM CITY
WHERE ID = 1661;


--Q5
SELECT *
FROM CITY
WHERE COUNTRY_CODE = 'JPN';


--Q6
SELECT NAME
FROM CITY
WHERE COUNTRY_CODE = 'JPN';


--Q7
SELECT CITY, STATE
FROM STATION;


--Q8
SELECT DISTINCT CITY
FROM STATION
WHERE MOD(ID,2) = 0;



--Q9
SELECT t1.city_count - t2.distinct_city_count
FROM
(
SELECT COUNT(*) AS city_count
FROM STATION
) t1,
(
SELECT COUNT(*) AS distinct_city_count
FROM
(
    SELECT CITY, COUNT(STATE)
    FROM STATION
    GROUP BY CITY
) t3
) t2;



--Q10
WITH CTE AS
(
SELECT
    CITY
    , LENGTH(CITY) AS CITY_LEN
    , RANK() OVER (ORDER BY LENGTH(CITY) DESC, CITY DESC) AS UPPER_RANK
FROM STATION
ORDER BY UPPER_RANK DESC, CITY
)
SELECT CTE.CITY, CTE.CITY_LEN
FROM CTE
WHERE CTE.UPPER_RANK = (SELECT MAX(UPPER_RANK) FROM CTE)
OR CTE.UPPER_RANK = (SELECT MIN(UPPER_RANK) FROM CTE);


--Q11
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE 'A%'
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%'
ORDER BY CITY ASC;


--Q12
SELECT DISTINCT CITY
FROM STATION
WHERE CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u'
ORDER BY CITY ASC;


--Q13
SELECT DISTINCT CITY
FROM STATION
WHERE NOT(CITY LIKE 'A%'
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%')
ORDER BY CITY ASC;


--Q14
SELECT DISTINCT CITY
FROM STATION
WHERE NOT(CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u')
ORDER BY CITY ASC;


--Q15
SELECT DISTINCT CITY
FROM STATION
WHERE
NOT(CITY LIKE 'A%'
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%')
OR
NOT(CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u')
ORDER BY CITY;


--Q16
SELECT DISTINCT CITY
FROM STATION
WHERE
NOT(CITY LIKE 'A%'
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE 'U%')
AND
NOT(CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u')
ORDER BY CITY;


--Q17
(
SELECT SALES.product_id, PRODUCT.product_name
FROM PRODUCT
JOIN SALES ON PRODUCT.product_id = SALES.product_id
WHERE TO_CHAR(SALES.sale_date, 'YYYY-MM-DD') BETWEEN '2019-01-01' AND '2019-03-31'
)
MINUS
(
SELECT SALES.product_id, PRODUCT.product_name
FROM PRODUCT
JOIN SALES ON PRODUCT.product_id = SALES.product_id
WHERE TO_CHAR(SALES.sale_date, 'YYYY-MM-DD') > '2019-03-31'
);



--Q18
SELECT DISTINCT AUTHOR_ID
FROM VIEWS
WHERE AUTHOR_ID = VIEWER_ID
ORDER BY AUTHOR_ID;


--Q19
SELECT ROUND((t2.immediate_deliveries/t1.total_deliveries)*100, 2) AS immediate_percentage
FROM
(
    SELECT COUNT(*) AS total_deliveries
    FROM DELIVERY
) t1,
(
    SELECT COUNT(*) AS immediate_deliveries
    FROM DELIVERY
    WHERE ORDER_DATE = CUSTOMER_PREF_DELIVERY_DATE
) t2
;



--Q20
WITH CTE AS
(
SELECT t1.AD_ID, SUM(t1.clicked_viewed) AS total_clicks, COUNT(t1.clicked_viewed) AS total_views_and_clicks
FROM
(
SELECT
    AD_ID
    , ACTION
    ,CASE 
        WHEN ACTION = 'Clicked' THEN 1
        WHEN ACTION = 'Viewed' THEN 0
        WHEN ACTION = 'Ignored' THEN NULL
    END
    AS clicked_viewed
FROM ADS
) t1
GROUP BY t1.AD_ID
)
SELECT CTE.AD_ID, NVL(ROUND((CTE.total_clicks/CTE.total_views_and_clicks)*100, 2), 0) AS ctr
FROM CTE;



--Q21
SELECT Employee.employee_id, t1.team_size
FROM
(
SELECT team_id, COUNT(*) AS team_size
FROM Employee
GROUP BY team_id
) t1
JOIN Employee
ON t1.team_id = Employee.team_id;



--Q22
WITH CTE AS
(
SELECT Countries.country_id, Countries.country_name, AVG(Weather.weather_state) AS avg_weather
FROM Countries
JOIN Weather ON Countries.country_id = Weather.country_id
WHERE TO_CHAR(Weather.day, 'YYYY-MM-DD') BETWEEN '2019-11-01' AND '2019-11-30'
GROUP BY Countries.country_id, Countries.country_name
)
SELECT
    country_name
    , CASE
        WHEN avg_weather <= 15 THEN 'Cold'
        WHEN avg_weather >= 25 THEN 'Hot'
        ELSE 'Warm'
    END
    AS weather_type
FROM CTE;


--Q23
WITH CTE AS
(
SELECT Prices.product_id, SUM(Prices.price * Units_Sold.units) AS total_amount, SUM(Units_Sold.units) AS total_units
FROM Prices
JOIN Units_Sold ON Prices.product_id = Units_Sold.product_id
WHERE TO_CHAR(Units_Sold.purchase_date) BETWEEN TO_CHAR(Prices.start_date) AND TO_CHAR(Prices.end_date)
GROUP BY Prices.product_id
)
SELECT product_id, ROUND(total_amount/total_units, 2) AS average_price
FROM CTE;



--Q24
SELECT player_id, TO_CHAR(MIN(event_date), 'YYYY-MM-DD') AS first_login
FROM Activity
GROUP BY player_id;


--Q25
SELECT a.player_id, a.device_id
FROM Activity a
JOIN
(
SELECT player_id, TO_CHAR(MIN(event_date), 'YYYY-MM-DD') AS first_login
FROM Activity
GROUP BY player_id
) t
ON a.player_id = t.player_id
WHERE TO_CHAR(a.event_date, 'YYYY-MM-DD') = t.first_login;



--Q26
SELECT Products.product_name, SUM(unit)
FROM Products
JOIN Orders ON Products.product_id = Orders.product_id
WHERE TO_CHAR(Orders.order_date, 'YYYY-MM-DD') BETWEEN '2020-02-01' AND '2020-02-29' 
GROUP BY Products.product_name
HAVING SUM(unit)>=100;



--Q27
SELECT *
FROM Users
WHERE REGEXP_LIKE(mail, '^[a-zA-Z][a-zA-Z0-9_.-]*@leetcode\.com$');



--Q28
WITH CTE AS
(
SELECT t1.CUSTOMER_ID, COUNT(*) AS total_count
FROM
(
SELECT 
    Orders_28.CUSTOMER_ID
    , EXTRACT(MONTH FROM Orders_28.ORDER_DATE) AS order_month
    , SUM(Orders_28.QUANTITY * Products_28.price) AS amount_spent
FROM Orders_28
JOIN Products_28 ON Products_28.PRODUCT_ID = Orders_28.PRODUCT_ID
WHERE EXTRACT(MONTH FROM Orders_28.ORDER_DATE) IN (6,7)
GROUP BY Orders_28.CUSTOMER_ID, order_month
HAVING SUM(Orders_28.QUANTITY * Products_28.price) >=100
ORDER BY Orders_28.CUSTOMER_ID
) t1
GROUP BY t1.CUSTOMER_ID
)
SELECT  c.CUSTOMER_ID, c.name
FROM CTE cte, Customers c
WHERE cte.CUSTOMER_ID = c.CUSTOMER_ID
AND cte.total_count = 2;



--Q29
SELECT DISTINCT CONTENT.title
FROM TV_PROGRAM
JOIN CONTENT ON TV_PROGRAM.content_id = CONTENT.content_id
WHERE CONTENT.kids_content = 'Y'
AND EXTRACT (MONTH FROM TV_PROGRAM.program_date) = 6
AND CONTENT.content_type = 'Movies';


--Q30
SELECT QUERIES.id, QUERIES.year, NVL(NPV.npv, 0)
FROM QUERIES
LEFT JOIN NPV 
ON (QUERIES.id = NPV.id AND QUERIES.year = NPV.year)
ORDER BY QUERIES.id;


--Q31
SELECT QUERIES.id, QUERIES.year, NVL(NPV.npv, 0)
FROM QUERIES
LEFT JOIN NPV 
ON (QUERIES.id = NPV.id AND QUERIES.year = NPV.year)
ORDER BY QUERIES.id;


--Q32
SELECT Employee_UNI.unique_id, Employees.name
FROM Employees
LEFT JOIN Employee_UNI ON Employees.id = Employee_UNI.id
ORDER BY Employees.name;


--Q33
SELECT Users_detail.name, NVL(SUM(Rides.distance), 0) AS travelled_distance
FROM Users_detail
LEFT JOIN Rides ON Users_detail.id = Rides.user_id
GROUP BY Users_detail.name
ORDER BY travelled_distance DESC, Users_detail.name ASC; 


--Q34
SELECT Products.product_name, SUM(unit)
FROM Products
JOIN Orders ON Products.product_id = Orders.product_id
WHERE TO_CHAR(Orders.order_date, 'YYYY-MM-DD') BETWEEN '2020-02-01' AND '2020-02-29' 
GROUP BY Products.product_name
HAVING SUM(unit)>=100;



--Q35
SELECT name AS results
FROM(
SELECT Users_35.name, COUNT(*) AS rating_count
FROM Users_35
JOIN Movie_Rating ON Users_35.user_id = Movie_rating.user_id
GROUP BY Users_35.name
ORDER BY rating_count DESC, Users_35.name ASC
FETCH FIRST 1 ROW ONLY
)
UNION
(
SELECT title AS results
FROM(
SELECT Movies.title, AVG(movie_rating.rating) AS avg_rating
FROM Movies
JOIN Movie_Rating ON Movies.movie_id = Movie_Rating.movie_id
WHERE TO_CHAR(Movie_rating.created_at, 'YYYY-MM-DD') BETWEEN '2020-02-01' AND '2020-02-29'
GROUP BY Movies.title
ORDER BY avg_rating DESC, Movies.title ASC
FETCH FIRST 1 ROW ONLY
)
);



--Q36
SELECT Users_detail.name, NVL(SUM(Rides.distance), 0) AS travelled_distance
FROM Users_detail
LEFT JOIN Rides ON Users_detail.id = Rides.user_id
GROUP BY Users_detail.name
ORDER BY travelled_distance DESC, Users_detail.name ASC;


--Q37
SELECT Employee_UNI.unique_id, Employees.name
FROM Employees
LEFT JOIN Employee_UNI ON Employees.id = Employee_UNI.id
ORDER BY Employees.name;




--Q38
SELECT Students.id, Students.name
FROM Students
LEFT JOIN Departments ON Students.department_id = Departments.id
WHERE Departments.name IS NULL;


--Q39
WITH CTE AS
(
SELECT from_id, to_id, SUM(duration) AS dur
FROM Calls
GROUP BY from_id, to_id
), CTE2 AS
(
SELECT
    c1.from_id, c1.to_id, NVL(c1.dur, 0) + NVL(c2.dur, 0) AS total_dur
FROM CTE c1
LEFT JOIN CTE c2
ON c1.from_id = c2.to_id
AND c1.to_id = c2.from_id
ORDER BY c1.from_id
)
SELECT *
FROM CTE2
WHERE from_id < to_id;



--Q40
WITH CTE AS
(
SELECT Prices.product_id, SUM(Prices.price * Units_Sold.units) AS total_amount, SUM(Units_Sold.units) AS total_units
FROM Prices
JOIN Units_Sold ON Prices.product_id = Units_Sold.product_id
WHERE TO_CHAR(Units_Sold.purchase_date) BETWEEN TO_CHAR(Prices.start_date) AND TO_CHAR(Prices.end_date)
GROUP BY Prices.product_id
)
SELECT product_id, ROUND(total_amount/total_units, 2) AS average_price
FROM CTE;



















