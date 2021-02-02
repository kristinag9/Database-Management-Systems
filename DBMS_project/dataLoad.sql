SET SCHEMA FN71852;

INSERT INTO EMPLOYEES(ID, NAME, WORK_PHONE_NUMBER, OFFICE_ID)
VALUES ('EMP100', 'Ivan Georgiev Ivanov', '0879876543', 'OFF001'),
	   ('EMP210', 'Petar Ivanov Georgiev', '0888821573', 'OFF002'),
	   ('EMP315', 'Kalin Petrov Todorov', '0887435383', 'OFF003'),
	   ('EMP220', 'Kristina Tsekova Ivanova', '', 'OFF004'),
	   ('EMP426', 'Ivana Dimitrova Mineva', '0987645383', 'OFF005'),
	   ('EMP635', 'Denitsa Petrova Petrova', '0943882157', 'OFF006'),
	   ('EMP843', 'Stefan Metodiev Stefanov', '', 'OFF007'),
	   ('EMP159', 'Iva Stoyanova Petrova', '0889675645', 'OFF008'),
	   ('EMP589', 'Maria Petrova Todorova', '0876215341', 'OFF009'),
	   ('EMP345', 'Ivaila Georgieva Marinova', '', 'OFF010');
	   

INSERT INTO CLIENTS(NAME, EGN, SIGNATURE)
VALUES ('Petur Dimitrov Ivanov', '7008104334', 'PDI70'),
	   ('Krasimira Atanasova Iordanova', '7802026745', 'KAI78'),
	   ('Lidiya Mihaleva Velikova', '8912236473', 'LMV89'),
	   ('Teodor Petrov Todorov', '8803078443', 'TPT88'),
	   ('Stoyan Penev Georgiev', '6807246341', 'SPG68'),
	   ('Bojidara Ilieva Mineva', '8201074532', 'BIM82'),
	   ('Stefani Vasileva Nikolova', '9007024343', 'SVN90'),
	   ('Kristiana Dimitrova Dobreva', '7801235465', 'KDD78'),
	   ('Stiliyana Stoqnova Tsekova', '9902184678', 'SST99'),
	   ('Kostadin Petrov Kostadinov', '4705163427', 'KPK47'),
	   ('Dobrinka Georgieva Tsekova', '5509231678', 'DGT55'),
	   ('Nikoleta Stefanova Rizova', '9006175463', 'NSR90'),
	   ('Valya Miteva Ivanova', '9906175463', 'VMI99'),
	   ('Kristina Petrova Ivanova', '9603134573', 'KPI96'),
	   ('Liudmil Atanasov Ivanov', '9810152891', 'LAI98'),
	   ('Aleksandra Iordanova Ivanova', '9204197621', 'AII92'),
	   ('Georgi Petrov Georgiev', '7606251879', 'GPG76'),
	   ('Gergana Biserova Mironova', '9503171625', 'GBM95'),
	   ('Asen Petrov Georgiev', '7909196218', 'APG79'),
	   ('Marian Nikolaev Todorov', '8307181962', 'MNT83');
	   

INSERT INTO OFFICES(ID, LOCATION) 
VALUES ('OFF001', 'Blagoevgrad'),
	   ('OFF002', 'Mezdra'),
	   ('OFF003', 'Vratsa'),
	   ('OFF004', 'Sofia'),
	   ('OFF005', 'Burgas'),
	   ('OFF006', 'Varna'),
	   ('OFF007', 'Razgrad'),
	   ('OFF008', 'Shumen'),
	   ('OFF009', 'Dobrich'),
	   ('OFF010', 'Veliko Turnovo');
	   

INSERT INTO APPLICATIONS(ID, CURRENT_DATE, CLIENT_ADDRESS, SALARY, PHONE_NUMBER,
		AMOUNT, COSTS, INCOME, PURPOSE_OF_LOAN, CLIENT_NAME, CLIENT_EGN, CLIENT_SIGNATURE, EMPL_ID, OFFICE_ID)
