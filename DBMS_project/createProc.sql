SET SCHEMA FN71852@

------------------------------------------- ��������� � ������ � ������ � ������� ��������� ------------------------------------------------
-- �������� �� �������, �� �� �� �������� ������������ �����
CREATE TABLE CONTRACTS_COPY LIKE FN71852.CONTRACTS@

-- ������� �� ���������
ALTER TABLE CONTRACTS_COPY ADD PRIMARY KEY ID REFERENCES EMPLOYEES(ID)@
ALTER TABLE CONTRACTS_COPY ADD FOREIGN KEY (CLIENT_NAME, CLIENT_EGN, CLIENT_SIGNATURE) REFERENCES CLIENTS(NAME, EGN, SIGNATURE)@
ALTER TABLE CONTRACTS_COPY ADD FOREIGN KEY EMPL_ID REFERENCES EMPLOYEES(ID)@

-- �������� ������� �� ������� ������� � ������
INSERT INTO CONTRACTS_COPY (SELECT * FROM FN71852.CONTRACTS)@

-- ���������� ���� ������� �� � ������ �������
SELECT * FROM FN71852.CONTRACTS_COPY@

-- �������� ���������, ����� �� ������� ����� �� �������, ������� ���������� �� ����� �� ������� � �������� �����
-- ����� � � �� �� �������� ������� �� ������� � ���������� �� ������ �� ��������. ��� ��� � �����, ������� �� �������� ��� 100��. ����� - � 20��.
CREATE PROCEDURE DECREASE_CLIENT_INTEREST(IN contract_id CHAR(6), OUT client_name VARCHAR(50), OUT interest DECIMAL(7, 2))
RESULT SETS 1
LANGUAGE SQL
BEGIN
	DECLare contract ANCHOR ROW CONTRACTS_COPY;
	
	-- � ������� ������ ����� � ������� �� ��������� 
	DECLARE cursor1 CURSOR FOR SELECT CLIENT_NAME, INTEREST 
	FROM CONTRACTS_COPY
	WHERE ID = contract_id;

	-- ���������� ���� ������� � �����
	IF(MOD(SUBSTR(contract_id, 4), 2) = 0 ) THEN
		UPDATE CONTRACTS_COPY 	
		SET INTEREST = INTEREST - 100 WHERE ID = contract_id;
	-- ����� ������� � �������
	ELSE 
		UPDATE CONTRACTS_COPY
		SET INTEREST = INTEREST - 20 WHERE ID = contract_id;
	END IF;
	OPEN cursor1;
	FETCH FROM cursor1 INTO client_name, interest;
END@

-- ��������� �� �����������
CALL FN71852.DECREASE_CLIENT_INTEREST('CNT234', ?, ?)@

------------------------------------------- ��������� � ���������� �� ���������� -----------------------------------------------------------
 -- �������� �������, � ����� �� �� ������� ���������� �� �����������
CREATE TABLE FN71852.EMPL_ID_CHANGE(CTIME TIMESTAMP, MESSAGE VARCHAR(2000))@

CREATE PROCEDURE FN71852.EMPL_ITERATE()
LANGUAGE SQL
BEGIN ATOMIC -- ����� ����� �������� ���, ��� ����� ������� ���� ������, ����� ������ ����� ��� (������ UNDO)
	DECLARE null_value  INTEGER DEFAULT 0;
	DECLARE out_of_range INTEGER DEFAULT 0;
	
	-- ����������, � ����� �� �� ������� ����������
	DECLARE emp_id CHAR(6) DEFAULT '';
	DECLARE emp_officeID CHAR(12) DEFAULT '';
	DECLARE emp_workPhone CHAR(10) DEFAULT 0;
	
	-- ���������� ��������� �� ����������� sqlstates
	DECLARE null_not_allowed  CONDITION FOR SQLSTATE '22004';  -- null ��������� �� �� ���������
	DECLARE out_range CONDITION FOR SQLSTATE '02000';  -- �������� �� substr � ����� ����������� ������� 
	
	-- ������, � ����� �� �������� �������� � ��������� EMPLOYEES
	DECLARE c1 CURSOR FOR SELECT ID, OFFICE_ID, WORK_PHONE_NUMBER FROM FN71852.EMPLOYEES;
	
	-- ���������� �������� condition handlers 
	DECLARE UNDO HANDLER FOR null_not_allowed  SET null_value  = 1;
	DECLARE CONTINUE HANDLER FOR out_range SET out_of_range = 1;
	
	OPEN c1;
		loop: LOOP
			FETCH c1 INTO emp_id, emp_officeID, emp_workPhone; -- �������� emp_id, emp_officeID, emp_workPhone
			IF null_value  = 1 OR out_of_range = 1 THEN LEAVE loop; --OR invalid_value = 1
			ELSEIF emp_id = 'EMP210' THEN ITERATE loop;
			END IF;
		
			-- ������� � ��������������� ������� ������ ��������� �� emp_id, emp_officeID, emp_workPhone
			INSERT INTO FN71852.EMPL_ID_CHANGE(CTIME, MESSAGE) VALUES (CURRENT_TIMESTAMP, 'ID:' || emp_id || ' ' || 'OFFICE ID:' || 
									emp_officeID || ' ' || 'PHONE_NUMBER:' || emp_workPhone || ' ');
		END loop;		
	CLOSE c1;	
