-- This file contains SQL statements that will be executed after the build script.
TRUNCATE TABLE [Gold].[Dimcosttye]
GO
INSERT INTO [Gold].[Dimcosttye] ([CostType],[Description]) VALUES ('Labour','Labour');
INSERT INTO [Gold].[Dimcosttye] ([CostType],[Description]) VALUES ('Non Labour','Non Labour');
INSERT INTO [Gold].[Dimcosttye] ([CostType],[Description]) VALUES ('T&E','T&E');
GO

TRUNCATE TABLE   [Gold].[DimWBSCode] 
GO
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.0',NULL,1,1,'Company');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1','1.0',2,2,'Engineering Management, Governance & Assurance');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1','1.1',3,3,'Engineering Governance & Assurance');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.1','1.1.1',4,4,'Engineering Governance & Assurance');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.2','1.1.1',4,5,'Engineering Policies');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.3','1.1.1',4,6,'Engineering Interfaces');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.4','1.1.1',4,7,'Engineering Processes');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.5','1.1.1',4,8,'Engineering Safety Management System');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.6','1.1.1',4,9,'Regulations & Standards');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.1.7','1.1.1',4,10,'Engineering Assurance');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.2','1.1',3,11,'Engineering Capability Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3','1.1',3,12,'Engineering and Technical Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.1','1.1.3',4,13,'Engineering Planning, Assessment and Control');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.2','1.1.3',4,14,'Technology Management and Planning');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.3','1.1.3',4,15,'Technical Bid Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.4','1.1.3',4,16,'Supply Chain Coordination');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.5','1.1.3',4,17,'Engineering Export Control Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.6','1.1.3',4,18,'Engineering Risk Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.7','1.1.3',4,19,'Decision Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.8','1.1.3',4,20,'Technical Assumptions Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.9','1.1.3',4,21,'Configuration & Information (Data) Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.10','1.1.3',4,22,'Measurement & Management by Maturity');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.1.3.11','1.1.3',4,23,'Engineering Lifecycle Management');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.2',1.0,2,24,'Airworthiness');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.2.1',1.2,3,25,'DOA Certification Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.2.2',1.2,3,26,'Certification/Initial Airworthiness Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.2.3',1.2,3,27,'Continued Airworthiness');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.2.4',1.2,3,28,'Compliance Verification Engineering (CVE)');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3',1.0,2,29,'Systems Engineering and Integration');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.1',1.3,3,30,'Requirements Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.2',1.3,3,31,'Product Configuration Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.3',1.3,3,32,'Systems Architecture');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.4',1.3,3,33,'Modelling and Simulation');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.5',1.3,3,34,'Product Safety');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.6',1.3,3,35,'Reliability, Maintainability and Testability (RMT)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.7',1.3,3,36,'Human Factors Integration (HFI)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.8',1.3,3,37,'Survivability');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.9',1.3,3,38,'Product Environment');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.10',1.3,3,39,'Environmental Standards');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.11',1.3,3,40,'Software Systems Engineering');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.12',1.3,3,41,'Product Security');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.13',1.3,3,42,'Operational Effectiveness');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.14',1.3,3,43,'Product Strategy');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.15',1.3,3,44,'Qualification Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.3.16',1.3,3,45,'Obsolescence Management');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.4','1.0',2,46,'GCAP System Test & Evaluation (T&E)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.4.1','1.4',3,47,'T&E Planning');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.4.2','1.4',3,48,'T&E Co-ordination');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.4.3','1.4',3,49,'T&E Delivery');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5','1.0',2,50,'Core Platform');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.1','1.5',3,51,'CP Integration');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.2','1.5',3,52,'Physical Air Vehicle Integration');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.3','1.5',3,53,'Cockpit Integration');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.4','1.5',3,54,'Weapon Integration');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.5','1.5',3,55,'Airframe');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.6','1.5',3,56,'Propulsion System Supplier Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.7','1.5',3,57,'Flight System (FS)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.8','1.5',3,58,'SANKE System Supplier Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.9','1.5',3,59,'Comms System Supplier Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.10','1.5',3,60,'Mission System (MS)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.5.11','1.5',3,61,'Computing System');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.6','1.0',2,62,'Support System');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.6.1','1.6',3,63,'Support System Concepting and Integration');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.7','1.0',2,64,'Training and Training Equipment');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.7.1','1.7',3,65,'Training and Training Equipment Concepting and Integration');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.8','1.0',2,66,'Integrated Product Support (IPS)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.8.1','1.8',3,67,'Integrated Product Support (IPS) Concepting and Integration');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.9','1.0',2,68,'Mission Enablement');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.9.1','1.9',3,69,'Mission Enablement Concepting and Integration');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.10','1.0',2,70,'Production');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.10.1','1.1',3,71,'ManuFacturing Equipment and Planning');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11','1.0',2,72,'Integrated Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.1','1.11',3,73,'Core Product Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.2','1.11',3,74,'Procurement and Supply Chain Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.3','1.11',3,75,'Quality Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.4','1.11',3,76,'Commercial, Business and Sales Management, Business Development');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.5','1.11',3,77,'Audit Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.6','1.11',3,78,'Legal and Compliance Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.7','1.11',3,79,'Financial Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.8','1.11',3,80,'Human Resource Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.9','1.11',3,81,'Communications Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.11.10','1.11',3,82,'Sustainability Management');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.12','1.0',2,83,'Business Operations - Facilities, General Service Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.12.1','1.12',3,84,'Enterprise Safety Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.12.2','1.12',3,85,'Enterprise Risk Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.12.3','1.12',3,86,'General Services');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13','1.0',2,87,'Enterprise Enablers');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.1','1.13',3,88,'Digital Enablement');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.2','1.13',3,89,'Secure Digital Platform');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.2.1','1.13.2',4,90,'ACWE-R');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.2.2','1.13.2',4,91,'ACWE-S');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.2.3','1.13.2',4,92,'Service Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.3','1.13',3,93,'Digital Business');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.3.1','1.13.3',4,94,'DB Service Management');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.4','1.13',3,95,'Data and Insights');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.5','1.13',3,96,'Digital Engineering');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.6','1.13',3,97,'Secure Physical Infrastructure');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.13.7','1.13',3,98,'Security');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.14','1.0',2,99,'Domains');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.14.1','1.14',3,100,'Propulsion System Development (LSSI)');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.14.2','1.14',3,101,'SANKE & Comms Systems Development (LSSI)');

INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90','1.0',2,102,'Functional Cost Centre');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.1','1.9',3,103,'Finance CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.2','1.9',3,104,'Programme Management CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.3','1.9',3,105,'Engineering Technology & Innovation CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.4','1.9',3,106,'Procurement and Supply Chain Management CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.5','1.9',3,107,'Commercial & Business Strategy CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.6','1.9',3,108,'Digital & Information CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.7','1.9',3,109,'Legal & Compliance');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.8','1.9',3,110,'People CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.9','1.9',3,111,'Security CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.10','1.9',3,112,'Quality CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.11','1.9',3,113,'Communications CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.12','1.9',3,114,'Enterprise Risk Management CC');
INSERT INTO [Gold].[DimWBSCode] ([WBSCode],[ParentWBSCode],[WBSLevel],[SortOrder],[Description]) VALUES ('1.90.13','1.9',3,115,'Audit Management CC');
GO

TRUNCATE TABLE Gold.DimCurrency
GO

INSERT INTO Gold.DimCurrency (CurrencyCode, CurrencyName, DecimalPlaces, IsReporting)
VALUES
    ('GBP', 'Pound Sterling', 2, 1),
    ('EUR', 'Euro', 2, 0),
    ('JPY', 'Japanese Yen', 0, 0);
GO

TRUNCATE TABLE Gold.DimPeriod
GO
INSERT INTO Gold.DimPeriod (PeriodKey, PeriodStartDate, PeriodEndDate, CalendarYear, CalendarMonth, MonthName, MonthShort, FiscalYearStart, FiscalYearLabel, FiscalMonthNumber, FiscalQuarter, FiscalQuarterLabel, FiscalPeriodLabel)
VALUES
    (202604, '2026-04-01', '2026-04-30', 2026, 4, 'April', 'Apr', 2026, 'FY2026/27', 1, 1, 'Q1 FY26/27', 'P01 Apr-26'),
    (202605, '2026-05-01', '2026-05-31', 2026, 5, 'May', 'May', 2026, 'FY2026/27', 2, 1, 'Q1 FY26/27', 'P02 May-26'),
    (202606, '2026-06-01', '2026-06-30', 2026, 6, 'June', 'Jun', 2026, 'FY2026/27', 3, 1, 'Q1 FY26/27', 'P03 Jun-26'),
    (202607, '2026-07-01', '2026-07-31', 2026, 7, 'July', 'Jul', 2026, 'FY2026/27', 4, 2, 'Q2 FY26/27', 'P04 Jul-26'),
    (202608, '2026-08-01', '2026-08-31', 2026, 8, 'August', 'Aug', 2026, 'FY2026/27', 5, 2, 'Q2 FY26/27', 'P05 Aug-26'),
    (202609, '2026-09-01', '2026-09-30', 2026, 9, 'September', 'Sep', 2026, 'FY2026/27', 6, 2, 'Q2 FY26/27', 'P06 Sep-26'),
    (202610, '2026-10-01', '2026-10-31', 2026, 10, 'October', 'Oct', 2026, 'FY2026/27', 7, 3, 'Q3 FY26/27', 'P07 Oct-26'),
    (202611, '2026-11-01', '2026-11-30', 2026, 11, 'November', 'Nov', 2026, 'FY2026/27', 8, 3, 'Q3 FY26/27', 'P08 Nov-26'),
    (202612, '2026-12-01', '2026-12-31', 2026, 12, 'December', 'Dec', 2026, 'FY2026/27', 9, 3, 'Q3 FY26/27', 'P09 Dec-26'),
    (202701, '2027-01-01', '2027-01-31', 2027, 1, 'January', 'Jan', 2026, 'FY2026/27', 10, 4, 'Q4 FY26/27', 'P10 Jan-27'),
    (202702, '2027-02-01', '2027-02-28', 2027, 2, 'February', 'Feb', 2026, 'FY2026/27', 11, 4, 'Q4 FY26/27', 'P11 Feb-27'),
    (202703, '2027-03-01', '2027-03-31', 2027, 3, 'March', 'Mar', 2026, 'FY2026/27', 12, 4, 'Q4 FY26/27', 'P12 Mar-27');
