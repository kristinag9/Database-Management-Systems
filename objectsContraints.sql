SET SCHEMA FN71852;

-- Problem 1
-- Create the table EMPDEPT with these columns:
--  • EMPNO
--  • LASTNAME
--  • SALARY
--  • DEPTNO
--  • DEP_NAME
-- The data types and null characteristics for these columns should be the same as for
-- the columns with the same names in the EMPLOYEE and DEPARTMENT tables.
-- These tables are described in our course data model.
CREATE TABLE EMPDEPT
AS
    (SELECT EMPNO, LASTNAME, SALARY, DEPTNO, DEPTNAME
     FROM EMP, DEPT)
     DEFINITION ONLY;

-- The definition of the table should limit the values for the yearly salary (SALARY)
-- column to ensure that:
--  • The yearly salary for employees in department E11 (operations) must not exceed
-- 28000.
ALTER TABLE EMPDEPT ADD CONSTRAINT CK_SALARY CHECK (DEPTNO = 'E11' AND SALARY <= 28000);
ALTER TABLE EMPDEPT DROP CONSTRAINT CK_SALARY;
--  • No employee in any department may have a yearly salary that exceeds 50000.
ALTER TABLE EMPDEPT ADD CONSTRAINT CK_SALARY_NEW CHECK ((DEPTNO = 'E11' AND SALARY <= 28000) OR (DEPTNO <> 'E11' AND SALARY < 50000));

-- The values in the EMPNO column should be unique. The uniqueness should be
-- guaranteed via a unique index.
CREATE UNIQUE INDEX INDEX_EMPNO ON EMPDEPT(EMPNO);

-- Problem 2
-- Create the table HIGH_SALARY_RAISE with the following columns:
--  • EMPNO
--  • PREV_SAL
--  • NEW_SAL
-- The data type for column EMPNO is CHAR(6). The other columns should be defined
-- as DECIMAL(9,2). All columns in this table should be defined with NOT NULL.
CREATE TABLE HIGH_SALARY_RAISE (
EMPNO CHAR(6) NOT NULL,
PREV_SAL DECIMAL(9, 2) NOT NULL,
NEW_SAL DECIMAL(9, 2) NOT NULL );

-- After creating the table, you should add referential constraints.
-- The primary key for the EMPDEPT table should be EMPNO.
ALTER TABLE EMPDEPT ADD CONSTRAINT PK_EMPNO PRIMARY KEY (EMPNO);

-- The EMPDEPT table should only allow values in column EMPNO which exist in the
-- EMPLOYEE table. If an employee is deleted from the EMP table, the corresponding
-- row in the EMPDEPT table should also be immediately deleted.
ALTER TABLE EMPDEPT ADD CONSTRAINT FK_EMPDEPT_EMP FOREIGN KEY (EMPNO) REFERENCES EMP(EMPNO) ON DELETE CASCADE;

-- The EMPDEPT table should only allow values in column DEPTNO which exist in the
-- DEPARTMENT table. It should not be possible to delete a department from the
-- DEPARTMENT table as long as a corresponding DEPTNO exists in the EMPDEPT
-- table
ALTER TABLE EMPDEPT ADD CONSTRAINT FK_EMPDEPT_DEPT FOREIGN KEY (DEPTNO) REFERENCES DEPT(DEPTNO);

-- Problem 3
-- Klaus must update the yearly salaries for the employees of the EMPDEPT table. If
-- the new value for a salary exceeds the previous value by 10 percent or more,
-- Harvey wants to insert a row into the HIGH_SALARY_RAISE table. The values in
-- this row should be the employee number, the previous salary, and the new salary.
-- Create something in DB2 that will ensure that a row is inserted into the
-- HIGH_SALARY_RAISE table whenever an employee of the EMPDEPT table gets a
-- raise of 10 percent or more.
CREATE TRIGGER TRIG_UPD_SALARY
    AFTER UPDATE OF SALARY ON EMPDEPT
    REFERENCING OLD AS OLD_SALARY NEW AS NEW_SALARY
    FOR EACH ROW
        WHEN(NEW_SALARY.SALARY > OLD_SALARY.SALARY * 1.1)
            INSERT INTO HIGH_SALARY_RAISE(EMPNO, PREV_SAL, NEW_SAL)
            VALUES (OLD_SALARY.EMPNO, OLD_SALARY.SALARY, NEW_SALARY.SALARY);

UPDATE EMPDEPT
SET SALARY = SALARY * 1.2
WHERE SALARY < 37000;

SELECT * FROM HIGH_SALARY_RAISE;

-- Problem 4
-- Now, you should insert data in the EMPDEPT table. Use the combined contents of
-- tables EMPLOYEE and DEPARTMENT as the source for your data.
-- Did your insert work?
-- If not, correct your INSERT statement so that you get only rows which satisfy the
-- check constraints on the EMPDEPT table.
INSERT INTO EMPDEPT
SELECT EMPNO, LASTNAME, SALARY, DEPTNO, DEPTNAME
FROM EMP, DEPT
WHERE WORKDEPT = DEPTNO
AND ((DEPTNO = 'E11' AND SALARY <= 28000) OR (DEPTNO <> 'E11' AND SALARY < 50000));

-- Problem 5
-- Harvey wants to test the table-level check constraint on the EMPDEPT table.
-- Ethel Schneider works in the operations department. Her department number is
-- E11, and her employee number is 000280. Try to set her yearly salary to the value of
-- 30000. Does it work?
UPDATE EMPDEPT
SET SALARY = 30000
WHERE EMPNO = '000280'; -- <-- It doesn't work because of the constraint

UPDATE EMPDEPT
SET SALARY = 27999
WHERE EMPNO = '000280';

-- Problem 6
-- Harvey wants to see if the trigger works.
-- Elizabeth Pianka, whose employee number is 000160, has been given a raise. Set
-- her yearly salary to 25000. Inspect the HIGH_SALARY_RAISE table to see if the
-- trigger worked.
UPDATE EMPDEPT
SET SALARY = 25000
WHERE EMPNO = '000160';

SELECT * FROM HIGH_SALARY_RAISE;

