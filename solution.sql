-- ----------------------------------------------------
-- solution.sql
--
-- Scenario: Processing strict budget checks for bonuses.
-- Problem: Calculate 10% bonuses for a list of employees.
--          If total exceeds $15,000, ABORT with GOTO.
-- ----------------------------------------------------
SET SERVEROUTPUT ON;

DECLARE
    -- 1. COLLECTION: A fixed list of employees chosen for the bonus
    TYPE t_emp_list IS VARRAY(5) OF NUMBER;
    v_selected_employees t_emp_list;

    -- 2. RECORD: To hold the employee data from the DB
    r_emp employees%ROWTYPE;

    -- Variables for calculation
    v_budget_limit CONSTANT NUMBER := 15000; -- Strict Cap
    v_total_bonus           NUMBER := 0;
    v_individual_bonus      NUMBER := 0;
    v_index                 NUMBER;

BEGIN
    -- Initialize the Collection (The HR List)
    -- We are selecting employees 101, 102, and 103
    v_selected_employees := t_emp_list(101, 102, 103);

    DBMS_OUTPUT.PUT_LINE('--- Starting Budget Check ---');
    DBMS_OUTPUT.PUT_LINE('Budget Limit: $' || v_budget_limit);

    -- Loop through the Collection
    FOR i IN 1 .. v_selected_employees.COUNT LOOP
        
        -- Fetch details using the RECORD
        SELECT * INTO r_emp 
        FROM employees 
        WHERE employee_id = v_selected_employees(i);

        -- Calculate 10% bonus
        v_individual_bonus := r_emp.salary * 0.10;
        
        -- Add to running total
        v_total_bonus := v_total_bonus + v_individual_bonus;

        DBMS_OUTPUT.PUT_LINE('Processing: ' || r_emp.first_name || 
                             ' | Bonus: $' || v_individual_bonus || 
                             ' | Running Total: $' || v_total_bonus);

        -- 3. GOTO CHECK
        -- If we just broke the budget, STOP EVERYTHING immediately.
        IF v_total_bonus > v_budget_limit THEN
            GOTO budget_breach;
        END IF;

    END LOOP;

    -- SUCCESS BLOCK (Only runs if GOTO never happened)
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    DBMS_OUTPUT.PUT_LINE('SUCCESS: Budget Approved. Total Payout: $' || v_total_bonus);
    
    -- Skip the error handler
    GOTO end_script;

    -- FAIL BLOCK (The Target of the GOTO)
    <<budget_breach>>
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
    DBMS_OUTPUT.PUT_LINE('!!! ALARM: BUDGET EXCEEDED !!!');
    DBMS_OUTPUT.PUT_LINE('Execution halted. Total required ($' || v_total_bonus || 
                         ') is higher than limit ($' || v_budget_limit || ').');
    DBMS_OUTPUT.PUT_LINE('Batch Rejected.');

    <<end_script>>
    DBMS_OUTPUT.PUT_LINE('--- Process Finished ---');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('System Error: ' || SQLERRM);
END;
/
