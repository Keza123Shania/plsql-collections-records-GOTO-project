# PL/SQL Assignment: Budget-Controlled Bonus System

This project demonstrates the use of PL/SQL **Collections**, **Records**, and **GOTO** statements to solve a corporate finance problem.

**Author:** Keza Shania
**Course:** INSY 8311
**Group:** C
---

## 1. Problem Statement

The HR department has selected a specific list of employees to receive a performance bonus (10% of their salary). However, the Finance department enforces a strict budget cap of **$15,000** for this bonus round.

The PL/SQL program must:
1.  Loop through the selected list of employee IDs.
2.  Fetch each employee's current salary from the database.
3.  Calculate the projected bonus and add it to a running total.
4.  **Constraint:** If the running total exceeds the budget, the program must **abort immediately** using a GOTO statement to prevent any funds from being allocated incorrectly.

## 2. Solution Description

The solution is a PL/SQL block that simulates a "Budget Safety Check."

1.  **Collection:** It uses a `VARRAY` to hold the list of Employee IDs nominated for the bonus.
2.  **Record:** It uses a `employees%ROWTYPE` record to fetch the full profile (salary, name) of the employee being processed.
3.  **GOTO:** It monitors the `v_current_total_bonus`. If this variable exceeds `v_budget_limit`, the code executes `GOTO budget_breach`, skipping all success logic and jumping to a failure notification.

---

## 3. Technical Demonstration

### A. PL/SQL Collection (VARRAY)
* **Code:** `TYPE t_emp_list IS VARRAY(5) OF NUMBER;`
* **Why:** A `VARRAY` is used because the list of "high performers" is a specific, fixed set of employees provided by HR for this specific batch processing.

### B. PL/SQL Record (%ROWTYPE)
* **Code:** `r_emp employees%ROWTYPE;`
* **Why:** We need to fetch the `salary` to calculate the bonus and the `first_name` for the log output. Using `%ROWTYPE` ensures our variable matches the database structure perfectly.

### C. GOTO Statement
* **Code:** `IF v_total_bonus > v_budget_limit THEN GOTO budget_breach; END IF;`
* **Why:** This demonstrates unconditional branching. If the budget is broken, we do not want to continue the loop or check any other conditions. We need to "pull the emergency brake" immediately and jump to the error handler.

---

## 4. How to Run

1.  Run `setup.sql` to create the sample `employees` table.
2.  Run `solution.sql` with `SERVEROUTPUT ON`.
