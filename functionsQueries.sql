-- Problem 1
-- For employees whose salary, increased by 5 percent, is less than or equal to
-- $40,000, list the following:
--  • Last name
--  • Current Salary
--  • Salary increased by 5 percent
--  • Monthly salary increased by 5 percent
-- Use the following column names for the two generated columns:
-- INC-Y-SALARY and INC-M-SALARY Use the proper conversion function to display
-- the increased salary and monthly salary with two of the digits to the right of the
-- decimal point. Sort the results by annual salary.
SELECT LASTNAME, SALARY, DECIMAL(SALARY*1.05, 9, 2) AS "INC-Y-SALARY",
                         DECIMAL(SALARY*1.05/12, 9, 2) AS "INC-M-SALARY"
FROM EMP
WHERE SALARY*1.05 <= 40000
ORDER BY SALARY;

-- Problem 2
-- All employees with an education level of 18 or 20 will receive a salary increase of
-- $1,200 and their bonus will be cut in half. List last name, education level, new salary,
-- and new bonus for these employees. Display the new bonus with two digits to the
-- right of the decimal point.
-- Use the column names NEW-SALARY and NEW-BONUS for the generated
-- columns.
-- Employees with an education level of 20 should be listed first. For employees with
-- the same education level, sort the list by salary.
SELECT LASTNAME, EDLEVEL, SALARY + 1200 AS "NEW-SALARY",
       DECIMAL(BONUS / 2, 9, 2) AS "NEW-BONUS"
FROM EMP
WHERE EDLEVEL IN (18, 20)
ORDER BY EDLEVEL DESC, "NEW-BONUS";

-- Problem 3
-- The salary will be decreased by $1,000 for all employees matching the following
-- criteria:
--  • They belong to department D11
--  • Their salary is more than or equal to 80 percent of $20,000
--  • Their salary is less than or equal to 120 percent of $20,000
-- Use the name DECR-SALARY for the generated column.
-- List department number, last name, salary, and decreased salary. Sort the result by
-- salary.
SELECT WORKDEPT, LASTNAME, SALARY, SALARY - 1000 AS "DESC-SALARY"
FROM EMP
WHERE WORKDEPT = 'D11' AND SALARY BETWEEN 40000*0.80 AND 40000*1.20
ORDER BY SALARY;

-- Problem 4
-- Produce a list of all employees in department D11 that have an income (sum of
-- salary, commission, and bonus) that is greater than their salary increased by 10 percent.
-- Name the generated column INCOME.
-- List department number, last name, and income. Sort the result in descending order
-- by income.
-- For this problem assume that all employees have non-null salaries, commissions,
-- and bonuses.
SELECT WORKDEPT, LASTNAME, SALARY + COMM + BONUS AS INCOME
FROM EMP
WHERE WORKDEPT = 'D11' AND SALARY + COMM + BONUS > SALARY * 0.1
ORDER BY INCOME DESC;

-- Problem 5
-- List all departments that have no manager assigned. List department number,
-- department name, and manager number. Replace unknown manager numbers with
-- the word UNKNOWN and name the column MGRNO.
SELECT DEPTNO, DEPTNAME, COALESCE(MGRNO, 'UNKNOWN') AS MGRNO
FROM DEPT
WHERE MGRNO IS NULL;


-- Problem 6
-- List the project number and major project number for all projects that have a project
-- number beginning with MA. If the major project number is unknown, display the text
-- 'MAIN PROJECT.' Name the derived column MAJOR PROJECT.
-- Sequence the results by PROJNO.
SELECT PROJNO, COALESCE(MAJPROJ, 'MAIN PROJECT') AS "MAJOR PROJECT"
FROM PROJECT
--WHERE PROJNAME LIKE 'MA%'
WHERE SUBSTR(PROJNAME, 1,2) = 'MA'
ORDER BY PROJNO;

-- Problem 7
-- List all employees who were younger than 25 when they joined the company.
-- List their employee number, last name, and age when they joined the company.
-- Name the derived column AGE.  Sort the result by age and then by employee number.
SELECT EMPNO, LASTNAME, YEAR(HIREDATE - BIRTHDATE) AS AGE
FROM EMP
WHERE YEAR(HIREDATE - BIRTHDATE) < 25
ORDER BY AGE, EMPNO;

-- Problem 8
-- Provide a list of all projects which ended on December 1, 1982. Display the year and
-- month of the starting date and the project number. Sort the result by project number.
-- Name the derived columns YEAR and MONTH.
SELECT YEAR(PRSTDATE) AS YEAR, MONTH(PRSTDATE) AS MONTH, PROJNO
FROM PROJECT
WHERE PRENDATE = '1982-12-01'
ORDER BY PROJNO;

-- Problem 9
-- List the project number and duration, in weeks, of all projects that have a project
-- number beginning with MA. The duration should be rounded and displayed with one
-- decimal position. Name the derived column WEEKS.
-- Order the list by the project number.
SELECT PROJNO, DECIMAL((DAYS(PRENDATE) - DAYS(PRSTDATE))/7,8, 1) AS WEEKS
FROM PROJECT
WHERE PROJNO LIKE 'MA%'
ORDER BY PROJNO;

-- Problem 10
-- For projects that have a project number beginning with MA, list the project number,
-- project ending date, and a modified ending date assuming the projects will be
-- delayed by 10 percent.
-- Name the column containing PRENDATE, ESTIMATED. Name the derived column EXPECTED.
-- Order the list by project number.
SELECT PROJNO, PRENDATE AS ESTIMATEED,
       PRSTDATE + ((DAYS(PRENDATE) - DAYS(PRSTDATE))*1.1) DAYS AS EXPECTED
FROM PROJ
WHERE PROJNO LIKE 'MA%'
ORDER BY PROJNO;