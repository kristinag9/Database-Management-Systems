-- Problem 1
-- List those employees that have a salary which is greater than or equal to the
-- average salary of all employees plus $5,000.
-- Display department number, employee number, last name, and salary. Sort the list
-- by the department number and employee number.
SELECT WORKDEPT, EMPNO, LASTNAME, SALARY
FROM EMP
WHERE SALARY >= (SELECT AVG(SALARY) + 5000 FROM EMP)
ORDER BY WORKDEPT, EMPNO;

-- Problem 2
-- List employee number and last name of all employees not assigned to any projects.
-- This means that table EMP_ACT does not contain a row with their employee number.
SELECT EMPNO, LASTNAME
FROM EMP
WHERE EMPNO NOT IN (SELECT EMPNO FROM EMP_ACT);

-- Problem 3
-- List project number and duration (in days) of the project
-- with the shortest duration. Name the derived column DAYS.
SELECT PROJNO, DAYS(PRENDATE) - DAYS(PRSTDATE) AS DAYS
FROM PROJECT
WHERE DAYS(PRENDATE) - DAYS(PRSTDATE) =
      (SELECT MIN(DAYS(PRENDATE) - DAYS(PRSTDATE)) FROM PROJ WHERE PRENDATE > PRSTDATE);

-- Problem 4
-- List department number, department name, last name, and first name of all those
-- employees in departments that have only male employees.
SELECT E.WORKDEPT, D.DEPTNAME, E.LASTNAME, E.FIRSTNME, E.SEX
FROM DEPT D, EMP E
WHERE E.WORKDEPT = D.DEPTNO
AND E.WORKDEPT NOT IN(SELECT WORKDEPT FROM EMP WHERE SEX = 'F')
ORDER BY E.WORKDEPT;

-- Problem 5
-- We want to do a salary analysis for people that have the same job and education
-- level as the employee Stern. Show the last name, job, edlevel, the number of years
-- they've worked as of January 1, 2000, and their salary.
-- Name the derived column YEARS.
-- Sort the listing by highest salary first.
SELECT LASTNAME, JOB, EDLEVEL, YEAR('2000-01-01' - HIREDATE) AS YEARS, SALARY
FROM EMP
WHERE (JOB, EDLEVEL) IN (SELECT JOB, EDLEVEL FROM EMP WHERE LASTNAME = 'STERN')
ORDER BY SALARY DESC;

-- Problem 6
-- Retrieve all employees who are not involved in a project. Not involved in a project
-- are those employees who have no row in the EMP_ACT table. Display employee
-- number, last name, and department name.
SELECT EMPNO, LASTNAME, DEPTNAME
FROM EMP, DEPARTMENT
WHERE WORKDEPT = DEPTNO AND EMPNO NOT IN (SELECT EMPNO FROM EMP_ACT);

-- Problem 7
-- Retrieve all employees whose yearly salary is more than the average salary of the
-- employees in their department. For example, if the average yearly salary for
-- department E11 is 20998, show all people in department E11 whose individual
-- salary is higher than 20998. Display department number, employee number, and
-- yearly salary. Sort the result by department number and employee number.
SELECT WORKDEPT, EMPNO, SALARY
FROM EMP E
WHERE SALARY > (SELECT AVG(SALARY) FROM EMP WHERE WORKDEPT = E.WORKDEPT)
ORDER BY WORKDEPT, EMPNO;

-- Problem 8
-- Retrieve all departments having the same number of employees as department
-- A00. List department number and number of employees. Department A00 should
-- not be part of the result.
SELECT WORKDEPT, COUNT(*) AS CNT_EMP
FROM EMP
WHERE WORKDEPT <> 'A00'
GROUP BY WORKDEPT
HAVING COUNT(*) = (SELECT COUNT(*) FROM EMP WHERE WORKDEPT = 'A00');

-- Problem 9
-- Display employee number, last name, salary, and department number of employees
-- who earn more than at least one employee in department D11. Employees in
-- department D11 should not be included in the result. In other words, report on any
-- employees in departments other than D11 whose individual yearly salary is higher
-- than that of at least one employee of department D11. List the employees in
-- employee number sequence.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE WORKDEPT <> 'D11'
AND SALARY > ANY(SELECT SALARY FROM EMP WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

-- Problem 10
-- Display employee number, last name, salary, and department number of all
-- employees who earn more than everybody belonging to department D11.
-- Employees in department D11 should not be included in the result. In other words,
-- report on all employees in departments other than D11 whose individual yearly
-- salary is higher than that of every employee in department D11. List the employees
-- in employee number sequence.
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE WORKDEPT <> 'D11'
AND SALARY > ALL(SELECT SALARY FROM EMP WHERE WORKDEPT = 'D11')
ORDER BY EMPNO;

-- Problem 11
-- Display employee number, last name, and number of activities of the employee with
-- the largest number of activities. Each activity is stored as one row in the EMP_ACT
-- table.
SELECT E.EMPNO, LASTNAME, COUNT(*) AS CNT_EMP
FROM EMP_ACT EA, EMP E
WHERE EA.EMPNO = E.EMPNO
GROUP BY E.EMPNO, LASTNAME
HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM EMP_ACT GROUP BY EMPNO);

-- Problem 12
-- Display employee number, last name, and activity number of all activities in the
-- EMP_ACT table. However, the list should only be produced if there were any
-- activities in 1982.
-- Note: The EMP_ACT table in the Sample database of Windows has a duplicate row for
-- employee number ‘000020’. This may effect the result.
SELECT DISTINCT E.EMPNO, LASTNAME, ACTNO
FROM EMPLOYEE E JOIN EMP_ACT EA
ON E.EMPNO = EA.EMPNO
WHERE EXISTS (SELECT * FROM
              EMP_ACT
              WHERE 1982 BETWEEN YEAR(EMSTDATE) AND YEAR(EMENDATE));