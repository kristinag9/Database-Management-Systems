SET SCHEMA FN71852;

-- Problem 1
-- Create a view named VEMPPAY that contains one row for each employee in the
-- company. Each row should contain employee number, last name, department
-- number, and total earnings for the corresponding employee. Total earnings means
-- salary plus bonus plus commission for the employee. Then, determine the average
-- of the earnings for the departments by using the view you just created.
CREATE VIEW VEMPPAY(EMPNO, LASTNAME, DEPTNO, TOTAL_EARINGS)
AS
    SELECT EMPNO, LASTNAME, WORKDEPT, SALARY + BONUS + COMM
    FROM EMP;

SELECT DEPTNO, AVG(TOTAL_EARINGS)
FROM VEMPPAY
GROUP BY DEPTNO;

-- Problem 2
-- Create a view named VEMP1 containing employee number, last name, yearly
-- salary, and work department based on your TESTEMP table. Only employees with a
-- yearly salary less than 50000 should be displayed when you use the view.
CREATE VIEW VEMP1
AS
    SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
    FROM EMP
    WHERE SALARY < 50000;

-- Display the rows in the view in employee number sequence.
SELECT * FROM VEMP1
ORDER BY EMPNO;

-- Our employee with the employee number 000020 (Thompson) changed jobs and
-- will get a new salary of 51000. Update the data for employee number 000020 using
-- the view VEMP1.
UPDATE VEMP1
SET SALARY = 51000
WHERE EMPNO = '000020';

-- Display the view again, arranging the rows in employee number sequence.
-- What happened? Is Thompson still in the view?
SELECT * FROM VEMP1
ORDER BY EMPNO;

-- Query the row of employee number 000020 in your TESTEMP table.
-- Did the update work?
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE EMPNO = '000020';

-- Problem 3
-- Reset the salary of employee Thompson (empno = '000020') to the value of 41250.
UPDATE EMP
SET SALARY = 41250
WHERE EMPNO = '000020';

-- Create a view named VEMP2 which has the same definition as in problem 8, but
-- add a CHECK OPTION. Again, base the view on your TESTEMP table.
-- Display the rows in the view in employee number sequence.
CREATE VIEW VEMP2
AS
    SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
    FROM EMP
    WHERE SALARY < 50000 WITH CHECK OPTION;

SELECT * FROM VEMP2
ORDER BY EMPNO;

-- Our employee with the employee number 000050 (Geyer) also changed jobs and
-- will have a new salary of 55000. Update the data for employee number 000050
-- using the view VEMP2. Does the UPDATE statement work?
UPDATE VEMP2
SET SALARY = 55000
WHERE EMPNO = '000050';

-- Display the view again, arranging the rows in employee number sequence.
SELECT * FROM VEMP2
ORDER BY EMPNO;

-- Query Geyer's row in your TESTEMP table.
-- Did the data in the base table change?
SELECT EMPNO, LASTNAME, SALARY, WORKDEPT
FROM EMP
WHERE EMPNO = '000050';

-- 1. Създайте изглед, който да връща номер на департамент,
-- номер на работник, заплата, номер на шефа на отдела, в който работи и заплатата на шефа.
CREATE VIEW EMP_DEPT_INFO
AS
    SELECT E.WORKDEPT, E.EMPNO, E.SALARY, D.MGRNO, (SELECT SALARY FROM EMP WHERE EMPNO = D.MGRNO) AS MNG_SALARY
    FROM EMP E,  DEPT D
    WHERE E.WORKDEPT = D.DEPTNO;

SELECT * FROM EMP_DEPT_INFO
WHERE WORKDEPT = 'C01';