GO

TRUNCATE TABLE Gold.FactExchangeRate 
INSERT INTO Gold.FactExchangeRate (CurrencyCode, PeriodKey, RateType, RateToGBP)
VALUES
    ('GBP', 202604, 'Budget', 1),
    ('GBP', 202604, 'Actual', 1),
    ('GBP', 202605, 'Budget', 1),
    ('GBP', 202605, 'Actual', 1),
    ('GBP', 202606, 'Budget', 1),
    ('GBP', 202606, 'Actual', 1),
    ('GBP', 202607, 'Budget', 1),
    ('GBP', 202607, 'Actual', 1),
    ('GBP', 202608, 'Budget', 1),
    ('GBP', 202608, 'Actual', 1),
    ('GBP', 202609, 'Budget', 1),
    ('GBP', 202609, 'Actual', 1),
    ('GBP', 202610, 'Budget', 1),
    ('GBP', 202610, 'Actual', 1),
    ('GBP', 202611, 'Budget', 1),
    ('GBP', 202611, 'Actual', 1),
    ('GBP', 202612, 'Budget', 1),
    ('GBP', 202612, 'Actual', 1),
    ('GBP', 202701, 'Budget', 1),
    ('GBP', 202702, 'Budget', 1),
    ('GBP', 202703, 'Budget', 1),
    ('EUR', 202604, 'Budget', 0.85000000),
    ('EUR', 202604, 'Actual', 0.85200000),
    ('EUR', 202605, 'Budget', 0.85000000),
    ('EUR', 202605, 'Actual', 0.84850000),
    ('EUR', 202606, 'Budget', 0.85000000),
    ('EUR', 202606, 'Actual', 0.84500000),
    ('EUR', 202607, 'Budget', 0.85000000),
    ('EUR', 202607, 'Actual', 0.84100000),
    ('EUR', 202608, 'Budget', 0.85000000),
    ('EUR', 202608, 'Actual', 0.83950000),
    ('EUR', 202609, 'Budget', 0.85000000),
    ('EUR', 202609, 'Actual', 0.84400000),
    ('EUR', 202610, 'Budget', 0.85000000),
    ('EUR', 202610, 'Actual', 0.85300000),
    ('EUR', 202611, 'Budget', 0.85000000),
    ('EUR', 202611, 'Actual', 0.85750000),
    ('EUR', 202612, 'Budget', 0.85000000),
    ('EUR', 202612, 'Actual', 0.86100000),
    ('EUR', 202701, 'Budget', 0.85000000),
    ('EUR', 202702, 'Budget', 0.85000000),
    ('EUR', 202703, 'Budget', 0.85000000),
    ('JPY', 202604, 'Budget', 0.00520000),
    ('JPY', 202604, 'Actual', 0.00515000),
    ('JPY', 202605, 'Budget', 0.00520000),
    ('JPY', 202605, 'Actual', 0.00512000),
    ('JPY', 202606, 'Budget', 0.00520000),
    ('JPY', 202606, 'Actual', 0.00509000),
    ('JPY', 202607, 'Budget', 0.00520000),
    ('JPY', 202607, 'Actual', 0.00506000),
    ('JPY', 202608, 'Budget', 0.00520000),
    ('JPY', 202608, 'Actual', 0.00511000),
    ('JPY', 202609, 'Budget', 0.00520000),
    ('JPY', 202609, 'Actual', 0.00518000),
    ('JPY', 202610, 'Budget', 0.00520000),
    ('JPY', 202610, 'Actual', 0.00524000),
    ('JPY', 202611, 'Budget', 0.00520000),
    ('JPY', 202611, 'Actual', 0.00529000),
    ('JPY', 202612, 'Budget', 0.00520000),
    ('JPY', 202612, 'Actual', 0.00531000),
    ('JPY', 202701, 'Budget', 0.00520000),
    ('JPY', 202702, 'Budget', 0.00520000),
    ('JPY', 202703, 'Budget', 0.00520000);
GO