-- Creating the bank database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS bank_db;
USE bank_db;

-- 1. CREATE TABLES

-- Creating Bank table to store branch information
CREATE TABLE Bank (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100),
    branch_city VARCHAR(100)
);

-- Creating Account Holder table to store customer information
CREATE TABLE Account_Holder (
    account_holder_id INT PRIMARY KEY,
    account_no BIGINT UNIQUE,
    holder_name VARCHAR(100),
    city VARCHAR(100),
    contact VARCHAR(20),
    date_of_account_created DATE,
    account_status VARCHAR(20),   -- Active or Terminated
    account_type VARCHAR(50),     -- e.g. Savings, Current
    balance DECIMAL(15,2)
);

-- Creating Loan table to store loan details
CREATE TABLE Loan (
    loan_no INT PRIMARY KEY,
    branch_id INT,
    account_holder_id INT,
    loan_amount DECIMAL(15,2),
    loan_type VARCHAR(50),
    FOREIGN KEY (branch_id) REFERENCES Bank(branch_id),
    FOREIGN KEY (account_holder_id) REFERENCES Account_Holder(account_holder_id)
);

-- 1A. INSERT SAMPLE RECORDS INTO TABLES

-- Inserting 5 records into Bank table
INSERT INTO Bank (branch_id, branch_name, branch_city) VALUES
(101, 'Bank Of Baroda', 'Ahmedabad'),
(102, 'Reserve Bank Of India', 'Surat'),
(103, 'Indian Bank', 'Ahmedabad'),
(104, 'State Bank OF India', 'Rajkot'),
(105, 'Axis Bank', 'Bhavnagar');

-- Inserting 6 records into Account_Holder table (including account_holder_id = 17)
INSERT INTO Account_Holder (
    account_holder_id, account_no, holder_name, city, contact,
    date_of_account_created, account_status, account_type, balance
) VALUES
(1, 100001, 'Jainam Sheth', 'Ahmedabad', '9876543210', '2025-09-01', 'Active', 'Savings', 15000.00),
(2, 100002, 'Het Patel', 'Ahmedabd', '9123456780', '2025-09-05', 'Active', 'Current', 22000.50),
(3, 100003, 'Shivam Parmar', 'Rajkot++', '9988776655', '2025-09-10', 'Active', 'Savings', 18000.75),
(4, 100004, 'Prince Patel', 'Vadodara', '9090909090', '2025-09-16', 'Terminated', 'Current', 5000.00),
(5, 100005, 'Dev Somaiya', 'Bhavnagar', '9012345678', '2025-09-20', 'Active', 'Savings', 30000.00),
(17, 100017, 'Ravi Mehta', 'Ahmedabad', '9871234567', '2025-09-18', 'Active', 'Savings', 17500.00);

-- Inserting 5 records into Loan table
INSERT INTO Loan (loan_no, branch_id, account_holder_id, loan_amount, loan_type) VALUES
(201, 101, 1, 50000.00, 'Home Loan'),
(202, 102, 2, 25000.00, 'Car Loan'),
(203, 103, 3, 40000.00, 'Education Loan'),
(204, 104, 5, 30000.00, 'Personal Loan'),
(205, 105, 1, 15000.00, 'Gold Loan');

-- 2. TRANSACTION: INTRA-BANK FUND TRANSFER (Account A → B)

-- Example: Transfer $100 from Account A to Account B
START TRANSACTION;

-- Deducting amount from Account A
UPDATE Account_Holder
SET balance = balance - 100
WHERE account_no = 100001;   -- Account A: Jainam Sheth

-- Adding amount to Account B
UPDATE Account_Holder
SET balance = balance + 100
WHERE account_no = 100002;   -- Account B: Het Patel

-- Commit only if both updates are successful
COMMIT;

-- 3. FETCH DETAILS: ACCOUNT HOLDERS FROM SAME CITY
-- Shows all account holders who belong to the same city
SELECT holder_name, city
FROM Account_Holder a1
WHERE EXISTS (
    SELECT 1 FROM Account_Holder a2
    WHERE a1.city = a2.city
    AND a1.account_holder_id <> a2.account_holder_id
);

-- 4. FETCH ACCOUNT NUM & HOLDER NAME (Created after 15th of any month)
SELECT account_no, holder_name
FROM Account_Holder
WHERE DAY(date_of_account_created) > 15;

-- 5. DISPLAY CITY NAME & COUNT OF BRANCHES
SELECT branch_city, COUNT(branch_id) AS Count_Branch
FROM Bank
GROUP BY branch_city;

-- 6. FETCH DETAILS OF LOAN HOLDERS USING JOIN
SELECT 
    ah.account_holder_id,
    ah.holder_name,
    l.branch_id,
    l.loan_amount
FROM Loan l
INNER JOIN Account_Holder ah ON l.account_holder_id = ah.account_holder_id;

-- 7. DROP DATABASE SAFELY:
-- DROP DATABASE bank_db;

