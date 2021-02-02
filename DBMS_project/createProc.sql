SET SCHEMA FN71852@

------------------------------------------- Процедура с курсор и входни и изходни параметри ------------------------------------------------
-- Създавам си таблица, за да не променям оригиналните данни
CREATE TABLE CONTRACTS_COPY LIKE FN71852.CONTRACTS@

-- Добавям си ключовете
ALTER TABLE CONTRACTS_COPY ADD PRIMARY KEY ID REFERENCES EMPLOYEES(ID)@
ALTER TABLE CONTRACTS_COPY ADD FOREIGN KEY (CLIENT_NAME, CLIENT_EGN, CLIENT_SIGNATURE) REFERENCES CLIENTS(NAME, EGN, SIGNATURE)@
ALTER TABLE CONTRACTS_COPY ADD FOREIGN KEY EMPL_ID REFERENCES EMPLOYEES(ID)@

-- Въвеждам данните от старата таблица в новата
INSERT INTO CONTRACTS_COPY (SELECT * FROM FN71852.CONTRACTS)@

-- Проверявам дали данните са в новата таблица
SELECT * FROM FN71852.CONTRACTS_COPY@

-- Създавам процедура, която по подаден номер на договор, извежда информациа за името на клиента и неговата лихва
-- Целта й е да се намалява лихвата на клиенти в зависимост от номера на договора. Ако той е четен, лихвата се намалява със 100лв. Иначе - с 20лв.
CREATE PROCEDURE DECREASE_CLIENT_INTEREST(IN contract_id CHAR(6), OUT client_name VARCHAR(50), OUT interest DECIMAL(7, 2))
RESULT SETS 1
LANGUAGE SQL
BEGIN
	DECLare contract ANCHOR ROW CONTRACTS_COPY;
	
	-- С курсора взимам името и лихвата от таблицата 
	DECLARE cursor1 CURSOR FOR SELECT CLIENT_NAME, INTEREST 
	FROM CONTRACTS_COPY
	WHERE ID = contract_id;

	-- Проверявам дали номерът е четен
	IF(MOD(SUBSTR(contract_id, 4), 2) = 0 ) THEN
		UPDATE CONTRACTS_COPY 	
		SET INTEREST = INTEREST - 100 WHERE ID = contract_id;
	-- Иначе номерът е нечетен
	ELSE 
		UPDATE CONTRACTS_COPY
		SET INTEREST = INTEREST - 20 WHERE ID = contract_id;
	END IF;
	OPEN cursor1;
	FETCH FROM cursor1 INTO client_name, interest;
END@

-- Извикване на процедурата
CALL FN71852.DECREASE_CLIENT_INTEREST('CNT234', ?, ?)@

------------------------------------------- Процедура с прихващане на изключение -----------------------------------------------------------
 -- Създавам таблица, в която ще се извежда резултатът от процедурата
CREATE TABLE FN71852.EMPL_ID_CHANGE(CTIME TIMESTAMP, MESSAGE VARCHAR(2000))@

CREATE PROCEDURE FN71852.EMPL_ITERATE()
LANGUAGE SQL
BEGIN ATOMIC -- Връща целия резултат или, ако някоя команда даде грешка, връща всичко преди нея (Заради UNDO)
	DECLARE null_value  INTEGER DEFAULT 0;
	DECLARE out_of_range INTEGER DEFAULT 0;
	
	-- Променливи, в които ще се запазва резултатът
	DECLARE emp_id CHAR(6) DEFAULT '';
	DECLARE emp_officeID CHAR(12) DEFAULT '';
	DECLARE emp_workPhone CHAR(10) DEFAULT 0;
	
	-- Декларирам условията за съответните sqlstates
	DECLARE null_not_allowed  CONDITION FOR SQLSTATE '22004';  -- null стойности не са позволени
	DECLARE out_range CONDITION FOR SQLSTATE '02000';  -- аргумент от substr е извън допустимата дължина 
	
	-- Курсор, с който ще обхождам редовете в таблицата EMPLOYEES
	DECLARE c1 CURSOR FOR SELECT ID, OFFICE_ID, WORK_PHONE_NUMBER FROM FN71852.EMPLOYEES;
	
	-- Декларирам типовете condition handlers 
	DECLARE UNDO HANDLER FOR null_not_allowed  SET null_value  = 1;
	DECLARE CONTINUE HANDLER FOR out_range SET out_of_range = 1;
	
	OPEN c1;
		loop: LOOP
			FETCH c1 INTO emp_id, emp_officeID, emp_workPhone; -- обхождам emp_id, emp_officeID, emp_workPhone
			IF null_value  = 1 OR out_of_range = 1 THEN LEAVE loop; --OR invalid_value = 1
			ELSEIF emp_id = 'EMP210' THEN ITERATE loop;
			END IF;
		
			-- Вмъквам в новосъздадената таблица новите стойности на emp_id, emp_officeID, emp_workPhone
			INSERT INTO FN71852.EMPL_ID_CHANGE(CTIME, MESSAGE) VALUES (CURRENT_TIMESTAMP, 'ID:' || emp_id || ' ' || 'OFFICE ID:' || 
									emp_officeID || ' ' || 'PHONE_NUMBER:' || emp_workPhone || ' ');
		END loop;		
	CLOSE c1;	
