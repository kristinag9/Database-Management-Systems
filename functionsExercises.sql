CREATE FUNCTION FN71852.DEPTNAME(V_EMPNO CHAR(6))
RETURNS VARCHAR(50)
SPECIFIC DEPTNAME_2020_12_16
    RETURN SELECT DEPTNAME
                FROM DB2INST1.DEPARTMENT, DB2INST1.EMPLOYEE
                WHERE WORKDEPT = DEPTNO
                AND EMPNO = V_EMPNO;

SELECT LASTNAME, FN71852.DEPTNAME(EMPNO)
FROM DB2INST1.EMPLOYEE
WHERE WORKDEPT IN ('C01', 'B01');

VALUES FN71852.DEPTNAME('000010');

CREATE FUNCTION FN71852.EMPDEPT(V_DEPTNO CHAR(3))
RETURNS TABLE (
                EMPNO CHAR(6),
                LASTNAME VARCHAR(20),
                HIREDATE DATE
              )
SPECIFIC EMPDEPT_2020_12_16
RETURN SELECT EMPNO, LASTNAME, HIREDATE
        FROM DB2INST1.EMPLOYEE
        WHERE WORKDEPT = V_DEPTNO;

DROP FUNCTION FN71852.EMPDEPT;

SELECT * FROM TABLE(FN71852.EMPDEPT('C01')) T;

-- Напишете функция за таблицата employee,
-- която връща възрастта на работника към момента в години
CREATE FUNCTION FN71852.AGE(V_EMPNO CHAR(6))
RETURNS INT
RETURN SELECT YEAR(CURRENT_DATE - BIRTHDATE) AS AGE
        FROM DB2INST1.EMPLOYEE
        WHERE EMPNO = V_EMPNO;

VALUES FN71852.AGE('000010');

SELECT LASTNAME, FN71852.AGE(EMPNO)
FROM DB2INST1.EMPLOYEE;

-- Напишете функция за таблицата employee, която връща трудовия стаж
-- на работника към момента в години
CREATE FUNCTION FN71852.WORKYEARS(V_EMPNO CHAR(6))
RETURNS INT
RETURN SELECT YEAR(CURRENT_DATE  - HIREDATE) AS STAJ
        FROM DB2INST1.EMPLOYEE
        WHERE EMPNO = V_EMPNO;

VALUES FN71852.WORKYEARS('000010');

SELECT LASTNAME, FN71852.WORKYEARS(EMPNO)
FROM DB2INST1.EMPLOYEE;

-- Напишете функция за таблицата employee, която връща последно име на работника
-- и заплатата му за тези работници които са от департамент
-- подаден като входен параметър за функцията.
CREATE FUNCTION FN71852.EMP_INF_DEPT(V_DEPTNO CHAR(3))
RETURNS TABLE(LASTNAME VARCHAR(15), SALARY DECIMAL(9, 2))
RETURN SELECT E.LASTNAME, E.SALARY
        FROM EMP E
        WHERE E.WORKDEPT = V_DEPTNO;

SELECT * FROM TABLE(FN71852.EMP_INF_DEPT('C01')) T

-- Като използвате горните функции, създайте изглед за таблицата employee,
-- която връща трудовия стаж на работника в години, годините на работника,
-- стойността на заплатата, пола и номера на работника,
-- само за тези работници на възраст над 59 години за жените
-- и на възраст над 62 години за мъжете.
CREATE VIEW FN71852.INFO_EMPLOYEE
AS
    (SELECT EMPNO, SEX, SALARY, FN71852.AGE(EMPNO) AS AGE, FN71852.WORKYEARS(EMPNO) AS STAJ
        FROM EMP
        WHERE (FN71852.AGE(EMPNO) > 59 AND SEX = 'F')
        OR (FN71852.AGE(EMPNO) > 62 AND SEX = 'M'));

SELECT * FROM FN71852.INFO_EMPLOYEE;