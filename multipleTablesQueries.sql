-- Problem 1
-- Produce a report that lists employees' last names, first names, and department
-- names. Sequence the report on first name within last name, within department
-- name.
SELECT LASTNAME, FIRSTNME, DEPTNAME
FROM EMP, DEPT
WHERE WORKDEPT = DEPTNO
ORDER BY DEPTNAME, LASTNAME, FIRSTNME;

-- Problem 2
-- Modify the previous query to include job. Also, list data for only departments
-- between A02 and D22, and exclude managers from the list. Sequence the report on
-- first name within last name, within job, within department name.
SELECT E.LASTNAME, E.FIRSTNME, D.DEPTNAME, E.JOB
FROM EMP E, DEPT D
WHERE E.WORKDEPT = D.DEPTNO
      AND WORKDEPT BETWEEN 'A02'AND 'D22'
      AND JOB <> 'MANAGER'
ORDER BY D.DEPTNAME, E.LASTNAME, E.JOB, E.FIRSTNME;

-- Problem 3
-- List the name of each department and the lastname and first name of its manager.
-- Sequence the list by department name. Use the EMPNO and MGRNO columns to
-- relate the two tables. Sequence the result rows by department name.
SELECT D.DEPTNAME, E.LASTNAME, E.FIRSTNME
FROM DEPT D JOIN EMP E ON D.MGRNO = E.EMPNO
ORDER BY D.DEPTNAME;

-- Problem 4
-- For all projects that have a project number beginning with AD, list project number,
-- project name, and activity number. List identical rows once. Order the list by project
-- number and then by activity number.
SELECT DISTINCT A.PROJNO, A.PROJNAME, EA.ACTNO
FROM PROJ A, EMP_ACT EA
WHERE A.PROJNO LIKE 'AD%'
ORDER BY A.PROJNO, EA.ACTNO;

-- Problem 6
-- Which employees are assigned to project number AD3113? List employee number,
-- last name, and project number. Order the list by employee number and then by
-- project number. List only one occurrence of duplicate result rows.
SELECT DISTINCT E.EMPNO, E.LASTNAME, EA.PROJNO
FROM EMP E, EMP_ACT EA
WHERE E.EMPNO = EA.EMPNO AND PROJNO = 'AD3113'
ORDER BY EA.PROJNO;

-- Problem 7
-- Display all employees who work in the INFORMATION CENTER department. Show
-- department number, employee number and last name for all employees in that
-- department. The list should be ordered by employee number.
-- Use the "old" SQL syntax that puts the join condition in the WHERE clause.
-- Note: Use the views VDEPARTMENT, VEMPLOYEE, and VPROJECT during this unit.
SELECT WORKDEPT, EMPNO, LASTNAME
FROM VEMP, VDEPT
WHERE DEPTNAME = 'INFORMATION CENTER'
ORDER BY EMPNO;

-- Problem 8
-- Solve problem 1 again using the newer SQL syntax that places the join condition in
-- the ON clause.
SELECT WORKDEPT, EMPNO, LASTNAME
FROM VEMP JOIN VDEPT ON WORKDEPT = DEPTNO
WHERE DEPTNAME = 'INFORMATION CENTER'
ORDER BY EMPNO;

-- Problem 9
-- Bill needs a list of those employees whose departments are involved in projects.
-- The list needs to show employee number, last name, department number, and
-- project name. The list should be ordered by project names within employee numbers.
SELECT EMPNO, LASTNAME, WORKDEPT, PROJNAME
FROM VEMP JOIN VPROJ ON WORKDEPT = DEPTNO
ORDER BY EMPNO;

-- Problem 10
-- Now Bill wants to see all employees, whether or not their departments are involved a
-- project. The list needs to show the employee number, last name, department number, and project name.
-- If the department of an employee is not involved in a project, display NULLs instead of the project name.
-- The list should be ordered by project name within employee number.
SELECT EMPNO, LASTNAME, WORKDEPT, PROJNAME
FROM VEMP LEFT OUTER JOIN VPROJ ON WORKDEPT = DEPTNO
ORDER BY EMPNO;

-- Problem 11
-- Now Bill wants to see all projects, including those assigned to departments without
-- employees. The list needs to show employee number, last name, department
-- number, and project name. If a project is not assigned to a department having
-- employees, NULLS should be displayed instead of the department number,
-- employee number and last name. The list should be ordered by employee number
-- within project name.
SELECT EMPNO, LASTNAME, WORKDEPT, PROJNAME
FROM VEMP RIGHT OUTER JOIN VPROJ ON WORKDEPT = DEPTNO
ORDER BY PROJNAME;

-- Problem 12
-- Last, Bill wants to see all projects and all employees in one report. Projects not
-- assigned to departments having employees should also be listed as well as
-- employees who work in departments which are not involved in projects. The list
-- needs to show employee number, last name, department number, and project
-- name. If a project is not assigned to a department having employees, NULLS should
-- be displayed instead of the department number, employee number and last name. If
-- the department of an employee is not involved in a project, display NULLs instead of
-- the project name. The list should be ordered by project name within last name.
SELECT EMPNO, LASTNAME, WORKDEPT, PROJNAME
FROM VEMP FULL OUTER JOIN VPROJ ON WORKDEPT = DEPTNO
ORDER BY LASTNAME, PROJNAME;