VALUES ('APP021', '2010-08-21', 'Bulgaria, Varna, Liulin street, No. 6', 800, '0876543219', 1000, 100, 700, 1, 'Petur Dimitrov Ivanov', '7008104334', 'PDI70', 'EMP635', 'OFF006'),
	   ('APP036', '2012-10-08', 'Bulgaria, Sofia, Kolkata street, No. 9', 700, '0987261232', 1200, 150, 600, 2, 'Krasimira Atanasova Iordanova', '7802026745', 'KAI78', 'EMP220', 'OFF004'),
	   ('APP145', '2015-09-22', 'Bulgaria, Burgas, Dinko Petrov street, No. 17', 500, '0888657852', 500, 200, 300, 3, 'Lidiya Mihaleva Velikova', '8912236473', 'LMV89', 'EMP426', 'OFF005'),
	   ('APP215', '2013-11-10', 'Bulgaria, Dobrich, Gavril Genov street, No. 2', 1000, '0897652413', 1500, 200, 900, 1, 'Teodor Petrov Todorov', '8803078443', 'TPT88', 'EMP589', 'OFF009'),
	   ('APP178', '2009-02-28', 'Bulgaria, Shumen, Kozlodui street, No. 20', 900, '0878642162', 2000, 350, 500, 2, 'Stoyan Penev Georgiev', '6807246341', 'SPG68', 'EMP159', 'OFF008'),
	   ('APP197', '2019-07-02', 'Bulgaria, Blagoevgrad, Oborishte street, No. 11', 400, '0987654378', 300, 100, 300, 3, 'Bojidara Ilieva Mineva', '8201074532', 'BIM82', 'EMP100', 'OFF001'),
	   ('APP234', '2020-03-12', 'Bulgaria, Mezdra, Leshtaka street, No. 5', 1100, '0987145721', 3000, 250, 850, 1, 'Stefani Vasileva Nikolova', '9007024343', 'SVN90', 'EMP210', 'OFF002'),
	   ('APP214', '2011-11-11', 'Bulgaria, Vratsa, Hadzi Dimitur street, No. 89', 950, '0872516342', 2500, 200, 650, 1, 'Kristiana Dimitrova Dobreva', '7801235465', 'KDD78', 'EMP315', 'OFF003'),
	   ('APP456', '2016-01-08', 'Bulgaria, Razgrad, Dinko Petrov street, No. 43', 780, '0897654129', 700, 150, 630, 3, 'Stiliyana Stoqnova Tsekova', '9902184678', 'SST99', 'EMP843', 'OFF007'),
	   ('APP357', '2017-05-15', 'Bulgaria, Razgrad, Dimitur Blagoev street, No. 30', 650, '0987123412', 100, 200, 450, 1, 'Kostadin Petrov Kostadinov', '4705163427', 'KPK47', 'EMP843', 'OFF007'),
	   ('APP031', '2000-10-30', 'Bulgaria, Shumen, Liulin street, No. 49', 1000, '0987521431', 900, 100, 900, 2, 'Dobrinka Georgieva Tsekova', '5509231678', 'DGT55', 'EMP159', 'OFF008'),
	   ('APP987', '2001-07-12', 'Bulgaria, Dobrich, Zlatica street, No. 50', 900, '0871625321', 1000, 100, 800, 3, 'Nikoleta Stefanova Rizova', '9006175463', 'NSR90', 'EMP589', 'OFF009'),
	   ('APP765', '2002-09-21', 'Bulgaria, Veliko Turnovo, Georgi Damqnov street, No. 5', 800, '0789612532', 500, 50, 750, 1, 'Valya Miteva Ivanova', '9906175463', 'VMI99', 'EMP345', 'OFF010'),
	   ('APP213', '2003-05-24', 'Bulgaria, Veliko Turnovo, Rahov dol street, No. 19', 500, '0897651283', 800, 50, 450, 2, 'Kristina Petrova Ivanova', '9603134573', 'KPI96', 'EMP345', 'OFF010'),
	   ('APP542', '2004-03-19', 'Bulgaria, Varna, Durmantsi street, No. 29', 600, '0879652935', 300, 80, 520, 3, 'Liudmil Atanasov Ivanov', '9810152891', 'LAI98', 'EMP635', 'OFF006'),
	   ('APP156', '2020-09-27', 'Bulgaria, Burgas, Zdravets street, No. 38', 750, '0879123431', 400, 200, 550, 1, 'Aleksandra Iordanova Ivanova', '9204197621', 'AII92', 'EMP426', 'OFF005'),
	   ('APP289', '2019-03-12', 'Bulgaria, Sofia, Strupets street, No. 47', 1300, '0897123213', 900, 200, 1100, 2, 'Georgi Petrov Georgiev', '7606251879', 'GPG76', 'EMP220', 'OFF004'),
	   ('APP109', '2005-11-30', 'Bulgaria, Vratsa, Dunav street, No. 59', 1500, '0987154326', 500, 250, 1250, 3, 'Gergana Biserova Mironova', '9503171625', 'GBM95', 'EMP315', 'OFF003'),
	   ('APP807', '2019-12-23', 'Bulgaria, Mezdra, Al. Stamboliiski street, No. 67', 950, '0789156321', 900, 300, 650, 1, 'Asen Petrov Georgiev', '7909196218', 'APG79', 'EMP210', 'OFF002'),
	   ('APP256', '2017-10-04', 'Bulgaria, Blagoevgrad, Minzuhar street, No. 71', 760, '0897653279', 1000, 100, 660, 2, 'Marian Nikolaev Todorov', '8307181962', 'MNT83', 'EMP100', 'OFF001');


