SET SCHEMA FN71852;

-- View �� ��������� CONTRACTS
CREATE VIEW FN71852.CONTRACTS_CONCLUSION
AS
    SELECT ID, DATE_OF_CONCLUSION, CLIENT_NAME, NUMBER_INSTALLMENTS
    FROM CONTRACTS
    WHERE YEAR(DATE_OF_CONCLUSION) >= '2010'
    AND DAY(DATE_OF_CONCLUSION) >= '01' AND DAY(DATE_OF_CONCLUSION) <= '15';

DROP VIEW FN71852.CONTRACTS_CONCLUSION;

-- View �� ��������� APPLICATIONS
CREATE VIEW HIGHEST_CLIENTS_COSTS
AS
    SELECT ID, CLIENT_ADDRESS, COSTS
    FROM APPLICATIONS
    WHERE COSTS >= 150;

DROP VIEW HIGHEST_CLIENTS_COSTS;

-- View �� ��������� EMPLOYEES
CREATE VIEW NULL_NUM_EMPL
AS 
	SELECT ID, NAME 
	FROM EMPLOYEES 
	WHERE WORK_PHONE_NUMBER = '';
	
DROP VIEW NULL_NUM_EMPL;
