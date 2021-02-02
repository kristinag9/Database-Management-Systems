SET SCHEMA FN71852@

-- Копирам таблицата
CREATE TABLE CONTRACTS_NEW LIKE CONTRACTS@

-- Вмъквам данни в новата таблица
INSERT INTO CONTRACTS_NEW
SELECT * FROM CONTRACTS@

-- Създавам таблица, в която ще се пази резултатът
CREATE TABLE AUDIT_CONTRACTS(CTIME_CONTRACT TIMESTAMP, TEXT VARCHAR(500))@

SELECT * FROM AUDIT_CONTRACTS@

-- Създавам тригер, който извежда информация за лихвата на клиент
CREATE TRIGGER TRIG_NEW_CONTRACTS
    AFTER UPDATE OF INTEREST ON CONTRACTS_NEW
    REFERENCING OLD AS OLD_CONTRACT NEW AS NEW_CONTRACT
    FOR EACH ROW
    BEGIN
      DECLARE V_TEXT VARCHAR(200);
      SET V_TEXT =  ' CONTRACT_NO = ' || OLD_CONTRACT.ID
                        || ' OLD INTEREST = ' || CHAR(OLD_CONTRACT.INTEREST)
                        || ' NEW INTEREST = ' || CHAR(NEW_CONTRACT.INTEREST);
      INSERT INTO AUDIT_CONTRACTS VALUES(CURRENT_TIMESTAMP, V_TEXT);
END@

-- Първи тест
UPDATE CONTRACTS_NEW
    SET INTEREST = INTEREST - 100
    WHERE ID = 'CNT127'@

-- Втори тест
UPDATE CONTRACTS_NEW
    SET INTEREST = INTEREST - 50
    WHERE ID = 'CNT256'@
    
DROP TABLE FN71852.CONTRACTS_NEW@
DROP TABLE FN71852.AUDIT_CONTRACTS@
DROP TRIGGER FN71852.TRIG_NEW_CONTRACTS@


----------------------- Втори тригер -----------------------------
-- Копиране на таблицата
CREATE TABLE FN71852.EMPLOYEES_NEW LIKE EMPLOYEES@

-- Вмъквам данни в новата дтаблица
INSERT INTO EMPLOYEES_NEW SELECT * FROM FN71852.EMPLOYEES@

SELECT * FROM EMPLOYEES_NEW@

-- Създавам тригера
CREATE TRIGGER FN71852.EMP_NEW_WORK_NUMBER 
BEFORE UPDATE ON EMPLOYEES_NEW
REFERENCING NEW AS NEW_ROW
FOR EACH ROW 
	SET WORK_PHONE_NUMBER = NEW_ROW.WORK_PHONE_NUMBER@ 
	
UPDATE FN71852.EMPLOYEES_NEW
SET WORK_PHONE_NUMBER = '0987652361'
WHERE ID = 'EMP100'@


----------------------- Тригер, който извиква процедура -----------------------------
-- Създавам таблица, в която ще запазвам резултата от изпълнението на процедурата
CREATE TABLE FN71852.APP_RESULT(app_id CHAR(6), curr_date DATE, client_addr VARCHAR(100))@

-- Процедура, която въвежда в таблицата APP_RESULT данни за заявление с номер APP357 
CREATE PROCEDURE FN71852.APP_INFO()
LANGUAGE SQL
BEGIN
	DECLARE id_app CHAR(6);
	DECLARE cur_date DATE;
	DECLARE client_address VARCHAR(100);
	
	DECLARE c1 CURSOR FOR SELECT ID, FN71852.APPLICATIONS.CURRENT_DATE, CLIENT_ADDRESS 
					FROM FN71852.APPLICATIONS WHERE ID = 'APP357';
	OPEN c1;
		
	FETCH FROM c1 INTO id_app, cur_date, client_address;
	INSERT INTO FN71852.APP_RESULT VALUES(id_app, cur_date, client_address);
END@

-- Създавам тригер, който променя адреса на клиент, чиято година от датата на подаване е >= 2017
CREATE TRIGGER FN71852.TRIG_APP_CLIENT 
AFTER UPDATE ON APP_RESULT
REFERENCING NEW AS n
FOR EACH ROW
WHEN(YEAR(DATE(n.curr_date)) >= 2017)
BEGIN ATOMIC
	CALL FN71852.APP_INFO();
END@

-- Променя се адресът на заявление с номер APP357
UPDATE APP_RESULT
SET client_addr = 'Bulgaria, Mezdra, Leshtaka street, No. 5'
WHERE app_id = 'APP357'@

-- Проверка дали е направена променя на адреса
SELECT * FROM FN71852.APP_RESULT@

SELECT * FROM FN71852.APPLICATIONS@