-- Component 2

CREATE TABLE Bank_Churn_Dataset(
RowNumber INT Primary Key,
CustomerId INT,
Surname VARCHAR(30),
CreditScore INT,
Geography VARCHAR(30),
Gender VARCHAR(30),
Age INT,
Tenure INT,
Balance FLOAT,
NumOfProducts INT,
HasCrCard INT,
IsActiveMember INT, 
EstimatedSalary FLOAT,
Exited INT
);


-- Component 3

ALTER TABLE Bank_Churn_Dataset
RENAME TO Bank_Churn_info;


SELECT * FROM Bank_Churn_info;

-- number of exited customer 
SELECT count(*) AS total_customers
FROM bank_churn_info
WHERE exited = 1;


-- total churn by geography
SELECT Geography, COUNT(*) AS total, SUM(Exited) AS churned,
ROUND(100.0 * SUM(Exited)::NUMERIC / COUNT(*), 2) AS churn_rate
FROM bank_churn_info
GROUP BY Geography
ORDER BY churn_rate DESC;


-- total churn by gender
SELECT Gender, COUNT(*) AS total, SUM(Exited) AS churned, 
ROUND(100.0 * SUM(Exited)::NUMERIC / COUNT(*), 2) AS churn_rate
FROM bank_churn_info
GROUP BY Gender;



-- total churn by age group 
SELECT 
    CASE 
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '30-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS age_group,
COUNT(*) AS total,
SUM(Exited) AS churned,
ROUND(100.0 * SUM(Exited)::NUMERIC / COUNT(*), 2) AS churn_rate
FROM bank_churn_info
GROUP BY age_group
ORDER BY churn_rate DESC;


-- average balance 
SELECT count(*) AS count, ROUND(AVG(balance)) AS mean,
ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY balance)) AS median
FROM bank_churn_info;



-- average credit score 
SELECT count(*) AS count, ROUND(AVG(creditscore)) AS mean,
ROUND(PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY creditscore)) AS median
FROM bank_churn_info;



-- Component 4

-- a) Top 10 customers by Balance

SELECT * FROM (
    SELECT 
        CustomerId, Surname, Balance,
        RANK() OVER (ORDER BY Balance DESC) AS rank_balance
    FROM bank_churn_info
) 
WHERE rank_balance <= 10
ORDER BY rank_balance;


-- b) Top 5 ranked customers by Credit Score

SELECT * FROM (
    SELECT 
        CustomerId, Surname, CreditScore,
        DENSE_RANK() OVER (ORDER BY CreditScore DESC) AS rank_score
    FROM bank_churn_info
) 
WHERE rank_score <= 5;


-- c) Top 3 active members by balance

SELECT * FROM (
    SELECT 
        CustomerId, Surname, Balance, active_member,
        ROW_NUMBER() OVER (ORDER BY Balance DESC) AS rn
    FROM bank_churn_info
    WHERE active_member = 1
) 
WHERE rn <= 3;


-- Top 5 Selected Customers using criteria which offers a reduced interest rate

SELECT CustomerId, Surname, CreditScore, Balance, active_member, estimatedsalary
FROM bank_churn_info
WHERE active_member = 1
ORDER BY CreditScore DESC, Balance DESC, estimatedsalary DESC
LIMIT 5;

