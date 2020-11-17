-- Problem 1
-- For all departments, display department number and the sum of all salaries for each
-- department. Name the derived column SUM_SALARY.
SELECT WORKDEPT, SUM(SALARY) AS SUM_SALARY
FROM EMP
GROUP BY WORKDEPT;

-- Problem 2
-- For all departments, display the department number and the number of employees.
-- Name the derived column EMP_COUNT.
SELECT WORKDEPT, COUNT(*) AS EMP_COUNT
FROM EMP
GROUP BY WORKDEPT;

-- Problem 3
-- Display those departments which have more than 3 employees.
SELECT WORKDEPT
FROM EMP
GROUP BY WORKDEPT
HAVING COUNT(*) > 3;

-- Problem 4
-- For all departments with at least one designer, display the number of designers and
-- the department number. Name the derived column DESIGNER.
SELECT WORKDEPT, COUNT(*) AS DESIGNER
FROM EMP
WHERE JOB = 'DESIGNER'
GROUP BY WORKDEPT;

-- Problem 5
-- Show the average salary for men and the average salary for women for each
-- department. Display the work department, the sex, the average salary, average
-- bonus, average commission, and the number of people in each group. Include only
-- those groups that have two or more people. Show only two decimal places in the
-- averages.
-- Use the following names for the derived columns: AVG-SALARY, AVG-BONUS,
-- AVG-COMM, and COUNT.
SELECT WORKDEPT, SEX, DECIMAL(AVG(SALARY), 9, 2) AS "AVG-SALARY",
       DECIMAL(AVG(BONUS), 8, 2) AS "AVG-BONUS", DECIMAL(AVG(COMM), 8, 2) AS "AVG-COMM",
       COUNT(*) AS COUNT
FROM EMP
GROUP BY WORKDEPT, SEX
HAVING COUNT(*) > 1;

-- Problem 6
-- Display the average bonus and average commission for all departments with an
-- average bonus greater than $500 and an average commission greater than $2,000.
-- Display all averages with two digits to the right of the decimal point. Use the column
-- headings AVG-BONUS and AVG-COMM for the derived columns.
SELECT DECIMAL(AVG(BONUS), 8, 2) AS "AVG-BONUS", DECIMAL(AVG(COMM), 8, 2) AS "AVG-COMM"
FROM EMP
GROUP BY WORKDEPT
HAVING AVG(BONUS) > 500 AND AVG(COMM) > 2000;

-- Problem 7
-- Joe's manager wants information about employees which match the following
-- criteria:
--  • Their yearly salary is between 22000 and 24000.
--  • They work in departments D11 or D21.
-- List the employee number, last name, yearly salary, and department number of the
-- appropriate employees.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE SALARY BETWEEN 30000 AND 40000 AND WORKDEPT IN ('D11', 'D21');

-- Problem 8
-- Now, Joe's manager wants information about the yearly salary. He wants to know
-- the minimum, the maximum, and average yearly salary of all employees with an
-- education level of 16. He also wants to know how many employees have this
-- education level.
SELECT MIN(SALARY), MAX(SALARY), DECIMAL(AVG(SALARY), 9, 2), COUNT(*) AS CNT
FROM EMP
WHERE EDLEVEL = 16;

-- Problem 9
-- Joe's manager is interested in some additional salary information. This time, he
-- wants information for every department that appears in the EMPLOYEE table,
-- provided that the department has more than five employees. The report needs to
-- show the department number, the minimum, maximum, and average yearly salary,
-- and the number of employees who work in the department.
SELECT WORKDEPT, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY,
       DECIMAL(AVG(SALARY), 9, 2) AS AVG_SALARY, COUNT(*) AS CNT_EMP
FROM EMP
GROUP BY WORKDEPT
HAVING COUNT(*) > 5;

-- Problem 10
-- Joe's manager wants information about employees grouped by department,
-- grouped by sex and in addition by the combination of department and sex. List only
-- those who work in a department which start with the letter D.
-- List the department, the sex, sum of the salaries, minimum salary and maximum
-- salary.
SELECT WORKDEPT, SEX, SUM(SALARY) AS SUM_SALARY, MIN(SALARY) AS MIN_SALARY,
       MAX(SALARY) AS MAX_SALARY
FROM EMP
WHERE WORKDEPT LIKE 'D%'
GROUP BY CUBE(WORKDEPT, SEX);

-- Problem 11
-- Joe's manager wants information about the average total salary for all departments.
-- List in department order, the department, average total salary and rank over the
-- average total salary
SELECT WORKDEPT, DECIMAL(AVG(SALARY + BONUS), 9, 2) AS AVG_TOTAL,
       RANK() over (ORDER BY DECIMAL(AVG(SALARY + BONUS), 9, 2)) AS RANK_TOTAL
FROM EMP
GROUP BY WORKDEPT
ORDER BY WORKDEPT;