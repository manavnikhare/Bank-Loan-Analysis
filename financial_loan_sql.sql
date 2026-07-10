CREATE TABLE financial_loan (
    id BIGINT PRIMARY KEY,
    address_state VARCHAR(5),
    application_type VARCHAR(50),
    emp_length VARCHAR(30),
    emp_title VARCHAR(150),
    grade CHAR(1),
    home_ownership VARCHAR(30),

    issue_date DATE,
    last_credit_pull_date DATE,
    last_payment_date DATE,

    loan_status VARCHAR(50),

    next_payment_date DATE,

    member_id BIGINT,
    purpose VARCHAR(100),
    sub_grade VARCHAR(5),
    term VARCHAR(20),
    verification_status VARCHAR(50),

    annual_income NUMERIC(12,2),
    dti NUMERIC(6,2),
    installment NUMERIC(10,2),
    int_rate NUMERIC(5,2),
    loan_amount NUMERIC(12,2),

    total_acc INTEGER,
    total_payment NUMERIC(12,2)
);

SELECT ordinal_position, column_name
FROM information_schema.columns
WHERE table_name = 'financial_loan'
ORDER BY ordinal_position;

COPY financial_loan
FROM 'C:/Users/DELL/OneDrive/Desktop/projects/project2 bank loan analysis/financial_loan.csv'
DELIMITER ','
CSV HEADER;

select * from financial_loan;

--total loan application 
select count(id) as total_loan_applications from financial_loan;

--MTD loan applications
SELECT COUNT(id) AS MTD_loan_applications FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD loan applications  previuos month to date 
SELECT COUNT(id) AS PMTD_loan_applications FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

/*MOM loan applications=
(MTD-PMTD)/PMTD
*/

--total funded amount 
select sum(loan_amount) as total_loan_funded_by_bank
from financial_loan;

--MTD total funded amount 
select sum(loan_amount) as total_loan_funded_by_bank
from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD total funded amount 
select sum(loan_amount) as total_loan_funded_by_bank
from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

  
--Total amount recievd 
select sum(total_payment) as total_amount_recieved
from financial_loan;

--MTD Total amount recievd 
select sum(total_payment) as total_amount_recieved
from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD Total amount recievd 
select sum(total_payment) as total_amount_recieved
from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--AVG interest rate 
select round(avg(int_rate)*100,2) as avg_interest_rate from financial_loan;

--MTD AVG interest rate 
select round(avg(int_rate)*100,2) as avg_interest_rate from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;
  
--PMTD AVG interest rate
select round(avg(int_rate)*100,2) as avg_interest_rate from financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;


ALTER TABLE financial_loan
ALTER COLUMN dti TYPE NUMERIC;

TRUNCATE TABLE financial_loan;

COPY financial_loan
FROM 'C:/Users/DELL/OneDrive/Desktop/projects/project2 bank loan analysis/financial_loan.csv'
DELIMITER ','
CSV HEADER;

SELECT dti
FROM financial_loan
LIMIT 5;


--AVG DTI 
SELECT
    round(AVG(dti),4)*100 AS average_dti
FROM financial_loan;


/* since we were not getting same values of sum and avg of dti this was becoz the table we made earlier had datatype of dti as numeric(6,2)
because of which our values were already rounded off so our value came out to be wrong 
so we changed datatype to numeric only so no restriction on decimal */


--MTD AVG DTI 
SELECT
    round(AVG(dti),4)*100 AS mtd_average_dti
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 12
  AND EXTRACT(YEAR FROM issue_date) = 2021;

--PMTD AVG DTI 
SELECT
    round(AVG(dti),4)*100 AS pmtd_average_dti
FROM financial_loan
WHERE EXTRACT(MONTH FROM issue_date) = 11
  AND EXTRACT(YEAR FROM issue_date) = 2021;

  select * from financial_loan;
   select loan_status from financial_loan;

--good loan percentage 
select (count(case when loan_status ='Fully Paid' or loan_status = 'Current' then id end)*100.00)/ (count(id)) as good_loan_percentage
from financial_loan;

--good loan applications
select count(id) as good_loan_applications
from financial_loan
where loan_status='Fully Paid' or loan_status='Current';

--good loan amount funded 
select sum(loan_amount) as good_loan_amount_funded
from financial_loan
where loan_status='Fully Paid' or loan_status='Current';

--good loan amount recieved 
select sum(total_payment) as good_loan_amount_recieved
from financial_loan
where loan_status='Fully Paid' or loan_status='Current';

--bad loan percentage 
select (count(case when loan_status ='Charged Off' then id end)*100.00)/ (count(id)) as bad_loan_percentage
from financial_loan;

--bad loan application 
select count(id) as bad_loan_applications
from financial_loan
where loan_status='Charged Off';

--bad loan amount funded 
select sum(loan_amount) as bad_loan_amount_funded
from financial_loan
where loan_status='Charged Off';

--bad loan amount recieved 
select sum(total_payment) as bad_loan_amount_recieved
from financial_loan
where loan_status='Charged Off';

--Loan application grid 
SELECT
        loan_status,
        COUNT(id) AS Total_loan_application,
        SUM(total_payment) AS Total_Amount_Received,
        SUM(loan_amount) AS Total_Funded_Amount,
        AVG(int_rate * 100) AS Interest_Rate,
        AVG(dti * 100) AS DTI
    FROM
        financial_loan
    GROUP BY
        loan_status;


--MTD total amount funded
SELECT
        loan_status,
        SUM(total_payment) AS MTD_Total_Amount_Received,
        SUM(loan_amount) AS MTD_Total_Funded_Amount
    FROM
        financial_loan
		WHERE EXTRACT(MONTH FROM issue_date) = 12
    GROUP BY
        loan_status;

--PMTD total amount funded
SELECT
        loan_status,
        SUM(total_payment) AS PMTD_Total_Amount_Received,
        SUM(loan_amount) AS PMTD_Total_Funded_Amount
    FROM
        financial_loan
		WHERE EXTRACT(MONTH FROM issue_date) = 11
    GROUP BY
        loan_status;

--Bank Loan Report
--MONTH
SELECT EXTRACT(MONTH FROM issue_date) as month_number,
TO_CHAR(issue_date, 'Month') AS month_name,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by TO_CHAR(issue_date, 'Month'),
 EXTRACT(MONTH FROM issue_date)
order by EXTRACT(MONTH FROM issue_date);

--STATE
SELECT   address_state,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by address_state
order by address_state;


--TERM
SELECT  term,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by term
order by term;


--EMPLOYEE LENGTH
SELECT  emp_length,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by emp_length
order by emp_length;

SELECT  emp_length,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by emp_length
order by     CASE emp_length
        WHEN '< 1 year' THEN 0
        WHEN '1 year' THEN 1
        WHEN '2 years' THEN 2
        WHEN '3 years' THEN 3
        WHEN '4 years' THEN 4
        WHEN '5 years' THEN 5
        WHEN '6 years' THEN 6
        WHEN '7 years' THEN 7
        WHEN '8 years' THEN 8
        WHEN '9 years' THEN 9
        WHEN '10+ years' THEN 10
        ELSE 11
    END;


--PURPOSE
SELECT   purpose,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by purpose
order by purpose;

--PURPOSE 
SELECT   purpose,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
where grade='A'
group by purpose
order by purpose;


SELECT   home_ownership,
        COUNT(id) AS Total_loan_application,
		 SUM(loan_amount) AS Total_Funded_Amount,
        SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
group by home_ownership
order by home_ownership;

SELECT current_user;