SET SCHEMA FN71852;
-- Relational schemas
-- Employees (id, name, work_phone_number, office_id) 
-- Clients (egn, name, signature) -> pk
-- Application (id, current_date, address_client, salary, phone_number, amount, costs, income, purpose_of_loan,
--				 client_name, client_egn, client_signature, employee_id)
-- Contracts (id, date_of_conclusion, completion_date, number_of_installments, date_of_installment, interest, 
-- 				repayment_period, client_name, client_egn, client_signature, employee_id)
-- Offices (id, location, app_id, emlp_id)

CREATE TABLE EMPLOYEES (
	ID CHAR(6) NOT NULL CONSTRAINT PK_EMPLOYEE PRIMARY KEY,
	NAME VARCHAR(50) NOT NULL,
	WORK_PHONE_NUMBER CHAR(10),
	OFFICE_ID CHAR(6) NOT NULL CONSTRAINT FK_EMPLOYEES_OFFICES REFERENCES OFFICES(ID)
);

DROP TABLE FN71852.EMPLOYEES;

CREATE TABLE CLIENTS (
	NAME VARCHAR(50) NOT NULL,
	EGN CHAR(10) NOT NULL,
	SIGNATURE CHAR(5) NOT NULL,
	PRIMARY KEY (NAME, EGN, SIGNATURE)
);

DROP TABLE FN71852.CLIENTS;

CREATE TABLE APPLICATIONS (
	ID CHAR(6) NOT NULL CONSTRAINT PK_APPLICATION PRIMARY KEY,
	CURRENT_DATE DATE NOT NULL,
	CLIENT_ADDRESS VARCHAR(100) NOT NULL, -- CITY/VILLAGE, STREET, NUMBER
	SALARY DECIMAL(9, 2) NOT NULL CHECK (SALARY > 0),
	PHONE_NUMBER CHAR(10),
	AMOUNT INT NOT NULL CHECK (AMOUNT >= 100 AND AMOUNT <= 5000),
	COSTS DECIMAL(9, 2),
	INCOME DECIMAL(9, 2) NOT NULL CHECK (INCOME > 0),
	PURPOSE_OF_LOAN INT CHECK (PURPOSE_OF_LOAN IN (1, 2, 3)), -- 1 - DAILY NEEDS, 2 - PERSONAL NEEDS, 3 - OTHER CREDIT
	CLIENT_NAME VARCHAR(50),
	CLIENT_EGN CHAR(10),
	CLIENT_SIGNATURE CHAR(5),
	CONSTRAINT FK_CLIENTS FOREIGN KEY(CLIENT_NAME, CLIENT_EGN, CLIENT_SIGNATURE) REFERENCES CLIENTS(NAME, EGN, SIGNATURE), 
	EMPL_ID CHAR(6) CONSTRAINT FK_APP_EMPL REFERENCES EMPLOYEES(ID),
	OFFICE_ID CHAR(6) CONSTRAINT FK_APP_OFFICES REFERENCES OFFICES(ID)
);

DROP TABLE FN71852.APPLICATIONS;

CREATE TABLE CONTRACTS (
	ID CHAR(6) NOT NULL CONSTRAINT PK_CONTRACTS PRIMARY KEY,
	DATE_OF_CONCLUSION DATE NOT NULL,
	COMPLETION_DATE DATE NOT NULL,
	NUMBER_INSTALLMENTS INT NOT NULL,
	INSTALLMENT_DATE DATE NOT NULL,
	INTEREST DECIMAL(7, 2) NOT NULL,
	REPAYMENT_PERIOD INT CHECK (REPAYMENT_PERIOD >= 7 AND REPAYMENT_PERIOD <= 365),
	CLIENT_NAME VARCHAR(50),
	CLIENT_EGN CHAR(10),
	CLIENT_SIGNATURE CHAR(5), 
	CONSTRAINT FK_CLIENTS FOREIGN KEY(CLIENT_NAME, CLIENT_EGN, CLIENT_SIGNATURE) REFERENCES CLIENTS(NAME, EGN, SIGNATURE),
	EMPL_ID CHAR(6) CONSTRAINT FK_CNT_EMPL REFERENCES EMPLOYEES(ID)
);

DROP TABLE FN71852.CONTRACTS;

CREATE TABLE OFFICES (
	ID CHAR(6) NOT NULL CONSTRAINT PK_OFFICES PRIMARY KEY,
	LOCATION VARCHAR(20) NOT NULL
);
