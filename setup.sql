-- ----------------------------------------------------
-- setup.sql
-- Creates a simple 'employees' table for the HR scenario
-- ----------------------------------------------------
SET SERVEROUTPUT ON;

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE employees';
EXCEPTION
   WHEN OTHERS THEN NULL; -- Ignore error if table doesn't exist
END;
/

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name  VARCHAR2(50),
    salary      NUMBER(10, 2)
);

-- Insert sample data
-- Employee 101 earns $60,000 (Bonus will be $6,000)
INSERT INTO employees VALUES (101, 'Alice', 60000);

-- Employee 102 earns $50,000 (Bonus will be $5,000)
INSERT INTO employees VALUES (102, 'Bob', 50000);

-- Employee 103 earns $80,000 (Bonus will be $8,000)
-- Note: 6k + 5k + 8k = 19k. This will BREAK the 15k budget.
INSERT INTO employees VALUES (103, 'Charlie', 80000);

COMMIT;
DBMS_OUTPUT.PUT_LINE('Employees table created.');
/