INSERT INTO CONTRACTS (ID, DATE_OF_CONCLUSION, COMPLETION_DATE, NUMBER_INSTALLMENTS, INSTALLMENT_DATE, INTEREST, REPAYMENT_PERIOD, CLIENT_NAME,
						 CLIENT_EGN, CLIENT_SIGNATURE, EMPL_ID)
VALUES ('CNT123', '2010-08-21', '2011-03-21' , 6 , '2010-09-21', 748, 185, 'Petur Dimitrov Ivanov', '7008104334', 'PDI70', 'EMP635'),
	   ('CNT125', '2012-10-08', '2013-10-08' , 12, '2012-11-08', 967, 365, 'Krasimira Atanasova Iordanova', '7802026745', 'KAI78', 'EMP220'),
	   ('CNT234', '2015-09-22', '2016-04-22' , 7, '2015-09-22', 459, 217, 'Lidiya Mihaleva Velikova', '8912236473', 'LMV89', 'EMP426'),
	   ('CNT256', '2013-11-10', '2014-04-10' , 5, '2013-12-10', 856, 155, 'Teodor Petrov Todorov', '8803078443', 'TPT88', 'EMP589'),
	   ('CNT345', '2019-07-02', '2020-01-02' , 6, '2019-08-02', 549, 185, 'Bojidara Ilieva Mineva', '8201074532', 'BIM82', 'EMP100'),
	   ('CNT567', '2020-03-12', '2020-11-12' , 8, '2020-04-12', 1025, 249, 'Stefani Vasileva Nikolova', '9007024343', 'SVN90', 'EMP210'),
	   ('CNT127', '2011-11-11', '2012-08-11' , 9, '2011-12-11', 1289, 278, 'Kristiana Dimitrova Dobreva', '7801235465', 'KDD78', 'EMP315'),
	   ('CNT472', '2017-05-15', '2017-06-15' , 1, '2019-08-02', 980, 31, 'Kostadin Petrov Kostadinov', '4705163427', 'KPK47', 'EMP843'),
	   ('CNT389', '2000-10-30', '2001-03-30' , 5, '2000-11-30', 712, 155, 'Dobrinka Georgieva Tsekova', '5509231678', 'DGT55', 'EMP159'),
	   ('CNT268', '2002-09-21', '2003-01-21' , 4, '2002-10-21', 321, 124, 'Valya Miteva Ivanova', '9906175463', 'VMI99', 'EMP345');
	 
SELECT * FROM EMPLOYEES;
SELECT * FROM OFFICES;
SELECT * FROM CLIENTS;
SELECT * FROM APPLICATIONS;
SELECT * FROM CONTRACTS;