-- 1-mashq
WITH ranked AS (
    SELECT 
        department_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary) AS rn,
        COUNT(*) OVER (PARTITION BY department_id) AS cnt
    FROM employees
)
SELECT 
    department_id,
    ROUND(AVG(salary), 2) AS median_salary
FROM ranked
WHERE rn IN (FLOOR((cnt + 1)/2), CEIL((cnt + 1)/2))
GROUP BY department_id;
-- 2-mashq
WITH grouped AS (
    SELECT 
        user_id,
        login_date,
        login_date - INTERVAL (ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) - 1) DAY AS grp
    FROM logins
)
SELECT 
    user_id,
    MIN(login_date) AS start_date,
    MAX(login_date) AS end_date,
    COUNT(*) AS consecutive_days
FROM grouped
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;
