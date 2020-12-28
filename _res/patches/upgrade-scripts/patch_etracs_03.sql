use etracs255_aklan
go 


if object_id('dbo.account_incometarget', 'U') IS NOT NULL 
  drop table account_incometarget; 
go 


if object_id('dbo.account_item_mapping', 'U') IS NOT NULL 
  drop table account_item_mapping; 
go 
if object_id('dbo.account_group', 'U') IS NOT NULL 
  drop table account_group; 
go 
if object_id('dbo.account', 'U') IS NOT NULL 
  drop table account; 
go 
if object_id('dbo.account_maingroup', 'U') IS NOT NULL 
  drop table account_maingroup; 
go 



CREATE TABLE account_maingroup (
  objid varchar(50) NOT NULL,
  title varchar(255) NOT NULL,
  version int NOT NULL,
  reporttype varchar(50) NULL,
  role varchar(50) NULL,
  domain varchar(50) NULL,
  system int NULL,
  constraint pk_account_maingroup PRIMARY KEY (objid)
)
go 

CREATE TABLE account (
  objid varchar(50) NOT NULL,
  maingroupid varchar(50) NULL,
  code varchar(100) NULL,
  title varchar(255) NULL,
  groupid varchar(50) NULL,
  type varchar(50) NULL,
  leftindex int NULL,
  rightindex int NULL,
  level int NULL,
  constraint pk_account PRIMARY KEY (objid) 
)
go 
create index ix_maingroupid on account (maingroupid) 
go
create index ix_code on account (code) 
go
create index ix_title on account (title) 
go
create index ix_groupid on account (groupid) 
go
create index uix_account_code on account (maingroupid,code) 
go


CREATE TABLE account_item_mapping (
  objid varchar(50) NOT NULL,
  maingroupid varchar(50) NULL,
  acctid varchar(50) NOT NULL,
  itemid varchar(50) NOT NULL,
  constraint pk_account_item_mapping PRIMARY KEY (objid) 
)
go 
create index ix_maingroupid on account_item_mapping (maingroupid) 
go
create index ix_acctid on account_item_mapping (acctid) 
go
create index ix_itemid on account_item_mapping (itemid) 
go


create table account_incometarget (
  objid varchar(50) not null, 
  itemid varchar(50) not null, 
  year int not null, 
  target decimal(16,2) not null, 
  constraint pk_account_incometarget primary key (objid)
)
go  
create index ix_itemid on account_incometarget (itemid)
go
create index ix_year on account_incometarget (year)
go


INSERT INTO account_maingroup (objid, title, version, reporttype, role, domain, system) VALUES ('NGAS', 'NGAS', '1', 'NGAS', NULL, NULL, NULL);
INSERT INTO account_maingroup (objid, title, version, reporttype, role, domain, system) VALUES ('PPSAS', 'PPSAS', '1', 'PPSAS', NULL, NULL, '0');
INSERT INTO account_maingroup (objid, title, version, reporttype, role, domain, system) VALUES ('SRE', 'SRE', '0', 'SRE', NULL, NULL, NULL);


INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-1', 'PPSAS', '1', 'Assets', 'root', '0', '673', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-2', 'PPSAS', '2', 'Liabilities', 'root', '674', '787', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-3', 'PPSAS', '3', 'Equity', 'root', '788', '815', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-4', 'PPSAS', '4', 'Income', 'root', '816', '1049', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-5', 'PPSAS', '5', 'Expenses', 'root', '1050', '1405', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-101', 'PPSAS', '101', 'Cash', 'group', '1', '20', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-102', 'PPSAS', '102', 'Investments', 'group', '21', '76', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-103', 'PPSAS', '103', 'Receivables', 'group', '77', '180', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104', 'PPSAS', '104', 'Inventories', 'group', '181', '246', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040105', 'PPSAS', '104040105', 'Prepayments and Deferred Charges', 'item', '247', '248', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-105', 'PPSAS', '105', 'Prepayments and Deferred Charges', 'group', '249', '268', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-106', 'PPSAS', '106', 'Investment Property', 'group', '269', '284', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-107', 'PPSAS', '107', 'Property, Plant and Equipment', 'group', '285', '634', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-108', 'PPSAS', '108', 'Biological Assets', 'group', '635', '646', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-109', 'PPSAS', '109', 'Intangible Assets', 'group', '647', '672', '2', 'PPSAS-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10101', 'PPSAS', '10101', 'Cash on Hand', 'group', '2', '7', '3', 'PPSAS-101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10102', 'PPSAS', '10102', 'Cash in Bank - Local Currency', 'group', '8', '13', '3', 'PPSAS-101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10103', 'PPSAS', '10103', 'Cash in Bank - Foreign Currency', 'group', '14', '19', '3', 'PPSAS-101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10101010', 'PPSAS', '10101010', 'Cash Local Treasury', 'item', '3', '4', '4', 'PPSAS-10101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10101020', 'PPSAS', '10101020', 'Petty Cash', 'item', '5', '6', '4', 'PPSAS-10101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10102010', 'PPSAS', '10102010', 'Cash in Bank - Local Currency, Current Account', 'item', '9', '10', '4', 'PPSAS-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10102020', 'PPSAS', '10102020', 'Cash in Bank - Local Currency, Savings Account', 'item', '11', '12', '4', 'PPSAS-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10103010', 'PPSAS', '10103010', 'Cash in Bank - Foreign Currency, Current Account', 'item', '15', '16', '4', 'PPSAS-10103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10103020', 'PPSAS', '10103020', 'Cash in Bank - Foreign Currency, Savings Account', 'item', '17', '18', '4', 'PPSAS-10103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10201', 'PPSAS', '10201', 'Investments in Time Deposits', 'group', '22', '29', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10202', 'PPSAS', '10202', 'Financial  Assets at Fair Value Through Surplus or Deficit', 'group', '30', '35', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10203', 'PPSAS', '10203', 'Financial Assets - Held to Maturity', 'group', '36', '45', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10204', 'PPSAS', '10204', 'Financial Assets - Available for Sale', 'group', '46', '51', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205', 'PPSAS', '10205', 'Financial Assets - Others', 'group', '52', '65', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10206', 'PPSAS', '10206', 'Investments in Joint Venture', 'group', '66', '71', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10207', 'PPSAS', '10207', 'Sinking Fund', 'group', '72', '75', '3', 'PPSAS-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10201010', 'PPSAS', '10201010', 'Cash in Bank -Local Currency, Time Deposits', 'item', '23', '24', '4', 'PPSAS-10201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10201020', 'PPSAS', '10201020', 'Cash in Bank - Foreign Currency, Time Deposits', 'item', '25', '26', '4', 'PPSAS-10201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10201030', 'PPSAS', '10201030', 'Treasury Bills', 'item', '27', '28', '4', 'PPSAS-10201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10202010', 'PPSAS', '10202010', 'Financial Assets Held for Trading', 'item', '31', '32', '4', 'PPSAS-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10202020', 'PPSAS', '10202020', 'Financial  Assets Designated at Fair Value Through Surplus or Deficit', 'item', '33', '34', '4', 'PPSAS-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10203010', 'PPSAS', '10203010', 'Investments in Treasury Bills - Local', 'item', '37', '38', '4', 'PPSAS-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10203011', 'PPSAS', '10203011', 'Allowance for Impairment - Investments in Treasury Bills - Local', 'item', '39', '40', '4', 'PPSAS-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10203020', 'PPSAS', '10203020', 'Investments in  Bonds-Local', 'item', '41', '42', '4', 'PPSAS-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10203021', 'PPSAS', '10203021', 'Allowance for Impairment - Investments in Bonds - Local', 'item', '43', '44', '4', 'PPSAS-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10204010', 'PPSAS', '10204010', 'Investments in Stocks', 'item', '47', '48', '4', 'PPSAS-10204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10204020', 'PPSAS', '10204020', 'Investments in Bonds', 'item', '49', '50', '4', 'PPSAS-10204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205010', 'PPSAS', '10205010', 'Deposits on Letters of Credit', 'item', '53', '54', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205011', 'PPSAS', '10205011', 'Allowance for Impairment - Deposits in Letters of Credit', 'item', '55', '56', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205020', 'PPSAS', '10205020', 'Guaranty Deposits', 'item', '57', '58', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205021', 'PPSAS', '10205021', 'Allowance for Impairment - Guaranty Deposits', 'item', '59', '60', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205990', 'PPSAS', '10205990', 'Other Investments', 'item', '61', '62', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10205991', 'PPSAS', '10205991', 'Allowance for Impairment - Other Investments', 'item', '63', '64', '4', 'PPSAS-10205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10206010', 'PPSAS', '10206010', 'Investments in Joint Venture', 'item', '67', '68', '4', 'PPSAS-10206');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10206011', 'PPSAS', '10206011', 'Allowance for Impairment - Investments in Joint Venture', 'item', '69', '70', '4', 'PPSAS-10206');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10207010', 'PPSAS', '10207010', 'Sinking Fund', 'item', '73', '74', '4', 'PPSAS-10207');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301', 'PPSAS', '10301', 'Loans and Receivable Accounts', 'group', '78', '115', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10302', 'PPSAS', '10302', 'Lease  Receivables', 'group', '116', '125', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303', 'PPSAS', '10303', 'Inter-Agency Receivables', 'group', '126', '143', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10304', 'PPSAS', '10304', 'Intra-Agency Receivables', 'group', '144', '151', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10305', 'PPSAS', '10305', 'Advances', 'group', '152', '161', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306', 'PPSAS', '10306', 'Other Receivables', 'group', '162', '179', '3', 'PPSAS-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301010', 'PPSAS', '10301010', 'Accounts Receivable', 'item', '79', '80', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301011', 'PPSAS', '10301011', 'Allowance for Impairment - Accounts Receivable', 'item', '81', '82', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301020', 'PPSAS', '10301020', 'Real Property Tax Receivable', 'item', '83', '84', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301021', 'PPSAS', '10301021', 'Allowance for Impairment - RPT Receivable', 'item', '85', '86', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301030', 'PPSAS', '10301030', 'Special Education Tax Receivable', 'item', '87', '88', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301031', 'PPSAS', '10301031', 'Allowance for Impairment - SET Receivable', 'item', '89', '90', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301040', 'PPSAS', '10301040', 'Notes Receivable', 'item', '91', '92', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301041', 'PPSAS', '10301041', 'Allowance for Impairment - Notes Receivable', 'item', '93', '94', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301050', 'PPSAS', '10301050', 'Loans Receivable - Government-Owned and/or Controlled Corporations', 'item', '95', '96', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301051', 'PPSAS', '10301051', 'Allowance for Impairment - Loans Receivable - Government-Owned and/or Controlled Corporations', 'item', '97', '98', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301060', 'PPSAS', '10301060', 'Loans Receivable - Local Government Units', 'item', '99', '100', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301061', 'PPSAS', '10301061', 'Allowance for Impairment  - Loans Receivable - Local Government Units', 'item', '101', '102', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301070', 'PPSAS', '10301070', 'Interests Receivable', 'item', '103', '104', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301071', 'PPSAS', '10301071', 'Allowance for Impairment - Interests Receivable', 'item', '105', '106', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301080', 'PPSAS', '10301080', 'Dividends Receivable', 'item', '107', '108', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301081', 'PPSAS', '10301081', 'Allowance for Impairment - Dividends Receivable', 'item', '109', '110', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301990', 'PPSAS', '10301990', 'Loans Receivable - Others', 'item', '111', '112', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10301991', 'PPSAS', '10301991', 'Allowance for Impairment - Loans Receivable - Others', 'item', '113', '114', '4', 'PPSAS-10301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10302010', 'PPSAS', '10302010', 'Operating Lease  Receivable', 'item', '117', '118', '4', 'PPSAS-10302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10302011', 'PPSAS', '10302011', 'Allowance for Impairment - Operating Lease Receivable', 'item', '119', '120', '4', 'PPSAS-10302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10302020', 'PPSAS', '10302020', 'Finance Lease Receivable', 'item', '121', '122', '4', 'PPSAS-10302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10302021', 'PPSAS', '10302021', 'Allowance for Impairment - Finance Lease Receivable', 'item', '123', '124', '4', 'PPSAS-10302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303010', 'PPSAS', '10303010', 'Due from National Government Agencies', 'item', '127', '128', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303011', 'PPSAS', '10303011', 'Allowance for Impairment - Due from National Government Agencies', 'item', '129', '130', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303020', 'PPSAS', '10303020', 'Due from Government-Owned and/or Controlled Corporations', 'item', '131', '132', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303021', 'PPSAS', '10303021', 'Allowance for Impairment - Due from GOCCs', 'item', '133', '134', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303030', 'PPSAS', '10303030', 'Due from Local Government Units', 'item', '135', '136', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303031', 'PPSAS', '10303031', 'Allowance for Impairment - Due from LGUs', 'item', '137', '138', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303040', 'PPSAS', '10303040', 'Due from Joint Venture', 'item', '139', '140', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10303041', 'PPSAS', '10303041', 'Allowance for Impairment - Due from Joint Venture', 'item', '141', '142', '4', 'PPSAS-10303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10304050', 'PPSAS', '10304050', 'Due from Other Funds', 'item', '145', '146', '4', 'PPSAS-10304');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10304060', 'PPSAS', '10304060', 'Due from Special Accounts', 'item', '147', '148', '4', 'PPSAS-10304');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10304070', 'PPSAS', '10304070', 'Due from Local Economic Enterprise', 'item', '149', '150', '4', 'PPSAS-10304');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10305010', 'PPSAS', '10305010', 'Advances for Operating Expenses', 'item', '153', '154', '4', 'PPSAS-10305');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10305020', 'PPSAS', '10305020', 'Advances for Payroll', 'item', '155', '156', '4', 'PPSAS-10305');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10305030', 'PPSAS', '10305030', 'Advances to Special Disbursing Officer', 'item', '157', '158', '4', 'PPSAS-10305');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10305040', 'PPSAS', '10305040', 'Advances for Officers and Employees', 'item', '159', '160', '4', 'PPSAS-10305');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306010', 'PPSAS', '10306010', 'Receivables - Disallowances/Charges', 'item', '163', '164', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306011', 'PPSAS', '10306011', 'Allowance for Impairment - Receivables- Disallowances/Charges', 'item', '165', '166', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306020', 'PPSAS', '10306020', 'Due from Officers and Employees', 'item', '167', '168', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306021', 'PPSAS', '10306021', 'Allowance for Impairment - Due from Officers and Employees', 'item', '169', '170', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306030', 'PPSAS', '10306030', 'Due from Non-Government Organizations/People''s Organizations', 'item', '171', '172', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306031', 'PPSAS', '10306031', 'Allowance for Impairment - Due from Non-Government Organizations/People''s Organizations', 'item', '173', '174', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306990', 'PPSAS', '10306990', 'Other Receivables', 'item', '175', '176', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10306991', 'PPSAS', '10306991', 'Allowance for Impairment - Other Receivables', 'item', '177', '178', '4', 'PPSAS-10306');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10401', 'PPSAS', '10401', 'Inventory Held for Sale', 'group', '182', '185', '3', 'PPSAS-104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402', 'PPSAS', '10402', 'Inventory Held for Distribution', 'group', '186', '207', '3', 'PPSAS-104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10403', 'PPSAS', '10403', 'Inventory Held for Manufacturing', 'group', '208', '215', '3', 'PPSAS-104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404', 'PPSAS', '10404', 'Inventory Held for Consumption', 'group', '216', '245', '3', 'PPSAS-104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10401010', 'PPSAS', '10401010', 'Merchandise Inventory', 'item', '183', '184', '4', 'PPSAS-10401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402010', 'PPSAS', '10402010', 'Food Supplies for Distribution', 'item', '187', '188', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402020', 'PPSAS', '10402020', 'Welfare Goods for Distribution', 'item', '189', '190', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402030', 'PPSAS', '10402030', 'Drugs and Medicines for Distribution', 'item', '191', '192', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402040', 'PPSAS', '10402040', 'Medical, Dental and Laboratory Supplies for Distribution', 'item', '193', '194', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402050', 'PPSAS', '10402050', 'Agricultural and Marine Supplies for Distribution', 'item', '195', '196', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402060', 'PPSAS', '10402060', 'Agricultural Produce for Distribution', 'item', '197', '198', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402070', 'PPSAS', '10402070', 'Textbooks and Instructional Materials for Distribution', 'item', '199', '200', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402080', 'PPSAS', '10402080', 'Construction Materials for Distribution', 'item', '201', '202', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402090', 'PPSAS', '10402090', 'Property and Equipment for Distribution', 'item', '203', '204', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10402990', 'PPSAS', '10402990', 'Other Supplies and Materials for Distribution', 'item', '205', '206', '4', 'PPSAS-10402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10403010', 'PPSAS', '10403010', 'Raw Materials Inventory', 'item', '209', '210', '4', 'PPSAS-10403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10403020', 'PPSAS', '10403020', 'Work-in-Process Inventory', 'item', '211', '212', '4', 'PPSAS-10403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10403030', 'PPSAS', '10403030', 'Finished Goods Inventory', 'item', '213', '214', '4', 'PPSAS-10403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404010', 'PPSAS', '10404010', 'Office Supplies Inventory', 'item', '217', '218', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040100', 'PPSAS', '104040100', 'Textbooks and Instructional Materials Inventory', 'item', '219', '220', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040110', 'PPSAS', '104040110', 'Military, Police and Traffic Supplies Inventory', 'item', '221', '222', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040120', 'PPSAS', '104040120', 'Chemical and Filtering Supplies Inventory', 'item', '223', '224', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040130', 'PPSAS', '104040130', 'Construction Materials Inventory', 'item', '225', '226', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404020', 'PPSAS', '10404020', 'Accountable Forms, Plates and Stickers', 'item', '227', '228', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404030', 'PPSAS', '10404030', 'Non-Accountable Forms Inventory', 'item', '229', '230', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404040', 'PPSAS', '10404040', 'Animal/Zoological Supplies Inventory', 'item', '231', '232', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404050', 'PPSAS', '10404050', 'Food Supplies Inventory', 'item', '233', '234', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404060', 'PPSAS', '10404060', 'Drugs and Medicines Inventory', 'item', '235', '236', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404070', 'PPSAS', '10404070', 'Medical, Dental and Laboratory Supplies Inventory', 'item', '237', '238', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404080', 'PPSAS', '10404080', 'Fuel, Oil and Lubricants Inventory', 'item', '239', '240', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10404090', 'PPSAS', '10404090', 'Agricultural and Marine Supplies Inventory', 'item', '241', '242', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-104040990', 'PPSAS', '104040990', 'Other Supplies and Materials Inventory', 'item', '243', '244', '4', 'PPSAS-10404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501', 'PPSAS', '10501', 'Prepayments', 'group', '250', '263', '3', 'PPSAS-105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10502', 'PPSAS', '10502', 'Deferred Charges', 'group', '264', '267', '3', 'PPSAS-105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501010', 'PPSAS', '10501010', 'Advances to Contractors', 'item', '251', '252', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501020', 'PPSAS', '10501020', 'Prepaid Rent', 'item', '253', '254', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501030', 'PPSAS', '10501030', 'Prepaid Registration', 'item', '255', '256', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501040', 'PPSAS', '10501040', 'Prepaid Interest', 'item', '257', '258', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501050', 'PPSAS', '10501050', 'Prepaid Insurance', 'item', '259', '260', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10501990', 'PPSAS', '10501990', 'Other Prepayments', 'item', '261', '262', '4', 'PPSAS-10501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10502010', 'PPSAS', '10502010', 'Discount on Advance Payments', 'item', '265', '266', '4', 'PPSAS-10502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601', 'PPSAS', '10601', 'Land and Buildings', 'group', '270', '283', '3', 'PPSAS-106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601010', 'PPSAS', '10601010', 'Investment Property,  Land', 'item', '271', '272', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601011', 'PPSAS', '10601011', 'Accumulated Impairment Losses - Investment Property,  Land', 'item', '273', '274', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601020', 'PPSAS', '10601020', 'Investment Property, Buildings', 'item', '275', '276', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601021', 'PPSAS', '10601021', 'Accumulated Depreciation - Investment Property, Buildings', 'item', '277', '278', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601022', 'PPSAS', '10601022', 'Accumulated Impairment Losses - Investment Property,  Buildings', 'item', '279', '280', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10601030', 'PPSAS', '10601030', 'Construction in Progress - Investment Property, Buildings', 'item', '281', '282', '4', 'PPSAS-10601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10701', 'PPSAS', '10701', 'Land', 'group', '286', '291', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702', 'PPSAS', '10702', 'Land Improvements', 'group', '292', '305', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703', 'PPSAS', '10703', 'Infrastructure Assets', 'group', '306', '367', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704', 'PPSAS', '10704', 'Buildings and Other Structures', 'group', '368', '411', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705', 'PPSAS', '10705', 'Machinery  and Equipment', 'group', '412', '503', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706', 'PPSAS', '10706', 'Transportation Equipment', 'group', '504', '535', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707', 'PPSAS', '10707', 'Furniture, Fixtures and Books', 'group', '536', '549', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708', 'PPSAS', '10708', 'Leased Assets', 'group', '550', '579', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709', 'PPSAS', '10709', 'Leased Assets Improvements', 'group', '580', '599', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710', 'PPSAS', '10710', 'Construction in Progress', 'group', '600', '611', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10711', 'PPSAS', '10711', 'Service Concession Assets', 'group', '612', '619', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799', 'PPSAS', '10799', 'Other Property, Plant and Equipment', 'group', '620', '633', '3', 'PPSAS-107');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-1070110', 'PPSAS', '1070110', 'Land', 'item', '287', '288', '4', 'PPSAS-10701');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-1070111', 'PPSAS', '1070111', 'Accumulated Impairment Losses - Land', 'item', '289', '290', '4', 'PPSAS-10701');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702010', 'PPSAS', '10702010', 'Land Improvements,  Aquaculture Structures', 'item', '293', '294', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702011', 'PPSAS', '10702011', 'Accumulated Depreciation - Land Improvements, Aquaculture Structures', 'item', '295', '296', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702012', 'PPSAS', '10702012', 'Accumulated Impairment Losses - Land Improvements, Aquaculture Structures', 'item', '297', '298', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702990', 'PPSAS', '10702990', 'Other Land Improvements', 'item', '299', '300', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702991', 'PPSAS', '10702991', 'Accumulated Depreciation - Other Land Improvements', 'item', '301', '302', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10702992', 'PPSAS', '10702992', 'Accumulated Impairment Losses - Other Land Improvements', 'item', '303', '304', '4', 'PPSAS-10702');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703010', 'PPSAS', '10703010', 'Road Networks', 'item', '307', '308', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703011', 'PPSAS', '10703011', 'Accumulated Depreciation - Road Networks', 'item', '309', '310', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703012', 'PPSAS', '10703012', 'Accumulated Impairment Losses - Road Networks', 'item', '311', '312', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703020', 'PPSAS', '10703020', 'Flood Control Systems', 'item', '313', '314', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703021', 'PPSAS', '10703021', 'Accumulated Depreciation - Flood Control Systems', 'item', '315', '316', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703022', 'PPSAS', '10703022', 'Accumulated Impairment Losses - Flood Control Systems', 'item', '317', '318', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703030', 'PPSAS', '10703030', 'Sewer Systems', 'item', '319', '320', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703031', 'PPSAS', '10703031', 'Accumulated Depreciation - Sewer Systems', 'item', '321', '322', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703032', 'PPSAS', '10703032', 'Accumulated Impairment Losses - Sewer Systems', 'item', '323', '324', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703040', 'PPSAS', '10703040', 'Water Supply Systems', 'item', '325', '326', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703041', 'PPSAS', '10703041', 'Accumulated Depreciation - Water Supply Systems', 'item', '327', '328', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703042', 'PPSAS', '10703042', 'Accumulated Impairment Losses - Water Supply Systems', 'item', '329', '330', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703050', 'PPSAS', '10703050', 'Power Supply Systems', 'item', '331', '332', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703051', 'PPSAS', '10703051', 'Accumulated Depreciation - Power Supply Systems', 'item', '333', '334', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703052', 'PPSAS', '10703052', 'Accumulated Impairment Losses - Power Supply Systems', 'item', '335', '336', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703060', 'PPSAS', '10703060', 'Communication Networks', 'item', '337', '338', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703061', 'PPSAS', '10703061', 'Accumulated Depreciation - Communication Networks', 'item', '339', '340', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703062', 'PPSAS', '10703062', 'Accumulated Impairment Losses - Communication Networks', 'item', '341', '342', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703070', 'PPSAS', '10703070', 'Seaport Systems', 'item', '343', '344', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703071', 'PPSAS', '10703071', 'Accumulated Depreciation - Seaport Systems', 'item', '345', '346', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703072', 'PPSAS', '10703072', 'Accumulated Impairment Losses - Seaport Systems', 'item', '347', '348', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703080', 'PPSAS', '10703080', 'Airport Systems', 'item', '349', '350', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703081', 'PPSAS', '10703081', 'Accumulated Depreciation - Airport Systems', 'item', '351', '352', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703082', 'PPSAS', '10703082', 'Accumulated Impairment Losses - Airport Systems', 'item', '353', '354', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703090', 'PPSAS', '10703090', 'Parks, Plazas and Monuments', 'item', '355', '356', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703091', 'PPSAS', '10703091', 'Accumulated Depreciation - Parks, Plazas and Monuments', 'item', '357', '358', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703092', 'PPSAS', '10703092', 'Accumulated Impairment Losses - Parks, Plazas and Monuments', 'item', '359', '360', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703990', 'PPSAS', '10703990', 'Other Infrastructure Assets', 'item', '361', '362', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703991', 'PPSAS', '10703991', 'Accumulated Depreciation - Other Infrastructure Assets', 'item', '363', '364', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10703992', 'PPSAS', '10703992', 'Accumulated Impairment Losses - Other Infrastructure Assets', 'item', '365', '366', '4', 'PPSAS-10703');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704010', 'PPSAS', '10704010', 'Buildings', 'item', '369', '370', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704011', 'PPSAS', '10704011', 'Accumulated Depreciation - Buildings', 'item', '371', '372', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704012', 'PPSAS', '10704012', 'Accumulated Impairment Losses - Buildings', 'item', '373', '374', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704020', 'PPSAS', '10704020', 'School Buildings', 'item', '375', '376', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704021', 'PPSAS', '10704021', 'Accumulated Depreciation - School Buildings', 'item', '377', '378', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704022', 'PPSAS', '10704022', 'Accumulated Impairment Losses - School Buildings', 'item', '379', '380', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704030', 'PPSAS', '10704030', 'Hospitals and Health Centers', 'item', '381', '382', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704031', 'PPSAS', '10704031', 'Accumulated Depreciation - Hospitals and Health Centers', 'item', '383', '384', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704032', 'PPSAS', '10704032', 'Accumulated Impairment Losses - Hospitals and Health Centers', 'item', '385', '386', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704040', 'PPSAS', '10704040', 'Markets', 'item', '387', '388', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704041', 'PPSAS', '10704041', 'Accumulated Depreciation - Markets', 'item', '389', '390', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704042', 'PPSAS', '10704042', 'Accumulated Impairment Losses - Markets', 'item', '391', '392', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704050', 'PPSAS', '10704050', 'Slaughterhouses', 'item', '393', '394', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704051', 'PPSAS', '10704051', 'Accumulated Depreciation - Slaughterhouses', 'item', '395', '396', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704052', 'PPSAS', '10704052', 'Accumulated Impairment Losses- Slaughterhouses', 'item', '397', '398', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704060', 'PPSAS', '10704060', 'Hostels and Dormitories', 'item', '399', '400', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704061', 'PPSAS', '10704061', 'Accumulated Depreciation - Hostels and Dormitories', 'item', '401', '402', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704062', 'PPSAS', '10704062', 'Accumulated Impairment Losses - Hostels and Dormitories', 'item', '403', '404', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704990', 'PPSAS', '10704990', 'Other Structures', 'item', '405', '406', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704991', 'PPSAS', '10704991', 'Accumulated Depreciation - Other Structures', 'item', '407', '408', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10704992', 'PPSAS', '10704992', 'Accumulated Impairment Losses - Other Structures', 'item', '409', '410', '4', 'PPSAS-10704');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705010', 'PPSAS', '10705010', 'Machinery', 'item', '413', '414', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705011', 'PPSAS', '10705011', 'Accumulated Depreciation - Machinery', 'item', '415', '416', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705012', 'PPSAS', '10705012', 'Accumulated Impairment Losses - Machinery', 'item', '417', '418', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705020', 'PPSAS', '10705020', 'Office Equipment', 'item', '419', '420', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705021', 'PPSAS', '10705021', 'Accumulated Depreciation - Office Equipment', 'item', '421', '422', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705022', 'PPSAS', '10705022', 'Accumulated Impairment Losses - Office Equipment', 'item', '423', '424', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705030', 'PPSAS', '10705030', 'Information and Communication Technology  Equipment', 'item', '425', '426', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705031', 'PPSAS', '10705031', 'Accumulated Depreciation - Information and Communication Technology  Equipment', 'item', '427', '428', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705032', 'PPSAS', '10705032', 'Accumulated Impairment Losses - Information and Communication Technology  Equipment', 'item', '429', '430', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705040', 'PPSAS', '10705040', 'Agricultural and  Forestry Equipment', 'item', '431', '432', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705041', 'PPSAS', '10705041', 'Accumulated Depreciation - Agricultural  and Forestry Equipment', 'item', '433', '434', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705042', 'PPSAS', '10705042', 'Accumulated Impairment Losses - Agricultural  and Forestry Equipment', 'item', '435', '436', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705050', 'PPSAS', '10705050', 'Marine and Fishery Equipment', 'item', '437', '438', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705051', 'PPSAS', '10705051', 'Accumulated Depreciation - Marine and Fishery Equipment', 'item', '439', '440', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705052', 'PPSAS', '10705052', 'Accumulated Impairment Losses - Marine and Fishery Equipment', 'item', '441', '442', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705060', 'PPSAS', '10705060', 'Airport Equipment', 'item', '443', '444', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705061', 'PPSAS', '10705061', 'Accumulated Depreciation - Airport Equipment', 'item', '445', '446', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705062', 'PPSAS', '10705062', 'Accumulated Impairment Losses - Airport Equipment', 'item', '447', '448', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705070', 'PPSAS', '10705070', 'Communication Equipment', 'item', '449', '450', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705071', 'PPSAS', '10705071', 'Accumulated Depreciation - Communication Equipment', 'item', '451', '452', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705072', 'PPSAS', '10705072', 'Accumulated Impairment Losses - Communication Equipment', 'item', '453', '454', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705080', 'PPSAS', '10705080', 'Construction and Heavy Equipment', 'item', '455', '456', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705081', 'PPSAS', '10705081', 'Accumulated Depreciation - Construction and Heavy Equipment', 'item', '457', '458', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705082', 'PPSAS', '10705082', 'Accumulated Impairment Losses - Construction and Heavy Equipment', 'item', '459', '460', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705090', 'PPSAS', '10705090', 'Disaster Response and Rescue Equipment', 'item', '461', '462', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705091', 'PPSAS', '10705091', 'Accumulated Depreciation - Disaster Response and Rescue Equipment', 'item', '463', '464', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705092', 'PPSAS', '10705092', 'Accumulated Impairment Losses - Disaster Response and Rescue Equipment', 'item', '465', '466', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705100', 'PPSAS', '10705100', 'Military, Police and Security Equipment', 'item', '467', '468', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705101', 'PPSAS', '10705101', 'Accumulated Depreciation - Military, Police and Security Equipment', 'item', '469', '470', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705102', 'PPSAS', '10705102', 'Accumulated Impairment Losses - Military, Police and Security Equipment', 'item', '471', '472', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705110', 'PPSAS', '10705110', 'Medical Equipment', 'item', '473', '474', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705111', 'PPSAS', '10705111', 'Accumulated Depreciation - Medical Equipment', 'item', '475', '476', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705112', 'PPSAS', '10705112', 'Accumulated Impairment Losses - Medical Equipment', 'item', '477', '478', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705120', 'PPSAS', '10705120', 'Printing Equipment', 'item', '479', '480', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705121', 'PPSAS', '10705121', 'Accumulated Depreciation - Printing Equipment', 'item', '481', '482', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705122', 'PPSAS', '10705122', 'Accumulated Impairment Losses - Printing Equipment', 'item', '483', '484', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705130', 'PPSAS', '10705130', 'Sports Equipment', 'item', '485', '486', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705131', 'PPSAS', '10705131', 'Accumulated Depreciation - Sports Equipment', 'item', '487', '488', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705132', 'PPSAS', '10705132', 'Accumulated Impairment Losses - Sports Equipment', 'item', '489', '490', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705140', 'PPSAS', '10705140', 'Technical and Scientific  Equipment', 'item', '491', '492', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705141', 'PPSAS', '10705141', 'Accumulated Depreciation - Technical and Scientific  Equipment', 'item', '493', '494', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705142', 'PPSAS', '10705142', 'Accumulated Impairment Losses - Technical and Scientific  Equipment', 'item', '495', '496', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705990', 'PPSAS', '10705990', 'Other Machinery and Equipment', 'item', '497', '498', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705991', 'PPSAS', '10705991', 'Accumulated Depreciation - Other Machinery and Equipment', 'item', '499', '500', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10705992', 'PPSAS', '10705992', 'Accumulated Impairment Losses - Other Machinery and Equipment', 'item', '501', '502', '4', 'PPSAS-10705');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706010', 'PPSAS', '10706010', 'Motor Vehicles', 'item', '505', '506', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706011', 'PPSAS', '10706011', 'Accumulated Depreciation - Motor Vehicles', 'item', '507', '508', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706012', 'PPSAS', '10706012', 'Accumulated Impairment Losses - Motor Vehicles', 'item', '509', '510', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706020', 'PPSAS', '10706020', 'Trains', 'item', '511', '512', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706021', 'PPSAS', '10706021', 'Accumulated Depreciation - Trains', 'item', '513', '514', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706022', 'PPSAS', '10706022', 'Accumulated Impairment Losses - Trains', 'item', '515', '516', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706030', 'PPSAS', '10706030', 'Aircrafts and Aircrafts Ground Equipment', 'item', '517', '518', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706031', 'PPSAS', '10706031', 'Accumulated Depreciation - Aircrafts and Aircrafts Ground Equipment', 'item', '519', '520', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706032', 'PPSAS', '10706032', 'Accumulated Impairment Losses - Aircrafts and Aircrafts Ground Equipment', 'item', '521', '522', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706040', 'PPSAS', '10706040', 'Watercrafts', 'item', '523', '524', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706042', 'PPSAS', '10706042', 'Accumulated Impairment Losses - Watercrafts', 'item', '525', '526', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706990', 'PPSAS', '10706990', 'Other Transportation Equipment', 'item', '527', '528', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706991', 'PPSAS', '10706991', 'Accumulated Depreciation - Other Transportation Equipment', 'item', '529', '530', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10706992', 'PPSAS', '10706992', 'Accumulated Impairment Losses - Other Transportation Equipment', 'item', '531', '532', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-41107060', 'PPSAS', '41107060', 'Accumulated Depreciation - Watercrafts', 'item', '533', '534', '4', 'PPSAS-10706');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707010', 'PPSAS', '10707010', 'Furniture and Fixtures', 'item', '537', '538', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707011', 'PPSAS', '10707011', 'Accumulated Depreciation - Furniture and Fixtures', 'item', '539', '540', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707012', 'PPSAS', '10707012', 'Accumulated Impairment Losses - Furniture and Fixtures', 'item', '541', '542', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707020', 'PPSAS', '10707020', 'Books', 'item', '543', '544', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707021', 'PPSAS', '10707021', 'Accumulated Depreciation - Books', 'item', '545', '546', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10707022', 'PPSAS', '10707022', 'Accumulated Impairment Losses - Books', 'item', '547', '548', '4', 'PPSAS-10707');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708010', 'PPSAS', '10708010', 'Leased Assets, Land', 'item', '551', '552', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708011', 'PPSAS', '10708011', 'Accumulated Impairment Losses-Leased Assets, Land', 'item', '553', '554', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708020', 'PPSAS', '10708020', 'Leased Assets,  Buildings and Other Structures', 'item', '555', '556', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708021', 'PPSAS', '10708021', 'Accumulated Depreciation - Leased Assets,  Buildings and Other Structures', 'item', '557', '558', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708022', 'PPSAS', '10708022', 'Accumulated Impairment Losses - Leased Assets, Buildings and Other Structures', 'item', '559', '560', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708030', 'PPSAS', '10708030', 'Leased Assets,  Machinery and Equipment', 'item', '561', '562', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708031', 'PPSAS', '10708031', 'Accumulated Depreciation - Leased Assets, Machinery and Equipment', 'item', '563', '564', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708032', 'PPSAS', '10708032', 'Accumulated Impairment Losses - Leased Assets,  Machinery and Equipment', 'item', '565', '566', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708040', 'PPSAS', '10708040', 'Leased Assets, Transportation Equipment', 'item', '567', '568', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708041', 'PPSAS', '10708041', 'Accumulated Depreciation - Leased Assets, Transportation Equipment', 'item', '569', '570', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708042', 'PPSAS', '10708042', 'Accumulated Impairment Losses - Leased Assets,  Transportation Equipment', 'item', '571', '572', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708990', 'PPSAS', '10708990', 'Other Leased Assets', 'item', '573', '574', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708991', 'PPSAS', '10708991', 'Accumulated Depreciation - Other Leased Assets', 'item', '575', '576', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10708992', 'PPSAS', '10708992', 'Accumulated Impairment Losses - Other Leased Assets', 'item', '577', '578', '4', 'PPSAS-10708');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709010', 'PPSAS', '10709010', 'Leased Assets Improvements, Land', 'item', '581', '582', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709011', 'PPSAS', '10709011', 'Accumulated Depreciation - Leased Assets Improvements, Land', 'item', '583', '584', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709012', 'PPSAS', '10709012', 'Accumulated Impairment Losses - Leased Assets Improvements, Land', 'item', '585', '586', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709020', 'PPSAS', '10709020', 'Leased Assets Improvements, Buildings', 'item', '587', '588', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709021', 'PPSAS', '10709021', 'Accumulated Depreciation - Leased Assets Improvements, Buildings', 'item', '589', '590', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709022', 'PPSAS', '10709022', 'Accumulated Impairment Losses - Leased Assets Improvements, Buildings', 'item', '591', '592', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709990', 'PPSAS', '10709990', 'Other Leased Assets Improvements', 'item', '593', '594', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709991', 'PPSAS', '10709991', 'Accumulated Depreciation - Other Leased Assets Improvements', 'item', '595', '596', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10709992', 'PPSAS', '10709992', 'Accumulated Impairment Losses - Other Leased Assets Improvements', 'item', '597', '598', '4', 'PPSAS-10709');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710010', 'PPSAS', '10710010', 'Construction in Progress - Land Improvements', 'item', '601', '602', '4', 'PPSAS-10710');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710020', 'PPSAS', '10710020', 'Construction in Progress - Infrastructure Assets', 'item', '603', '604', '4', 'PPSAS-10710');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710030', 'PPSAS', '10710030', 'Construction in Progress - Buildings and Other Structures', 'item', '605', '606', '4', 'PPSAS-10710');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710040', 'PPSAS', '10710040', 'Construction in Progress - Leased Assets', 'item', '607', '608', '4', 'PPSAS-10710');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10710050', 'PPSAS', '10710050', 'Construction in Progress - Leased Assets Improvements', 'item', '609', '610', '4', 'PPSAS-10710');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10711010', 'PPSAS', '10711010', 'Service Concession Assets', 'item', '613', '614', '4', 'PPSAS-10711');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10711011', 'PPSAS', '10711011', 'Accumulated Depreciation - Service Concession Assets', 'item', '615', '616', '4', 'PPSAS-10711');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10711012', 'PPSAS', '10711012', 'Accumulated Impairment Losses - Service Concession Assets', 'item', '617', '618', '4', 'PPSAS-10711');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799010', 'PPSAS', '10799010', 'Work/Zoo Animals', 'item', '621', '622', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799011', 'PPSAS', '10799011', 'Accumulated Depreciation - Work/Zoo Animals', 'item', '623', '624', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799012', 'PPSAS', '10799012', 'Accumulated Impairment Losses - Work/Zoo Animals', 'item', '625', '626', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799990', 'PPSAS', '10799990', 'Other Property, Plant and Equipment', 'item', '627', '628', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799991', 'PPSAS', '10799991', 'Accumulated Depreciation - Other Property, Plant and Equipment', 'item', '629', '630', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10799992', 'PPSAS', '10799992', 'Accumulated Impairment Losses - Other Property, Plant and Equipment', 'item', '631', '632', '4', 'PPSAS-10799');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10801', 'PPSAS', '10801', 'Bearer Biological Assets', 'group', '636', '645', '3', 'PPSAS-108');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10801010', 'PPSAS', '10801010', 'Breeding Stocks', 'item', '637', '638', '4', 'PPSAS-10801');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10801020', 'PPSAS', '10801020', 'Plants and Trees', 'item', '639', '640', '4', 'PPSAS-10801');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10801030', 'PPSAS', '10801030', 'Aquaculture', 'item', '641', '642', '4', 'PPSAS-10801');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10801990', 'PPSAS', '10801990', 'Other Bearer Biological Assets', 'item', '643', '644', '4', 'PPSAS-10801');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901', 'PPSAS', '10901', 'Intangible Assets', 'group', '648', '667', '3', 'PPSAS-109');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10902', 'PPSAS', '10902', 'Service Concession Assets - Intangible Assets', 'group', '668', '671', '3', 'PPSAS-109');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901010', 'PPSAS', '10901010', 'Patents/Copyrights', 'item', '649', '650', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901011', 'PPSAS', '10901011', 'Accumulated Amortization - Patents/Copyrights', 'item', '651', '652', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901012', 'PPSAS', '10901012', 'Accumulated Impairment - Patents/Copyrights', 'item', '653', '654', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901020', 'PPSAS', '10901020', 'Computer Software', 'item', '655', '656', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901021', 'PPSAS', '10901021', 'Accumulated Amortization - Computer Software', 'item', '657', '658', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901022', 'PPSAS', '10901022', 'Accumulated Impairment - Computer Software', 'item', '659', '660', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901990', 'PPSAS', '10901990', 'Other Intangible Assets', 'item', '661', '662', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901991', 'PPSAS', '10901991', 'Accumulated Amortization - Other Intangible Assets', 'item', '663', '664', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10901992', 'PPSAS', '10901992', 'Accumulated Impairment - Other Intangible Assets', 'item', '665', '666', '4', 'PPSAS-10901');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-10902010', 'PPSAS', '10902010', 'Service Concession Assets - Intangible Assets', 'item', '669', '670', '4', 'PPSAS-10902');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-201', 'PPSAS', '201', 'Financial Liabilities', 'group', '675', '712', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-202', 'PPSAS', '202', 'Inter-Agency Payables', 'group', '713', '732', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-203', 'PPSAS', '203', 'Intra-Agency Payables', 'group', '733', '742', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-204', 'PPSAS', '204', 'Trust Liabilities', 'group', '743', '756', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-205', 'PPSAS', '205', 'Deferred Credits/Unearned Income', 'group', '757', '772', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-206', 'PPSAS', '206', 'Provisions', 'group', '773', '780', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-299', 'PPSAS', '299', 'Other Payables', 'group', '781', '786', '2', 'PPSAS-2');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101', 'PPSAS', '20101', 'Payables', 'group', '676', '699', '3', 'PPSAS-201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102', 'PPSAS', '20102', 'Bills/Bonds/Loans Payable', 'group', '700', '711', '3', 'PPSAS-201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101010', 'PPSAS', '20101010', 'Accounts Payable', 'item', '677', '678', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101020', 'PPSAS', '20101020', 'Due to Officers and Employees', 'item', '679', '680', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101040', 'PPSAS', '20101040', 'Notes Payable', 'item', '681', '682', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101050', 'PPSAS', '20101050', 'Interest Payable', 'item', '683', '684', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101060', 'PPSAS', '20101060', 'Operating Lease Payable', 'item', '685', '686', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101070', 'PPSAS', '20101070', 'Finance Lease Payable', 'item', '687', '688', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101080', 'PPSAS', '20101080', 'Awards and Rewards Payable', 'item', '689', '690', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101090', 'PPSAS', '20101090', 'Service Concession Arrangement Payable', 'item', '691', '692', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101100', 'PPSAS', '20101100', 'Pension Benefits Payable', 'item', '693', '694', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101110', 'PPSAS', '20101110', 'Leave Benefits Payable', 'item', '695', '696', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20101120', 'PPSAS', '20101120', 'Retirement Gratuity Payable', 'item', '697', '698', '4', 'PPSAS-20101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102020', 'PPSAS', '20102020', 'Bonds Payable - Domestic', 'item', '701', '702', '4', 'PPSAS-20102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102021', 'PPSAS', '20102021', 'Discount on Bonds Payable - Domestic', 'item', '703', '704', '4', 'PPSAS-20102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102022', 'PPSAS', '20102022', 'Premium on Bonds Payable - Domestic', 'item', '705', '706', '4', 'PPSAS-20102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102040', 'PPSAS', '20102040', 'Loans Payable - Domestic', 'item', '707', '708', '4', 'PPSAS-20102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20102050', 'PPSAS', '20102050', 'Loans Payable - Foreign', 'item', '709', '710', '4', 'PPSAS-20102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201', 'PPSAS', '20201', 'Inter-Agency Payables', 'group', '714', '731', '3', 'PPSAS-202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201010', 'PPSAS', '20201010', 'Due to BIR', 'item', '715', '716', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201020', 'PPSAS', '20201020', 'Due to GSIS', 'item', '717', '718', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201030', 'PPSAS', '20201030', 'Due to Pag-IBIG', 'item', '719', '720', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201040', 'PPSAS', '20201040', 'Due to PhilHealth', 'item', '721', '722', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201050', 'PPSAS', '20201050', 'Due to NGAs', 'item', '723', '724', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201060', 'PPSAS', '20201060', 'Due to GOCCs', 'item', '725', '726', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201070', 'PPSAS', '20201070', 'Due to LGUs', 'item', '727', '728', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20201080', 'PPSAS', '20201080', 'Due to Joint Venture', 'item', '729', '730', '4', 'PPSAS-20201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20301', 'PPSAS', '20301', 'Intra-Agency Payables', 'group', '734', '741', '3', 'PPSAS-203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20301010', 'PPSAS', '20301010', 'Due to Other Funds', 'item', '735', '736', '4', 'PPSAS-20301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20301020', 'PPSAS', '20301020', 'Due to Special Accounts', 'item', '737', '738', '4', 'PPSAS-20301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20301030', 'PPSAS', '20301030', 'Due to Local Economic Enterprises', 'item', '739', '740', '4', 'PPSAS-20301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401', 'PPSAS', '20401', 'Trust Liabilities', 'group', '744', '755', '3', 'PPSAS-204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401010', 'PPSAS', '20401010', 'Trust Liabilities', 'item', '745', '746', '4', 'PPSAS-20401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401020', 'PPSAS', '20401020', 'Trust Liabilities - Disaster Risk Reduction and Management Fund', 'item', '747', '748', '4', 'PPSAS-20401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401030', 'PPSAS', '20401030', 'Bail Bonds Payable', 'item', '749', '750', '4', 'PPSAS-20401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401040', 'PPSAS', '20401040', 'Guaranty/Security Deposits Payable', 'item', '751', '752', '4', 'PPSAS-20401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20401050', 'PPSAS', '20401050', 'Customers'' Deposits Payable', 'item', '753', '754', '4', 'PPSAS-20401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501', 'PPSAS', '20501', 'Deferred Credits', 'group', '758', '771', '3', 'PPSAS-205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501010', 'PPSAS', '20501010', 'Deferred Real Property Tax', 'item', '759', '760', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501020', 'PPSAS', '20501020', 'Deferred Special Education Tax', 'item', '761', '762', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501030', 'PPSAS', '20501030', 'Deferred Finance Lease Revenue', 'item', '763', '764', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501040', 'PPSAS', '20501040', 'Deferred Service Concession Revenue', 'item', '765', '766', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20501050', 'PPSAS', '20501050', 'Unearned Revenue - Investment Property', 'item', '767', '768', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-205010990', 'PPSAS', '205010990', 'Other Deferred Credits', 'item', '769', '770', '4', 'PPSAS-20501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20601', 'PPSAS', '20601', 'Provisions', 'group', '774', '779', '3', 'PPSAS-206');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20601040', 'PPSAS', '20601040', 'Termination Benefits', 'item', '775', '776', '4', 'PPSAS-20601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-20601990', 'PPSAS', '20601990', 'Other Provisions', 'item', '777', '778', '4', 'PPSAS-20601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-29999', 'PPSAS', '29999', 'Other Payables', 'group', '782', '785', '3', 'PPSAS-299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-29999990', 'PPSAS', '29999990', 'Other Payables', 'item', '783', '784', '4', 'PPSAS-29999');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-301', 'PPSAS', '301', 'Government Equity', 'group', '789', '796', '2', 'PPSAS-3');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-302', 'PPSAS', '302', 'Intermediate Accounts', 'group', '797', '802', '2', 'PPSAS-3');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-303', 'PPSAS', '303', 'Equity in Joint Venture', 'group', '803', '808', '2', 'PPSAS-3');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-304', 'PPSAS', '304', 'Unrealized Gain/(Loss)', 'group', '809', '814', '2', 'PPSAS-3');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30101', 'PPSAS', '30101', 'Government Equity', 'group', '790', '795', '3', 'PPSAS-301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30101010', 'PPSAS', '30101010', 'Government Equity', 'item', '791', '792', '4', 'PPSAS-30101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30101020', 'PPSAS', '30101020', 'Prior Period Adjustment', 'item', '793', '794', '4', 'PPSAS-30101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30201', 'PPSAS', '30201', 'Intermediate Accounts', 'group', '798', '801', '3', 'PPSAS-302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30201010', 'PPSAS', '30201010', 'Income and Expense Summary', 'item', '799', '800', '4', 'PPSAS-30201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30301', 'PPSAS', '30301', 'Equity in Joint Venture', 'group', '804', '807', '3', 'PPSAS-303');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30301010', 'PPSAS', '30301010', 'Equity in Joint Venture', 'item', '805', '806', '4', 'PPSAS-30301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30401', 'PPSAS', '30401', 'Unrealized Gain/(Loss)', 'group', '810', '813', '3', 'PPSAS-304');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-30401010', 'PPSAS', '30401010', 'Unrealized Gain/(Loss) from Changes in the Fair Value of Financial Assets', 'item', '811', '812', '4', 'PPSAS-30401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-401', 'PPSAS', '401', 'Tax Revenue', 'group', '817', '880', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-402', 'PPSAS', '402', 'Service and Business Income', 'group', '881', '968', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-403', 'PPSAS', '403', 'Transfers, Assistance and Subsidy', 'group', '969', '990', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-404', 'PPSAS', '404', 'Shares, Grants and Donations', 'group', '991', '1006', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-405', 'PPSAS', '405', 'Gains', 'group', '1007', '1036', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-406', 'PPSAS', '406', 'Miscellaneous Income', 'group', '1037', '1042', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-407', 'PPSAS', '407', 'Other Non-Operating Income', 'group', '1043', '1048', '2', 'PPSAS-4');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40101', 'PPSAS', '40101', 'Tax Revenue - Individual and Corporation', 'group', '818', '823', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102', 'PPSAS', '40102', 'Tax Revenue - Property', 'group', '824', '839', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103', 'PPSAS', '40103', 'Tax Revenue - Goods and Services', 'group', '840', '853', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40104', 'PPSAS', '40104', 'Tax Revenue - Others', 'group', '854', '857', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40105', 'PPSAS', '40105', 'Tax Revenue - Fines and Penalties', 'group', '858', '867', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106', 'PPSAS', '40106', 'Share from National Taxes', 'group', '868', '879', '3', 'PPSAS-401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40101020', 'PPSAS', '40101020', 'Professional Tax', 'item', '819', '820', '4', 'PPSAS-40101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40101050', 'PPSAS', '40101050', 'Community Tax', 'item', '821', '822', '4', 'PPSAS-40101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102040', 'PPSAS', '40102040', 'Real Property Tax- Basic', 'item', '825', '826', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102041', 'PPSAS', '40102041', 'Discount on Real Property Tax- Basic', 'item', '827', '828', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102050', 'PPSAS', '40102050', 'Special Education Tax', 'item', '829', '830', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102051', 'PPSAS', '40102051', 'Discount on Special Education Tax', 'item', '831', '832', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102060', 'PPSAS', '40102060', 'Special Levy on Idle Lands', 'item', '833', '834', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102070', 'PPSAS', '40102070', 'Special Levy on Lands Benefited by Public Works Projects', 'item', '835', '836', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40102080', 'PPSAS', '40102080', 'Real Property Transfer Tax', 'item', '837', '838', '4', 'PPSAS-40102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103030', 'PPSAS', '40103030', 'Business Tax', 'item', '841', '842', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103040', 'PPSAS', '40103040', 'Tax on Sand, Gravel and Other Quarry Products', 'item', '843', '844', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103050', 'PPSAS', '40103050', 'Tax on Delivery  Trucks and Vans', 'item', '845', '846', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103060', 'PPSAS', '40103060', 'Amusement Tax', 'item', '847', '848', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103070', 'PPSAS', '40103070', 'Franchise Tax', 'item', '849', '850', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40103080', 'PPSAS', '40103080', 'Printing and Publication Tax', 'item', '851', '852', '4', 'PPSAS-40103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40104990', 'PPSAS', '40104990', 'Other Taxes', 'item', '855', '856', '4', 'PPSAS-40104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40105010', 'PPSAS', '40105010', 'Tax Revenue - Fines and Penalties - Taxes on Individual and Corporation', 'item', '859', '860', '4', 'PPSAS-40105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40105020', 'PPSAS', '40105020', 'Tax Revenue - Fines and Penalties - Property Taxes', 'item', '861', '862', '4', 'PPSAS-40105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40105030', 'PPSAS', '40105030', 'Tax Revenue - Fines and Penalties - Taxes on Goods and Services', 'item', '863', '864', '4', 'PPSAS-40105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40105040', 'PPSAS', '40105040', 'Tax Revenue - Fines and Penalties - Other Taxes', 'item', '865', '866', '4', 'PPSAS-40105');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106010', 'PPSAS', '40106010', 'Share from Internal Revenue Collections (IRA)', 'item', '869', '870', '4', 'PPSAS-40106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106020', 'PPSAS', '40106020', 'Share from Expanded Value Added Tax', 'item', '871', '872', '4', 'PPSAS-40106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106030', 'PPSAS', '40106030', 'Share from National Wealth', 'item', '873', '874', '4', 'PPSAS-40106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106040', 'PPSAS', '40106040', 'Share from Tobacco Excise Tax (RA 7171 and 8240)', 'item', '875', '876', '4', 'PPSAS-40106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40106050', 'PPSAS', '40106050', 'Share from Economic Zones', 'item', '877', '878', '4', 'PPSAS-40106');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201', 'PPSAS', '40201', 'Service Income', 'group', '882', '909', '3', 'PPSAS-402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202', 'PPSAS', '40202', 'Business Income', 'group', '910', '967', '3', 'PPSAS-402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201010', 'PPSAS', '40201010', 'Permit Fees', 'item', '883', '884', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201020', 'PPSAS', '40201020', 'Registration Fees', 'item', '885', '886', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201030', 'PPSAS', '40201030', 'Registration Plates, Tags and Stickers Fees', 'item', '887', '888', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201040', 'PPSAS', '40201040', 'Clearance and Certification Fees', 'item', '889', '890', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201070', 'PPSAS', '40201070', 'Supervision and Regulation Enforcement Fees', 'item', '891', '892', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201100', 'PPSAS', '40201100', 'Inspection Fees', 'item', '893', '894', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201110', 'PPSAS', '40201110', 'Verification and Authentication Fees', 'item', '895', '896', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201130', 'PPSAS', '40201130', 'Processing Fees', 'item', '897', '898', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201140', 'PPSAS', '40201140', 'Occupation Fees', 'item', '899', '900', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201150', 'PPSAS', '40201150', 'Fishery Rentals, Fees and Charges', 'item', '901', '902', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201160', 'PPSAS', '40201160', 'Fees for Sealing  and Licensing of Weights and Measures', 'item', '903', '904', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201980', 'PPSAS', '40201980', 'Fines and Penalties - Service Income', 'item', '905', '906', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40201990', 'PPSAS', '40201990', 'Other Service Income', 'item', '907', '908', '4', 'PPSAS-40201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202010', 'PPSAS', '40202010', 'School Fees', 'item', '911', '912', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202020', 'PPSAS', '40202020', 'Affiliation Fees', 'item', '913', '914', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202040', 'PPSAS', '40202040', 'Seminar/Training Fees', 'item', '915', '916', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202050', 'PPSAS', '40202050', 'Rent Income', 'item', '917', '918', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202060', 'PPSAS', '40202060', 'Communication Network Fees', 'item', '919', '920', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202070', 'PPSAS', '40202070', 'Transportation System Fees', 'item', '921', '922', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202080', 'PPSAS', '40202080', 'Road Network  Fees', 'item', '923', '924', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202090', 'PPSAS', '40202090', 'Waterworks System Fees', 'item', '925', '926', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202100', 'PPSAS', '40202100', 'Power Supply System Fees', 'item', '927', '928', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202110', 'PPSAS', '40202110', 'Seaport  System Fees', 'item', '929', '930', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202120', 'PPSAS', '40202120', 'Parking Fees', 'item', '931', '932', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202130', 'PPSAS', '40202130', 'Receipts  from Operation of Hostels/Dormitories and Other Like Facilities', 'item', '933', '934', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202140', 'PPSAS', '40202140', 'Receipts from Market Operations', 'item', '935', '936', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202150', 'PPSAS', '40202150', 'Receipts from Slaughterhouse Operation', 'item', '937', '938', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202160', 'PPSAS', '40202160', 'Receipts from Cemetery Operations', 'item', '939', '940', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202170', 'PPSAS', '40202170', 'Receipts from Printing and Publication', 'item', '941', '942', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202180', 'PPSAS', '40202180', 'Sales Revenue', 'item', '943', '944', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202181', 'PPSAS', '40202181', 'Sales Discounts', 'item', '945', '946', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202190', 'PPSAS', '40202190', 'Garbage Fees', 'item', '947', '948', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202200', 'PPSAS', '40202200', 'Hospital Fees', 'item', '949', '950', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202210', 'PPSAS', '40202210', 'Dividend Income', 'item', '951', '952', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202220', 'PPSAS', '40202220', 'Interest Income', 'item', '953', '954', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202230', 'PPSAS', '40202230', 'Service Concession Revenue', 'item', '955', '956', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202240', 'PPSAS', '40202240', 'Other Service Concession Revenue', 'item', '957', '958', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202250', 'PPSAS', '40202250', 'Lease Revenue', 'item', '959', '960', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202260', 'PPSAS', '40202260', 'Share in the Profit of Joint Venture', 'item', '961', '962', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202980', 'PPSAS', '40202980', 'Fines and Penalties - Business Income', 'item', '963', '964', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40202990', 'PPSAS', '40202990', 'Other Business Income', 'item', '965', '966', '4', 'PPSAS-40202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301', 'PPSAS', '40301', 'Transfers, Assistance and Subsidy', 'group', '970', '983', '3', 'PPSAS-403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40302', 'PPSAS', '40302', 'Transfers', 'group', '984', '989', '3', 'PPSAS-403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301010', 'PPSAS', '40301010', 'Subsidy from National Government', 'item', '971', '972', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301020', 'PPSAS', '40301020', 'Subsidy  from Local Government Units', 'item', '973', '974', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301030', 'PPSAS', '40301030', 'Subsidy from Government-Owned and/or Controlled Corporations', 'item', '975', '976', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301040', 'PPSAS', '40301040', 'Subsidy from Other Funds', 'item', '977', '978', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301050', 'PPSAS', '40301050', 'Subsidy from General Fund Proper/Other Special Accounts', 'item', '979', '980', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40301060', 'PPSAS', '40301060', 'Subsidy from Other Local Economic Enterprise', 'item', '981', '982', '4', 'PPSAS-40301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40302010', 'PPSAS', '40302010', 'Transfers from General Fund of LGU Counterpart/Equity Share', 'item', '985', '986', '4', 'PPSAS-40302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40302020', 'PPSAS', '40302020', 'Transfers from General Fund of Unspent DRRMF', 'item', '987', '988', '4', 'PPSAS-40302');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40401', 'PPSAS', '40401', 'Share', 'group', '992', '997', '3', 'PPSAS-404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40402', 'PPSAS', '40402', 'Grants and Donations', 'group', '998', '1005', '3', 'PPSAS-404');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-404010', 'PPSAS', '404010', 'Share from PAGCOR', 'item', '993', '994', '4', 'PPSAS-40401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40401020', 'PPSAS', '40401020', 'Share from PCSO', 'item', '995', '996', '4', 'PPSAS-40401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40402010', 'PPSAS', '40402010', 'Grants and Donations in Cash', 'item', '999', '1000', '4', 'PPSAS-40402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40402020', 'PPSAS', '40402020', 'Grants and Donations in Kind', 'item', '1001', '1002', '4', 'PPSAS-40402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40402030', 'PPSAS', '40402030', 'Grants from Concessionary loans', 'item', '1003', '1004', '4', 'PPSAS-40402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501', 'PPSAS', '40501', 'Grains', 'group', '1008', '1035', '3', 'PPSAS-405');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501010', 'PPSAS', '40501010', 'Gain from Changes in Fair Value of Financial Instruments', 'item', '1009', '1010', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501020', 'PPSAS', '40501020', 'Gain on Foreign Exchange (FOREX)', 'item', '1011', '1012', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501030', 'PPSAS', '40501030', 'Gain on Sale of Investments', 'item', '1013', '1014', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501040', 'PPSAS', '40501040', 'Gain on Sale of Investment Property', 'item', '1015', '1016', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501050', 'PPSAS', '40501050', 'Gain on Sale of Property, Plant and Equipment', 'item', '1017', '1018', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501060', 'PPSAS', '40501060', 'Gain on Initial Recognition of Biological Assets', 'item', '1019', '1020', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501070', 'PPSAS', '40501070', 'Gain on Sale of Biological Assets', 'item', '1021', '1022', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501080', 'PPSAS', '40501080', 'Gain from Changes in Fair Value  Less Cost to Sell of Biological Assets Due to Physical Change', 'item', '1023', '1024', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501090', 'PPSAS', '40501090', 'Gain from Changes in Fair Value  Less Cost to Sell of Biological Assets Due to Price Change', 'item', '1025', '1026', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501100', 'PPSAS', '40501100', 'Gain from Initial Recognition of Agricultural Produce', 'item', '1027', '1028', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501110', 'PPSAS', '40501110', 'Gain on Sale of Intangible Assets', 'item', '1029', '1030', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501120', 'PPSAS', '40501120', 'Reversal of Impairment Losses', 'item', '1031', '1032', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40501990', 'PPSAS', '40501990', 'Other Gains', 'item', '1033', '1034', '4', 'PPSAS-40501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40601', 'PPSAS', '40601', 'Miscellaneous Income', 'group', '1038', '1041', '3', 'PPSAS-406');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40601010', 'PPSAS', '40601010', 'Miscellaneous Income', 'item', '1039', '1040', '4', 'PPSAS-40601');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40701', 'PPSAS', '40701', 'Sale of Assets', 'group', '1044', '1047', '3', 'PPSAS-407');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-40701010', 'PPSAS', '40701010', 'Sale of Garnished/Confiscated/Abandoned/Seized Goods and Properties', 'item', '1045', '1046', '4', 'PPSAS-40701');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-501', 'PPSAS', '501', 'Personnel Services', 'group', '1051', '1114', '2', 'PPSAS-5');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-502', 'PPSAS', '502', 'Maintenance and Other Operating Expenses', 'group', '1115', '1294', '2', 'PPSAS-5');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-503', 'PPSAS', '503', 'Financial Expenses', 'group', '1295', '1310', '2', 'PPSAS-5');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-504', 'PPSAS', '504', 'Direct Costs', 'group', '1311', '1324', '2', 'PPSAS-5');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-505', 'PPSAS', '505', 'Non-Cash Expenses', 'group', '1325', '1404', '2', 'PPSAS-5');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50101', 'PPSAS', '50101', 'Salaries and Wages', 'group', '1052', '1057', '3', 'PPSAS-501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102', 'PPSAS', '50102', 'Other Compensation', 'group', '1058', '1091', '3', 'PPSAS-501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103', 'PPSAS', '50103', 'Personnel Benefit Contributions', 'group', '1092', '1103', '3', 'PPSAS-501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50104', 'PPSAS', '50104', 'Other Personnel Benefits', 'group', '1104', '1113', '3', 'PPSAS-501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50101010', 'PPSAS', '50101010', 'Salaries and Wages - Regular', 'item', '1053', '1054', '4', 'PPSAS-50101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50101020', 'PPSAS', '50101020', 'Salaries and Wages - Casual/Contractual', 'item', '1055', '1056', '4', 'PPSAS-50101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102010', 'PPSAS', '50102010', 'Personal Economic Relief Allowance (PERA)', 'item', '1059', '1060', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102020', 'PPSAS', '50102020', 'Representation Allowance (RA)', 'item', '1061', '1062', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102030', 'PPSAS', '50102030', 'Transportation Allowance (TA)', 'item', '1063', '1064', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102040', 'PPSAS', '50102040', 'Clothing/Uniform Allowance', 'item', '1065', '1066', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102050', 'PPSAS', '50102050', 'Subsistence Allowance', 'item', '1067', '1068', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102060', 'PPSAS', '50102060', 'Laundry  Allowance', 'item', '1069', '1070', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102070', 'PPSAS', '50102070', 'Quarters Allowance', 'item', '1071', '1072', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102080', 'PPSAS', '50102080', 'Productivity Incentive Allowance', 'item', '1073', '1074', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102090', 'PPSAS', '50102090', 'Overseas Allowance', 'item', '1075', '1076', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102100', 'PPSAS', '50102100', 'Honoraria', 'item', '1077', '1078', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102110', 'PPSAS', '50102110', 'Hazard Pay', 'item', '1079', '1080', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102120', 'PPSAS', '50102120', 'Longevity Pay', 'item', '1081', '1082', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102130', 'PPSAS', '50102130', 'Overtime and Night Pay', 'item', '1083', '1084', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102140', 'PPSAS', '50102140', 'Year End Bonus', 'item', '1085', '1086', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102150', 'PPSAS', '50102150', 'Cash Gift', 'item', '1087', '1088', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50102990', 'PPSAS', '50102990', 'Other Bonuses and Allowances', 'item', '1089', '1090', '4', 'PPSAS-50102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103010', 'PPSAS', '50103010', 'Retirement and Life Insurance Premiums', 'item', '1093', '1094', '4', 'PPSAS-50103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103020', 'PPSAS', '50103020', 'Pag-IBIG Contributions', 'item', '1095', '1096', '4', 'PPSAS-50103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103030', 'PPSAS', '50103030', 'PhilHealth Contributions', 'item', '1097', '1098', '4', 'PPSAS-50103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103040', 'PPSAS', '50103040', 'Employees Compensation Insurance Premiums', 'item', '1099', '1100', '4', 'PPSAS-50103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50103050', 'PPSAS', '50103050', 'Provident/Welfare Fund Contributions', 'item', '1101', '1102', '4', 'PPSAS-50103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50104010', 'PPSAS', '50104010', 'Pension Benefits', 'item', '1105', '1106', '4', 'PPSAS-50104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50104020', 'PPSAS', '50104020', 'Retirement Gratuity', 'item', '1107', '1108', '4', 'PPSAS-50104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50104030', 'PPSAS', '50104030', 'Terminal Leave Benefits', 'item', '1109', '1110', '4', 'PPSAS-50104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50104990', 'PPSAS', '50104990', 'Other Personnel Benefits', 'item', '1111', '1112', '4', 'PPSAS-50104');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50201', 'PPSAS', '50201', 'Traveling Expenses', 'group', '1116', '1121', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50202', 'PPSAS', '50202', 'Training and Scholarship Expenses', 'group', '1122', '1127', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203', 'PPSAS', '50203', 'Supplies and Materials Expenses', 'group', '1128', '1157', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50204', 'PPSAS', '50204', 'Utility Expenses', 'group', '1158', '1163', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50205', 'PPSAS', '50205', 'Communication Expenses', 'group', '1164', '1173', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50206', 'PPSAS', '50206', 'Awards/Rewards and Prizes', 'group', '1174', '1179', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50207', 'PPSAS', '50207', 'Survey, Research, Exploration and Development Expenses', 'group', '1180', '1185', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50208', 'PPSAS', '50208', 'Demolition/Relocation and Desilting/Dredging Expenses', 'group', '1186', '1191', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50209', 'PPSAS', '50209', 'Generation, Transmission and Distribution Expenses', 'group', '1192', '1195', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50210', 'PPSAS', '50210', 'Confidential, Intelligence and Extraordinary Expenses', 'group', '1196', '1203', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50211', 'PPSAS', '50211', 'Professional Services', 'group', '1204', '1213', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50212', 'PPSAS', '50212', 'General Services', 'group', '1214', '1223', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213', 'PPSAS', '50213', 'Repairs and Maintenance', 'group', '1224', '1245', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214', 'PPSAS', '50214', 'Financial Assistance/Subsidy', 'group', '1246', '1259', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50215', 'PPSAS', '50215', 'Transfers', 'group', '1260', '1265', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50216', 'PPSAS', '50216', 'Taxes, Insurance Premiums and Other Fees', 'group', '1266', '1273', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299', 'PPSAS', '50299', 'Other Maintenance and Operating Expenses', 'group', '1274', '1293', '3', 'PPSAS-502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50201010', 'PPSAS', '50201010', 'Traveling Expenses - Local', 'item', '1117', '1118', '4', 'PPSAS-50201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50201020', 'PPSAS', '50201020', 'Traveling Expenses - Foreign', 'item', '1119', '1120', '4', 'PPSAS-50201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50202010', 'PPSAS', '50202010', 'Training Expenses', 'item', '1123', '1124', '4', 'PPSAS-50202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50202020', 'PPSAS', '50202020', 'Scholarship Grants/Expenses', 'item', '1125', '1126', '4', 'PPSAS-50202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203010', 'PPSAS', '50203010', 'Office Supplies Expenses', 'item', '1129', '1130', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203020', 'PPSAS', '50203020', 'Accountable Forms Expenses', 'item', '1131', '1132', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203030', 'PPSAS', '50203030', 'Non-Accountable Forms Expenses', 'item', '1133', '1134', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203040', 'PPSAS', '50203040', 'Animal/Zoological Supplies Expenses', 'item', '1135', '1136', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203050', 'PPSAS', '50203050', 'Food Supplies Expenses', 'item', '1137', '1138', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203060', 'PPSAS', '50203060', 'Welfare Goods Expenses', 'item', '1139', '1140', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203070', 'PPSAS', '50203070', 'Drugs and Medicines Expenses', 'item', '1141', '1142', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203080', 'PPSAS', '50203080', 'Medical, Dental and Laboratory Supplies Expenses', 'item', '1143', '1144', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203090', 'PPSAS', '50203090', 'Fuel, Oil and Lubricants Expenses', 'item', '1145', '1146', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203100', 'PPSAS', '50203100', 'Agricultural and Marine Supplies Expenses', 'item', '1147', '1148', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203110', 'PPSAS', '50203110', 'Textbooks and Instructional Materials Expenses', 'item', '1149', '1150', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203120', 'PPSAS', '50203120', 'Military, Police and Traffic Supplies Expenses', 'item', '1151', '1152', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203130', 'PPSAS', '50203130', 'Chemical and Filtering Supplies Expenses', 'item', '1153', '1154', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50203990', 'PPSAS', '50203990', 'Other Supplies and Materials Expenses', 'item', '1155', '1156', '4', 'PPSAS-50203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50204010', 'PPSAS', '50204010', 'Water Expenses', 'item', '1159', '1160', '4', 'PPSAS-50204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50204020', 'PPSAS', '50204020', 'Electricity Expenses', 'item', '1161', '1162', '4', 'PPSAS-50204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50205010', 'PPSAS', '50205010', 'Postage and Courier Services', 'item', '1165', '1166', '4', 'PPSAS-50205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50205020', 'PPSAS', '50205020', 'Telephone Expenses', 'item', '1167', '1168', '4', 'PPSAS-50205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50205030', 'PPSAS', '50205030', 'Internet Subscription Expenses', 'item', '1169', '1170', '4', 'PPSAS-50205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50205040', 'PPSAS', '50205040', 'Cable, Satellite, Telegraph and Radio Expenses', 'item', '1171', '1172', '4', 'PPSAS-50205');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50206010', 'PPSAS', '50206010', 'Awards/Rewards Expenses', 'item', '1175', '1176', '4', 'PPSAS-50206');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50206020', 'PPSAS', '50206020', 'Prizes', 'item', '1177', '1178', '4', 'PPSAS-50206');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50207010', 'PPSAS', '50207010', 'Survey Expenses', 'item', '1181', '1182', '4', 'PPSAS-50207');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50207020', 'PPSAS', '50207020', 'Research, Exploration and Development Expenses', 'item', '1183', '1184', '4', 'PPSAS-50207');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50208010', 'PPSAS', '50208010', 'Demolition and Relocation Expenses', 'item', '1187', '1188', '4', 'PPSAS-50208');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50208020', 'PPSAS', '50208020', 'Desilting and Dredging Expenses', 'item', '1189', '1190', '4', 'PPSAS-50208');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50209010', 'PPSAS', '50209010', 'Generation, Transmission and Distribution Expenses', 'item', '1193', '1194', '4', 'PPSAS-50209');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50210010', 'PPSAS', '50210010', 'Confidential Expenses', 'item', '1197', '1198', '4', 'PPSAS-50210');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50210020', 'PPSAS', '50210020', 'Intelligence Expenses', 'item', '1199', '1200', '4', 'PPSAS-50210');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50210030', 'PPSAS', '50210030', 'Extraordinary and Miscellaneous Expenses', 'item', '1201', '1202', '4', 'PPSAS-50210');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50211010', 'PPSAS', '50211010', 'Legal Services', 'item', '1205', '1206', '4', 'PPSAS-50211');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50211020', 'PPSAS', '50211020', 'Auditing Services', 'item', '1207', '1208', '4', 'PPSAS-50211');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50211030', 'PPSAS', '50211030', 'Consultancy Services', 'item', '1209', '1210', '4', 'PPSAS-50211');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50211990', 'PPSAS', '50211990', 'Other Professional Services', 'item', '1211', '1212', '4', 'PPSAS-50211');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50212010', 'PPSAS', '50212010', 'Environment/Sanitary Services', 'item', '1215', '1216', '4', 'PPSAS-50212');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50212020', 'PPSAS', '50212020', 'Janitorial Services', 'item', '1217', '1218', '4', 'PPSAS-50212');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50212030', 'PPSAS', '50212030', 'Security Services', 'item', '1219', '1220', '4', 'PPSAS-50212');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50212990', 'PPSAS', '50212990', 'Other General Services', 'item', '1221', '1222', '4', 'PPSAS-50212');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213010', 'PPSAS', '50213010', 'Repairs and Maintenance - Investment Property', 'item', '1225', '1226', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213020', 'PPSAS', '50213020', 'Repairs and Maintenance - Land Improvements', 'item', '1227', '1228', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213030', 'PPSAS', '50213030', 'Repairs and Maintenance - Infrastructure Assets', 'item', '1229', '1230', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213040', 'PPSAS', '50213040', 'Repairs and Maintenance - Buildings and Other Structures', 'item', '1231', '1232', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213050', 'PPSAS', '50213050', 'Repairs and Maintenance - Machinery and Equipment', 'item', '1233', '1234', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213060', 'PPSAS', '50213060', 'Repairs and Maintenance - Transportation Equipment', 'item', '1235', '1236', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213070', 'PPSAS', '50213070', 'Repairs and Maintenance - Furniture and  Fixtures', 'item', '1237', '1238', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213080', 'PPSAS', '50213080', 'Repairs and Maintenance - Leased Assets', 'item', '1239', '1240', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213090', 'PPSAS', '50213090', 'Repairs and Maintenance - Leased Assets Improvements', 'item', '1241', '1242', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50213990', 'PPSAS', '50213990', 'Repairs and Maintenance - Other Property, Plant and Equipment', 'item', '1243', '1244', '4', 'PPSAS-50213');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214020', 'PPSAS', '50214020', 'Subsidy to NGAs', 'item', '1247', '1248', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214030', 'PPSAS', '50214030', 'Subsidy to Other Local Government Units', 'item', '1249', '1250', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214060', 'PPSAS', '50214060', 'Subsidy to Other  Funds', 'item', '1251', '1252', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214070', 'PPSAS', '50214070', 'Subsidy to General Fund Proper/Special Accounts', 'item', '1253', '1254', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214080', 'PPSAS', '50214080', 'Subsidy to Local Economic Enterprises', 'item', '1255', '1256', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50214990', 'PPSAS', '50214990', 'Subsidies - Others', 'item', '1257', '1258', '4', 'PPSAS-50214');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50215010', 'PPSAS', '50215010', 'Transfers of Unspent Current Year DRRM Funds to the Trust Funds', 'item', '1261', '1262', '4', 'PPSAS-50215');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50215020', 'PPSAS', '50215020', 'Transfers for Project Equity Share /LGU Counterpart', 'item', '1263', '1264', '4', 'PPSAS-50215');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50216010', 'PPSAS', '50216010', 'Taxes, Duties and Licenses', 'item', '1267', '1268', '4', 'PPSAS-50216');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50216020', 'PPSAS', '50216020', 'Fidelity Bond Premiums', 'item', '1269', '1270', '4', 'PPSAS-50216');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50216030', 'PPSAS', '50216030', 'Insurance Expenses', 'item', '1271', '1272', '4', 'PPSAS-50216');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299010', 'PPSAS', '50299010', 'Advertising Expenses', 'item', '1275', '1276', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299020', 'PPSAS', '50299020', 'Printing and Publication Expenses', 'item', '1277', '1278', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299030', 'PPSAS', '50299030', 'Representation Expenses', 'item', '1279', '1280', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299040', 'PPSAS', '50299040', 'Transportation and Delivery Expenses', 'item', '1281', '1282', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299050', 'PPSAS', '50299050', 'Rent Expenses', 'item', '1283', '1284', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299060', 'PPSAS', '50299060', 'Membership Dues and Contributions to Organizations', 'item', '1285', '1286', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299070', 'PPSAS', '50299070', 'Subscription Expenses', 'item', '1287', '1288', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50299080', 'PPSAS', '50299080', 'Donations', 'item', '1289', '1290', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-502990990', 'PPSAS', '502990990', 'Other Maintenance and Operating Expenses', 'item', '1291', '1292', '4', 'PPSAS-50299');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301', 'PPSAS', '50301', 'Financial Expenses', 'group', '1296', '1309', '3', 'PPSAS-503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301010', 'PPSAS', '50301010', 'Management Supervision/Trusteeship Fees', 'item', '1297', '1298', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301020', 'PPSAS', '50301020', 'Interest Expenses', 'item', '1299', '1300', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301030', 'PPSAS', '50301030', 'Guarantee Fees', 'item', '1301', '1302', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301040', 'PPSAS', '50301040', 'Bank Charges', 'item', '1303', '1304', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301050', 'PPSAS', '50301050', 'Commitment Fees', 'item', '1305', '1306', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50301990', 'PPSAS', '50301990', 'Other Financial Charges', 'item', '1307', '1308', '4', 'PPSAS-50301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50401', 'PPSAS', '50401', 'Cost of Goods Manufactured', 'group', '1312', '1319', '3', 'PPSAS-504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50402', 'PPSAS', '50402', 'Cost of Sales', 'group', '1320', '1323', '3', 'PPSAS-504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50401010', 'PPSAS', '50401010', 'Direct Materials', 'item', '1313', '1314', '4', 'PPSAS-50401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50401020', 'PPSAS', '50401020', 'Direct Labor', 'item', '1315', '1316', '4', 'PPSAS-50401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50401030', 'PPSAS', '50401030', 'Manufacturing Overhead', 'item', '1317', '1318', '4', 'PPSAS-50401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50402010', 'PPSAS', '50402010', 'Cost of Sales', 'item', '1321', '1322', '4', 'PPSAS-50402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501', 'PPSAS', '50501', 'Depreciation', 'group', '1326', '1349', '3', 'PPSAS-505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50502', 'PPSAS', '50502', 'Amortization', 'group', '1350', '1353', '3', 'PPSAS-505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503', 'PPSAS', '50503', 'Impairment Loss', 'group', '1354', '1375', '3', 'PPSAS-505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504', 'PPSAS', '50504', 'Losses', 'group', '1376', '1399', '3', 'PPSAS-505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50505', 'PPSAS', '50505', 'Grants', 'group', '1400', '1403', '3', 'PPSAS-505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501010', 'PPSAS', '50501010', 'Depreciation - Investment Property', 'item', '1327', '1328', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501020', 'PPSAS', '50501020', 'Depreciation - Land Improvements', 'item', '1329', '1330', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501030', 'PPSAS', '50501030', 'Depreciation - Infrastructure Assets', 'item', '1331', '1332', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501040', 'PPSAS', '50501040', 'Depreciation - Buildings and Other Structures', 'item', '1333', '1334', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501050', 'PPSAS', '50501050', 'Depreciation - Machinery  and Equipment', 'item', '1335', '1336', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501060', 'PPSAS', '50501060', 'Depreciation - Transportation Equipment', 'item', '1337', '1338', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501070', 'PPSAS', '50501070', 'Depreciation - Furniture, Fixtures and Books', 'item', '1339', '1340', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501080', 'PPSAS', '50501080', 'Depreciation - Leased Assets', 'item', '1341', '1342', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501090', 'PPSAS', '50501090', 'Depreciation - Leased Assets Improvements', 'item', '1343', '1344', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501100', 'PPSAS', '50501100', 'Depreciation -Service Concession Assets', 'item', '1345', '1346', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50501990', 'PPSAS', '50501990', 'Depreciation - Other Property, Plant and Equipment', 'item', '1347', '1348', '4', 'PPSAS-50501');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50502010', 'PPSAS', '50502010', 'Amortization - Intangible Assets', 'item', '1351', '1352', '4', 'PPSAS-50502');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503010', 'PPSAS', '50503010', 'Impairment Loss - Financial Assets Held to Maturity', 'item', '1355', '1356', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503020', 'PPSAS', '50503020', 'Impairment Loss - Loans and  Receivables', 'item', '1357', '1358', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503030', 'PPSAS', '50503030', 'Impairment Loss - Lease Receivables', 'item', '1359', '1360', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503040', 'PPSAS', '50503040', 'Impairment Loss - Investments in GOCCs', 'item', '1361', '1362', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503050', 'PPSAS', '50503050', 'Impairment Loss - Investments in Joint Venture', 'item', '1363', '1364', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503060', 'PPSAS', '50503060', 'Impairment Loss - Other Receivables', 'item', '1365', '1366', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503070', 'PPSAS', '50503070', 'Impairment Loss - Inventories', 'item', '1367', '1368', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503080', 'PPSAS', '50503080', 'Impairment Loss - Investment Property', 'item', '1369', '1370', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503090', 'PPSAS', '50503090', 'Impairment Loss - Property, Plant and Equipment', 'item', '1371', '1372', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50503100', 'PPSAS', '50503100', 'Impairment Loss - Intangible Assets', 'item', '1373', '1374', '4', 'PPSAS-50503');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504010', 'PPSAS', '50504010', 'Loss on Foreign Exchange (FOREX)', 'item', '1377', '1378', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504020', 'PPSAS', '50504020', 'Loss on Sale of Investments', 'item', '1379', '1380', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504030', 'PPSAS', '50504030', 'Loss on Sale of Investment Property', 'item', '1381', '1382', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504040', 'PPSAS', '50504040', 'Loss on Sale of Propery, Plant and Equipment', 'item', '1383', '1384', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504050', 'PPSAS', '50504050', 'Loss on Sale of Biological Assets', 'item', '1385', '1386', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504060', 'PPSAS', '50504060', 'Loss on Sale of Intangible Assets', 'item', '1387', '1388', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504070', 'PPSAS', '50504070', 'Loss on Sale of Assets', 'item', '1389', '1390', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504080', 'PPSAS', '50504080', 'Loss on Initial Recognition of Biological Assets', 'item', '1391', '1392', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504090', 'PPSAS', '50504090', 'Loss of Assets', 'item', '1393', '1394', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504100', 'PPSAS', '50504100', 'Loss on Guaranty', 'item', '1395', '1396', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50504990', 'PPSAS', '50504990', 'Other Losses', 'item', '1397', '1398', '4', 'PPSAS-50504');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('PPSAS-50505010', 'PPSAS', '50505010', 'Grants for Concessionary loans', 'item', '1401', '1402', '4', 'PPSAS-50505');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1', 'SRE', '1', 'RECEIPTS', 'root', '0', '285', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-2', 'SRE', '2', 'EXPENDITURES', 'root', '286', '287', '1', NULL);
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101', 'SRE', '101', 'LOCAL SOURCES', 'group', '1', '204', '2', 'SRE-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102', 'SRE', '102', 'EXTERNAL SOURCES', 'group', '205', '266', '2', 'SRE-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-103', 'SRE', '103', 'TRUST FUND RECEIPTS', 'group', '267', '284', '2', 'SRE-1');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101', 'SRE', '10101', 'TAX REVENUE', 'group', '2', '81', '3', 'SRE-101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102', 'SRE', '10102', 'NON-TAX REVENUES', 'group', '82', '203', '3', 'SRE-101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010101', 'SRE', '1010101', 'REAL PROPERTY TAX', 'group', '3', '32', '4', 'SRE-10101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010102', 'SRE', '1010102', 'TAX ON BUSINESS', 'group', '33', '66', '4', 'SRE-10101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010103', 'SRE', '1010103', 'OTHER TAXES', 'group', '67', '80', '4', 'SRE-10101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010101', 'SRE', '101010101', 'Real Property Tax -Basic', 'group', '4', '13', '5', 'SRE-1010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010102', 'SRE', '101010102', 'Special Levy on Idle Lands', 'group', '14', '23', '5', 'SRE-1010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010103', 'SRE', '101010103', 'Special Levy on Land Benefited by Public Works Projects', 'group', '24', '31', '5', 'SRE-1010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010101', 'SRE', '10101010101', 'Current Year', 'item', '5', '6', '6', 'SRE-101010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010102', 'SRE', '10101010102', 'Fines and Penalties-Current Year', 'item', '7', '8', '6', 'SRE-101010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010103', 'SRE', '10101010103', 'Prior Year/s', 'item', '9', '10', '6', 'SRE-101010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010104', 'SRE', '10101010104', 'Fines and Penalties-Prior Year/s', 'item', '11', '12', '6', 'SRE-101010101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010201', 'SRE', '10101010201', 'Current Year', 'item', '15', '16', '6', 'SRE-101010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010202', 'SRE', '10101010202', 'Fines and Penalties-Current Year', 'item', '17', '18', '6', 'SRE-101010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010203', 'SRE', '10101010203', 'Prior Year/s', 'item', '19', '20', '6', 'SRE-101010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010204', 'SRE', '10101010204', 'Fines and Penalties-Prior Year/s', 'item', '21', '22', '6', 'SRE-101010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010301', 'SRE', '10101010301', 'Current Year', 'item', '25', '26', '6', 'SRE-101010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010302', 'SRE', '10101010302', 'Fines and Penalties-Current Year', 'item', '27', '28', '6', 'SRE-101010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101010303', 'SRE', '10101010303', 'Prior Year/s', 'item', '29', '30', '6', 'SRE-101010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010201', 'SRE', '101010201', 'Amusement Tax', 'item', '34', '35', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010202', 'SRE', '101010202', 'Business Tax', 'group', '36', '57', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010203', 'SRE', '101010203', 'Franchise Tax', 'item', '58', '59', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010204', 'SRE', '101010204', 'Tax on Delivery Trucks and Vans', 'item', '60', '61', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010205', 'SRE', '101010205', 'Tax on Sand, Gravel & Other Quarry Resources', 'item', '62', '63', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010206', 'SRE', '101010206', 'Fines and Penalties-Business Taxes', 'item', '64', '65', '5', 'SRE-1010102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020201', 'SRE', '10101020201', 'Manufacturers, Assemblers, etc.', 'item', '37', '38', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020202', 'SRE', '10101020202', 'Wholesalers, Distributors, etc.', 'item', '39', '40', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020203', 'SRE', '10101020203', 'Exporters, Manufacturers, Dealers, etc.', 'item', '41', '42', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020204', 'SRE', '10101020204', 'Retailers', 'item', '43', '44', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020205', 'SRE', '10101020205', 'Contractors and other Independent contractors', 'item', '45', '46', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020206', 'SRE', '10101020206', 'Banks & Other Financial Institutions', 'item', '47', '48', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020207', 'SRE', '10101020207', 'Peddlers', 'item', '49', '50', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020208', 'SRE', '10101020208', 'Printing & Publication Tax', 'item', '51', '52', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020209', 'SRE', '10101020209', 'Tax on Amusement Places', 'item', '53', '54', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10101020210', 'SRE', '10101020210', 'Other Business Taxes', 'item', '55', '56', '6', 'SRE-101010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010301', 'SRE', '101010301', 'Community Tax-Corporation', 'item', '68', '69', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010302', 'SRE', '101010302', 'Community Tax-Individual', 'item', '70', '71', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010303', 'SRE', '101010303', 'Professional Tax', 'item', '72', '73', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010304', 'SRE', '101010304', 'Real Property Transfer Tax', 'item', '74', '75', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010305', 'SRE', '101010305', 'Other Taxes', 'item', '76', '77', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101010306', 'SRE', '101010306', 'Fines and Penalties-Other Taxes', 'item', '78', '79', '5', 'SRE-1010103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010201', 'SRE', '1010201', 'REGULATORY FEES (Permits and Licenses)', 'group', '83', '114', '4', 'SRE-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010202', 'SRE', '1010202', 'SERVICE/USER CHARGES (Service Income)', 'group', '115', '150', '4', 'SRE-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010203', 'SRE', '1010203', 'RECEIPTS FROM ECONOMIC ENTERPRISES (Business Income)', 'group', '151', '188', '4', 'SRE-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1010204', 'SRE', '1010204', 'OTHER INCOME/RECEIPTS (Other General Income)', 'group', '189', '202', '4', 'SRE-10102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020101', 'SRE', '101020101', 'Permits and Licenses', 'group', '84', '103', '5', 'SRE-1010201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020102', 'SRE', '101020102', 'Registration Fees', 'group', '104', '109', '5', 'SRE-1010201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020103', 'SRE', '101020103', 'Inspection Fees', 'item', '110', '111', '5', 'SRE-1010201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020104', 'SRE', '101020104', 'Fines and Penalties-Permits and Licenses', 'item', '112', '113', '5', 'SRE-1010201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010101', 'SRE', '10102010101', 'Fees on Weights and Measures', 'item', '85', '86', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010102', 'SRE', '10102010102', 'Fishery Rental Fees and Privilege Fees', 'item', '87', '88', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010103', 'SRE', '10102010103', 'Franchising and Licensing Fees', 'item', '89', '90', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010104', 'SRE', '10102010104', 'Business Permit Fees', 'item', '91', '92', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010105', 'SRE', '10102010105', 'Building Permit Fees', 'item', '93', '94', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010106', 'SRE', '10102010106', 'Zonal/Location Permit Fees', 'item', '95', '96', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010107', 'SRE', '10102010107', 'Tricycle Operators Permit Fees', 'item', '97', '98', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010108', 'SRE', '10102010108', 'Occupational Fees', 'item', '99', '100', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010109', 'SRE', '10102010109', 'Other Permits & Licenses', 'item', '101', '102', '6', 'SRE-101020101');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010201', 'SRE', '10102010201', 'Cattle/Animal Registration Fees', 'item', '105', '106', '6', 'SRE-101020102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102010202', 'SRE', '10102010202', 'Civil Registration Fees', 'item', '107', '108', '6', 'SRE-101020102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020201', 'SRE', '101020201', 'Clearance and Certification Fees', 'group', '116', '125', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020202', 'SRE', '101020202', 'Other Fees', 'group', '126', '135', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020203', 'SRE', '101020203', 'Fines and Penalties-Service Income', 'item', '136', '137', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020204', 'SRE', '101020204', 'Landing and Aeronautical Fees', 'item', '138', '139', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020205', 'SRE', '101020205', 'Parking and Terminal Fees', 'item', '140', '141', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020206', 'SRE', '101020206', 'Hospital Fees', 'item', '142', '143', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020207', 'SRE', '101020207', 'Medical, Dental and Laboratory Fees', 'item', '144', '145', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020208', 'SRE', '101020208', 'Market & Slaughterhouse Fees', 'item', '146', '147', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020209', 'SRE', '101020209', 'Printing and Publication Fees', 'item', '148', '149', '5', 'SRE-1010202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020101', 'SRE', '10102020101', 'Police Clearance', 'item', '117', '118', '6', 'SRE-101020201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020102', 'SRE', '10102020102', 'Secretary''s Fees', 'item', '119', '120', '6', 'SRE-101020201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020103', 'SRE', '10102020103', 'Health Certificate', 'item', '121', '122', '6', 'SRE-101020201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020104', 'SRE', '10102020104', 'Other Clearance and Certification', 'item', '123', '124', '6', 'SRE-101020201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020201', 'SRE', '10102020201', 'Garbage Fees', 'item', '127', '128', '6', 'SRE-101020202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020202', 'SRE', '10102020202', 'Wharfage Fees', 'item', '129', '130', '6', 'SRE-101020202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020203', 'SRE', '10102020203', 'Toll Fees', 'item', '131', '132', '6', 'SRE-101020202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102020204', 'SRE', '10102020204', 'Other Service Income', 'item', '133', '134', '6', 'SRE-101020202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020301', 'SRE', '101020301', 'Receipts from Economic Enterprises (Business Income)', 'group', '152', '187', '5', 'SRE-1010203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030101', 'SRE', '10102030101', 'School Operations', 'item', '153', '154', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030102', 'SRE', '10102030102', 'Power Generation/Distribution', 'item', '155', '156', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030103', 'SRE', '10102030103', 'Hospital Operations', 'item', '157', '158', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030104', 'SRE', '10102030104', 'Canteen/Restaurant Operations', 'item', '159', '160', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030105', 'SRE', '10102030105', 'Cemetery Operations', 'item', '161', '162', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030106', 'SRE', '10102030106', 'Communication Facilities & Equipment Operations', 'item', '163', '164', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030107', 'SRE', '10102030107', 'Dormitory Operations', 'item', '165', '166', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030108', 'SRE', '10102030108', 'Market Operations', 'item', '167', '168', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030109', 'SRE', '10102030109', 'Slaughterhouse Operations', 'item', '169', '170', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030110', 'SRE', '10102030110', 'Transportation System Operations', 'item', '171', '172', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030111', 'SRE', '10102030111', 'Waterworks System Operations', 'item', '173', '174', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030112', 'SRE', '10102030112', 'Printing & Publication Operations', 'item', '175', '176', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030113', 'SRE', '10102030113', 'Lease/Rental of Facilities', 'item', '177', '178', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030114', 'SRE', '10102030114', 'Trading Business', 'item', '179', '180', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030115', 'SRE', '10102030115', 'Other Economic Enterprises', 'item', '181', '182', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030116', 'SRE', '10102030116', 'Fines and Penalties-Economic Enterprises', 'item', '183', '184', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102030117', 'SRE', '10102030117', 'Prepaid Income (Prepaid Rent)', 'item', '185', '186', '6', 'SRE-101020301');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020401', 'SRE', '101020401', 'Interest Income', 'item', '190', '191', '5', 'SRE-1010204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020402', 'SRE', '101020402', 'Dividend Income', 'item', '192', '193', '5', 'SRE-1010204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-101020403', 'SRE', '101020403', 'Other General Income (Miscellaneous)', 'group', '194', '201', '5', 'SRE-1010204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102040301', 'SRE', '10102040301', 'Rebates on MMDA Contribution', 'item', '195', '196', '6', 'SRE-101020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102040302', 'SRE', '10102040302', 'Sales of Confiscated/Abandoned/Seized Goods & Properties', 'item', '197', '198', '6', 'SRE-101020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10102040303', 'SRE', '10102040303', 'Miscellaneous - Others', 'item', '199', '200', '6', 'SRE-101020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10201', 'SRE', '10201', 'INTERNAL REVENUE ALLOTMENT', 'group', '206', '211', '3', 'SRE-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10202', 'SRE', '10202', 'OTHER SHARES FROM NATIONAL TAX COLLECTIONS', 'group', '212', '235', '3', 'SRE-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10203', 'SRE', '10203', 'INTER-LOCAL TRANSFERS', 'group', '236', '241', '3', 'SRE-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10204', 'SRE', '10204', 'EXTRAORDINARY RECEIPTS/GRANTS/DONATIONS/AIDS', 'group', '242', '265', '3', 'SRE-102');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020101', 'SRE', '1020101', 'Current Year', 'item', '207', '208', '4', 'SRE-10201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020102', 'SRE', '1020102', 'Prior Year', 'item', '209', '210', '4', 'SRE-10201');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020201', 'SRE', '1020201', 'Share from Economic Zone (RA 7227)', 'item', '213', '214', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020202', 'SRE', '1020202', 'Share from EVAT', 'item', '215', '216', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020203', 'SRE', '1020203', 'Share from National Wealth', 'group', '217', '228', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020204', 'SRE', '1020204', 'Share from PAGCOR/PCSO/Lotto', 'item', '229', '230', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020205', 'SRE', '1020205', 'Share from Tobacco Excise Tax (RA 7171)', 'item', '231', '232', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020206', 'SRE', '1020206', 'Others', 'item', '233', '234', '4', 'SRE-10202');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102020301', 'SRE', '102020301', 'Mining Taxes', 'item', '218', '219', '5', 'SRE-1020203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102020302', 'SRE', '102020302', 'Utilization of hydrothermal, geothermal and other sources of energy', 'item', '220', '221', '5', 'SRE-1020203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102020303', 'SRE', '102020303', 'Forestry Charges', 'item', '222', '223', '5', 'SRE-1020203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102020304', 'SRE', '102020304', 'Mineral Reservations', 'item', '224', '225', '5', 'SRE-1020203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102020305', 'SRE', '102020305', 'Others', 'item', '226', '227', '5', 'SRE-1020203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020301', 'SRE', '1020301', 'Subsidy from LGUs', 'item', '237', '238', '4', 'SRE-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020302', 'SRE', '1020302', 'Subsidy from Other Funds', 'item', '239', '240', '4', 'SRE-10203');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020401', 'SRE', '1020401', 'Grants and Donations', 'group', '243', '248', '4', 'SRE-10204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020402', 'SRE', '1020402', 'Subsidy Income', 'group', '249', '254', '4', 'SRE-10204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-1020403', 'SRE', '1020403', 'Extraordinary Gains and Premiums', 'group', '255', '264', '4', 'SRE-10204');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040101', 'SRE', '102040101', 'Domestic', 'item', '244', '245', '5', 'SRE-1020401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040102', 'SRE', '102040102', 'Foreign', 'item', '246', '247', '5', 'SRE-1020401');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040201', 'SRE', '102040201', 'Other Subsidy Income', 'item', '250', '251', '5', 'SRE-1020402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040202', 'SRE', '102040202', 'Subsidy from GOCCs', 'item', '252', '253', '5', 'SRE-1020402');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040301', 'SRE', '102040301', 'Gain on FOREX', 'item', '256', '257', '5', 'SRE-1020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040302', 'SRE', '102040302', 'Gain on Sale of Assets', 'item', '258', '259', '5', 'SRE-1020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040303', 'SRE', '102040303', 'Premium on Bonds Payable', 'item', '260', '261', '5', 'SRE-1020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-102040304', 'SRE', '102040304', 'Gain on Sale of Investments', 'item', '262', '263', '5', 'SRE-1020403');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10301', 'SRE', '10301', 'General Public Services', 'item', '268', '269', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10302', 'SRE', '10302', 'Education, Culture & Sports/Manpower Development', 'item', '270', '271', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10303', 'SRE', '10303', 'Health, Nutrition & Population Control', 'item', '272', '273', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10304', 'SRE', '10304', 'Labor and Employment', 'item', '274', '275', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10305', 'SRE', '10305', 'Housing and Community Development', 'item', '276', '277', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10306', 'SRE', '10306', 'Social Services and Social Welfare', 'item', '278', '279', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10307', 'SRE', '10307', 'Economic Services', 'item', '280', '281', '3', 'SRE-103');
INSERT INTO account (objid, maingroupid, code, title, type, leftindex, rightindex, level, groupid) VALUES ('SRE-10308', 'SRE', '10308', 'Debt Service (FE) (Interest Expense & Other Charges)', 'item', '282', '283', '3', 'SRE-103');


alter table account add constraint fk_account_maingroupid 
  foreign key (maingroupid) references account_maingroup (objid) 
go 
alter table account add constraint fk_account_groupid 
  foreign key (groupid) references account (objid) 
go 


alter table account_item_mapping add constraint fk_account_item_mapping_maingroupid 
  foreign key (maingroupid) references account_maingroup (objid) 
go 
alter table account_item_mapping add constraint fk_account_item_mapping_acctid  
  foreign key (acctid) references account (objid) 
go 

drop index ix_itemid on account_item_mapping
go 
alter table account_item_mapping alter column itemid nvarchar(50) not null 
go 
create index ix_itemid on account_item_mapping (itemid) 
go 
alter table account_item_mapping add constraint fk_account_item_mapping_itemid  
  foreign key (itemid) references itemaccount (objid) 
go 
