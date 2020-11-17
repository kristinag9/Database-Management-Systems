-- Problem 1
-- List employee number, last name, date of birth, and salary for all employees who
-- make more than $30,000 a year. Sequence the results in descending order by
-- salary.
SELECT EMPNO, LASTNAME, BIRTHDATE, SALARY
FROM EMP
WHERE SALARY > 30000
ORDER BY SALARY DESC;

-- Problem 2
-- List last name, first name, and the department number for all employees.
-- The listing should be ordered by descending department numbers.
-- Within the same department, the last names should be sorted in descending order.
SELECT LASTNAME, FIRSTNME, WORKDEPT
FROM EMP
ORDER BY WORKDEPT, LASTNAME DESC;

-- Problem 3
-- List the different education levels in the company in descending order.
-- List only one occurrence of duplicate result rows.
SELECT DISTINCT EDLEVEL
FROM EMP
ORDER BY EDLEVEL DESC;

-- Problem 4
-- List employees, by employee number, and their assigned projects, by project
-- number. Display only those employees with an employee number less than or equal
-- to 100. List only one occurrence of duplicate rows. Sort the result rows by employee
-- number. (Use the EMP_ACT table.)
SELECT EMPNO, PROJNO
FROM EMP_ACT
WHERE EMPNO <= '000100'
ORDER BY EMPNO;

-- Problem 5
-- List last name, salary, and bonus of all male employees.
SELECT LASTNAME, SALARY, BONUS
FROM EMP
WHERE SEX = 'M';

-- Problem 6
-- List last name, salary, and commission for all employees with a salary greater than
-- $20,000 and hired after 1979.
SELECT LASTNAME, SALARY, COMM
FROM EMP
WHERE SALARY > 20000 AND HIREDATE > '1980-01-01';

-- Problem 7
-- List last name, salary, bonus, and commission for all employees with a salary
-- greater than $22,000 and a bonus of $400, or for all employees with a bonus of
-- $500 and a commission lower than $1,900. The list should be ordered by last name.
SELECT LASTNAME, SALARY, BONUS, COMM
FROM EMP
WHERE SALARY > 22000 AND BONUS = 400 OR BONUS = 500 AND COMM < 1900
ORDER BY LASTNAME;

-- Problem 8
-- List last name, salary, bonus, and commission for all employees with a salary
-- greater than $22,000, a bonus of $400 or $500, and a commission less than $1,900.
-- The list should be ordered by last name.
-- 1st solution
SELECT LASTNAME, SALARY, BONUS, COMM
FROM EMP
WHERE SALARY > 22000 AND BONUS IN (400, 500) AND COMM < 1900
ORDER BY LASTNAME;

-- 2nd solution
SELECT LASTNAME, SALARY, BONUS, COMM
FROM EMP
WHERE SALARY > 22000 AND (BONUS = 400 OR BONUS = 500) AND COMM < 1900
ORDER BY LASTNAME;

-- Problem 9
-- Using the EMP_ACT table, for all projects that have a project number beginning with
-- AD and have activities 10, 80, and 180 associated with them, list the following:
--  • Project number
--  • Activity number
--  • Starting date for activity
--  • Ending date for activity
-- Order the list by activity number within project number.
SELECT PROJNO, ACTNO, EMSTDATE, EMENDATE
FROM EMP_ACT
WHERE PROJNO LIKE 'AD%' AND ACTNO IN (10, 80, 180)
ORDER BY PROJNO, ACTNO;

-- Problem 10
-- List manager number and department number for all departments to which a
-- manager has been assigned.
-- The list should be ordered by manager number.
SELECT MGRNO, DEPTNO
FROM DEPT
WHERE MGRNO IS NOT NULL
ORDER BY MGRNO;

-- Problem 11
-- List employee number, last name, salary, and bonus for all employees that have a
-- bonus ranging from $800 to $1,000.
-- Sort the report by employee number within bonus, lowest bonus first.
SELECT EMPNO, LASTNAME, SALARY, BONUS
FROM EMP
WHERE BONUS BETWEEN 800 AND 1000
ORDER BY BONUS, EMPNO;

-- Problem 12
-- List employee number, last name, salary, and department number for all employees
-- in departments A00 through C01 (inclusive).
-- Order the results alphabetically by last name and employee number.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE WORKDEPT BETWEEN 'A00' AND 'C01'
ORDER BY LASTNAME, EMPNO;

-- Problem 13
-- List all projects that have SUPPORT as part of the project name. Order the results
-- by project number.
SELECT PROJNO, PROJNAME
FROM PROJ
WHERE PROJNAME LIKE '%SUPPORT%'
ORDER BY PROJNO;

-- Problem 14
-- List all departments that have a 1 as the middle character in the department number.
-- Order the results by department number.
SELECT DEPTNAME, DEPTNO
FROM DEPT
WHERE DEPTNO LIKE '_1_'
ORDER BY DEPTNO;

-- Problem 15
-- List the last name, first name, middle initial, and salary of the five highest paid
-- non-manager, non-president employees. Order the results by highest salary first
SELECT LASTNAME, FIRSTNME, MIDINIT, SALARY
FROM EMP
WHERE JOB NOT IN ('MANAGER', 'PRES')
ORDER BY SALARY DESC
FETCH FIRST 5 ROWS ONLY;