END@

-- �������� �����������.
SELECT * FROM FN71852.EMPL_ID_CHANGE@
CALL FN71852.EMPL_ITERATE()@
SELECT * FROM FN71852.EMPL_ID_CHANGE@

------------------------------------------- ��������� � ������ � while ����� ---------------------------------------------------------------
-- �������� ��� ����������� ������,�� �� ������ ����� �� ��������. 
CREATE TYPE FN71852.clientAddressArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@ -- � ������� �� ���� ����� �������� ������ �� �������
CREATE TYPE FN71852.clientSalArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@ 	  -- ���� ����� ������� ��������� �� �������
CREATE TYPE FN71852.clientAmountArr AS VARCHAR(200) ARRAY[VARCHAR(100)]@  -- ��� ���� ���������� �� ������� �� �������

 -- �������� �������, � ����� �� �� ������� ���������� �� �����������
CREATE TABLE CLIENT_INFO(CTIME TIMESTAMP, MESSAGE VARCHAR(1000))@	

-- ������� ������, ����� �� �� ������� � ������� ������ ����� �� ������, ����� ��� �� ������� � '1' - DAILY NEEDS
CREATE VARIABLE appIndex CURSOR CONSTANT (CURSOR FOR SELECT * FROM FN71852.APPLICATIONS WHERE PURPOSE_OF_LOAN = 1)@

CREATE PROCEDURE CLIENT_APP_INFO()
BEGIN
	DECLARE clientApp ANCHOR ROW FN71852.APPLICATIONS; -- clientApp ���� ��� ��� �� ��������� APPLICATIONS
	DECLARE clientAddrHash FN71852.clientAddressArr;   -- clientAddrHash � �� ��� clientAddressArr (������������ �����)
	DECLARE clientSalHash FN71852.clientSalArr; 	   -- clientSalHash � �� ��� clientSalArr (������������ �����)
	DECLARE clientAmountHash FN71852.clientAmountArr;  -- clientAmountHash � �� ��� clientAmountArr (������������ �����)
	
	DECLARE SQLCODE INT; -- SQLCODE ������� ��������� �� ������
	DECLARE appID ANCHOR FN71852.APPLICATIONS.ID; -- appID ���� ��� ID �� ��������� APPLICATIONS
	
	OPEN appIndex;
	-- �� ���������� ��� ��������� ����� ��������� ���������� �� ���, ������� � ������ �� ������� �� ����� ������
	FETCH appIndex INTO clientApp;
	WHILE SQLCODE = 0 DO -- ������ ���� ������
		SET clientAddrHash[clientApp.ID] = clientApp.CLIENT_ADDRESS;
		SET clientSalHash[clientApp.ID] = clientApp.SALARY;
		SET clientAmountHash[clientApp.ID] = clientApp.AMOUNT;
		FETCH appIndex INTO clientApp;
	END WHILE;
	
	-- ��������� ���������� �� ����� � ��������� � ������ �� ������� �� ����� ������ �� ����� �� �����������
	SET appID = ARRAY_FIRST(clientAddrHash);
	WHILE appID IS NOT NULL DO
		INSERT INTO FN71852.CLIENT_INFO VALUES (CURRENT_TIMESTAMP, 'ID: ' || appID || ' Address: ' || clientAddrHash[appID] 
						 || ' Salary: ' || clientSalHash[appID] || ' Amount: ' || clientAmountHash[appID]);
		SET appID = ARRAY_NEXT(clientAddrHash, appID); 
	END WHILE;
END@

-- �������� �����������.
SELECT * FROM FN71852.CLIENT_INFO@
CALL FN71852.CLIENT_APP_INFO()@ 
SELECT * FROM FN71852.CLIENT_INFO@




