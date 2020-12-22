SET SCHEMA FN71852;

-- 1. Създайте изглед, който да връща номер на департамент, номер на работник,
-- заплата, номер на шефа на отдела, в който работи и заплатата на шефа.
CREATE VIEW EMP_DEPT_INFO
AS
    SELECT E.WORKDEPT, E.EMPNO, E.SALARY, D.MGRNO, (SELECT SALARY FROM EMP WHERE EMPNO = D.MGRNO) AS MNG_SALARY
    FROM EMP E,  DEPT D
    WHERE E.WORKDEPT = D.DEPTNO;

-- 2.1. Създайте тригер за таблицата employee, който при всяка промяна на заплатата на работник
-- обновява заплатата на шефа на този департамент с 10%.
-- Като използвате изгледа от 1 тествайте тригера за департамент 'C01'
CREATE TRIGGER UPDATE_SALARY_MNGR
AFTER UPDATE OF SALARY ON EMP
REFERENCING NEW AS N_SAL OLD AS O_SAL
FOR EACH ROW
WHEN(O_SAL.EMPNO !=
            (SELECT MGRNO
             FROM DEPT, EMP
             WHERE WORKDEPT = DEPTNO
             AND EMPNO = O_SAL.EMPNO))

SELECT * FROM EMP_DEPT_INFO
WHERE WORKDEPT = 'C01';

UPDATE EMP
SET SALARY = SALARY + 100
WHERE WORKDEPT = 'C01';

-- 2.2. Създайте тригер за таблицата employee, който при изтриване на ред от таблицата employee,
-- записва номера на работника, име, дата на наемане, заплата и дата на изтриване в таблица employee_del,
-- само за тези работници чиято длъжност е 'MANAGER'.
-- (За целта, трябва предварително да сте създали таблицата employee_del със съответните колони)
CREATE TABLE EMPLOYEE_DEL (
    EMPNO CHAR(6),
    LASTNAME VARCHAR(50),
    HIREDATE DATE,
    SALARY DECIMAL(9,2),
    DELDATE DATE
);

CREATE TABLE EMPL_DEL
AS
    (SELECT EMPNO, LASTNAME, HIREDATE, SALARY, CURRENT_TIMESTAMP AS DELDATE
    FROM EMP) DEFINITION ONLY ;

CREATE TRIGGER SAVE_EMP
AFTER DELETE ON EMP
REFERENCING OLD AS O
FOR EACH ROW
WHEN(O.JOB = 'MANAGER')
    INSERT INTO EMPL_DEL(EMPNO, LASTNAME, HIREDATE, SALARY, DELDATE)
    VALUES (O.EMPNO, O.LASTNAME, O.HIREDATE, O.SALARY, CURRENT_TIMESTAMP);

DELETE FROM EMP
WHERE JOB = 'MANAGER';

SELECT * FROM EMPL_DEL;