END@

-- Извиквам процедурата.
SELECT * FROM FN71852.EMPL_ID_CHANGE@
CALL FN71852.EMPL_ITERATE()@
SELECT * FROM FN71852.EMPL_ID_CHANGE@

------------------------------------------- Процедура с курсор и while цикъл ---------------------------------------------------------------
-- Създавам три асоциативни масива,за да изведа данни за служител. 
CREATE TYPE FN71852.clientAddressArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@ -- с помощта на този масив извеждам адреса на клиента
CREATE TYPE FN71852.clientSalArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@ 	  -- този масив съдържа заплатата на клиента
CREATE TYPE FN71852.clientAmountArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@  -- тук пазя информация за размера на кредита

 -- Създавам таблица, в която ще се извежда резултатът от процедурата
CREATE TABLE CLIENT_INFO(CTIME TIMESTAMP, MESSAGE VARCHAR(1000))@	

-- Добавям курсор, който не се променя и извежда всички данни за клиент, чиято цел на кредита е '1' - DAILY NEEDS
CREATE VARIABLE appIndex CURSOR CONSTANT (CURSOR FOR SELECT * FROM FN71852.APPLICATIONS WHERE PURPOSE_OF_LOAN = 1)@

CREATE PROCEDURE CLIENT_APP_INFO()
BEGIN
	DECLARE clientApp ANCHOR ROW FN71852.APPLICATIONS; -- clientApp сочи към ред от таблицата APPLICATIONS
	DECLARE clientAddrHash FN71852.clientAddressArr;   -- clientAddrHash е от тип clientAddressArr (асоциативния масив)
	DECLARE clientSalHash FN71852.clientSalArr; 	   -- clientSalHash е от тип clientSalArr (асоциативния масив)
	DECLARE clientAmountHash FN71852.clientAmountArr;  -- clientAmountHash е от тип clientAmountArr (асоциативния масив)
	
	DECLARE SQLCODE INT; -- SQLCODE показва наличието на грешка
	DECLARE appID ANCHOR FN71852.APPLICATIONS.ID; -- appID сочи към ID от таблицата APPLICATIONS
	
	OPEN appIndex;
	-- За завлението със съответен номер въвеждаме информация за име, заплата и размер на кредита на даден клиент
	FETCH appIndex INTO clientApp;
	WHILE SQLCODE = 0 DO -- докато няма грешка
		SET clientAddrHash[clientApp.ID] = clientApp.CLIENT_ADDRESS;
		SET clientSalHash[clientApp.ID] = clientApp.SALARY;
		SET clientAmountHash[clientApp.ID] = clientApp.AMOUNT;
		FETCH appIndex INTO clientApp;
	END WHILE;
	
	-- Извеждаме информация за името и заплатата и размер на кредита на даден клиент по номер на заявлението
	SET appID = ARRAY_FIRST(clientAddrHash);
	WHILE appID IS NOT NULL DO
		INSERT INTO FN71852.CLIENT_INFO VALUES (CURRENT_TIMESTAMP, 'ID: ' || appID || ' Address: ' || clientAddrHash[appID] 
						 || ' Salary: ' || clientSalHash[appID] || ' Amount: ' || clientAmountHash[appID]);
		SET appID = ARRAY_NEXT(clientAddrHash, appID); 
	END WHILE;
END@

-- Извиквам процедурата.
SELECT * FROM FN71852.CLIENT_INFO@
CALL FN71852.CLIENT_APP_INFO()@ 
SELECT * FROM FN71852.CLIENT_INFO@




