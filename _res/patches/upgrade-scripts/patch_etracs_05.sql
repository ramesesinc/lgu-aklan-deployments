use etracs255_aklan
go 

CREATE TABLE afrequest (
  objid varchar(50) NOT NULL,
  reqno varchar(20) NULL,
  state varchar(25) NOT NULL,
  dtfiled datetime NULL,
  reqtype varchar(10) NULL,
  itemclass varchar(50) NULL,
  requester_objid varchar(50) NULL,
  requester_name varchar(50) NULL,
  requester_title varchar(50) NULL,
  org_objid varchar(50) NULL,
  org_name varchar(50) NULL,
  vendor varchar(100) NULL,
  respcenter_objid varchar(50) NULL,
  respcenter_name varchar(100) NULL,
  dtapproved datetime NULL,
  approvedby_objid varchar(50) NULL,
  approvedby_name varchar(160) NULL,
  constraint pk_afrequest PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_reqno on afrequest (reqno) 
go 
create index ix_dtfiled on afrequest (dtfiled) 
go
create index ix_org_objid on afrequest (org_objid) 
go
create index ix_requester_name on afrequest (requester_name) 
go
create index ix_requester_objid on afrequest (requester_objid) 
go
create index ix_state on afrequest (state) 
go
create index ix_dtapproved on afrequest (dtapproved) 
go
create index ix_approvedby_objid on afrequest (approvedby_objid) 
go
create index ix_approvedby_name on afrequest (approvedby_name) 
go


CREATE TABLE afrequestitem (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  item_objid varchar(50) NULL,
  item_code varchar(50) NULL,
  item_title varchar(255) NULL,
  unit varchar(10) NULL,
  qty int NULL,
  qtyreceived int NULL,
  constraint pk_afrequestitem PRIMARY KEY (objid) 
)
go 
create index ix_parentid on afrequestitem (parentid) 
go
create index ix_item_objid on afrequestitem (item_objid) 
go
alter table afrequestitem add CONSTRAINT fk_afrequestitem_parentid 
  FOREIGN KEY (parentid) REFERENCES afrequest (objid) 
go 


CREATE TABLE aftxn_type (
  txntype varchar(50) NOT NULL,
  formtype varchar(50) NULL,
  poststate varchar(50) NULL,
  sortorder int NULL,
  constraint pk_aftxn_type PRIMARY KEY (txntype)
)
go 

INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('PURCHASE', 'PURCHASE_RECEIPT', 'OPEN', '0');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('BEGIN', 'BEGIN_BALANCE', 'OPEN', '1');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('FORWARD', 'FORWARD', 'ISSUED', '2');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('COLLECTION', 'ISSUE', 'ISSUED', '3');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('SALE', 'ISSUE', 'SOLD', '4');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('TRANSFER_COLLECTION', 'TRANSFER', 'ISSUED', '5');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('TRANSFER_SALE', 'TRANSFER', 'ISSUED', '6');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('RETURN_COLLECTION', 'RETURN', 'OPEN', '7');
INSERT INTO aftxn_type (txntype, formtype, poststate, sortorder) VALUES ('RETURN_SALE', 'RETURN', 'OPEN', '8');


CREATE TABLE aftxn (
  objid varchar(100) NOT NULL,
  state varchar(50) NULL,
  request_objid varchar(50) NULL,
  request_reqno varchar(50) NULL,
  controlno varchar(50) NULL,
  dtfiled datetime NULL,
  user_objid varchar(50) NULL,
  user_name varchar(100) NULL,
  issueto_objid varchar(50) NULL,
  issueto_name varchar(100) NULL,
  issueto_title varchar(50) NULL,
  org_objid varchar(50) NULL,
  org_name varchar(50) NULL,
  respcenter_objid varchar(50) NULL,
  respcenter_name varchar(100) NULL,
  txndate datetime NOT NULL,
  cost decimal(16,2) NULL,
  txntype varchar(50) NULL,
  particulars varchar(255) NULL,
  issuefrom_objid varchar(50) NULL,
  issuefrom_name varchar(150) NULL,
  issuefrom_title varchar(150) NULL,
  constraint pk_aftxn PRIMARY KEY (objid)
)
go 
create UNIQUE index uix_issueno on aftxn (controlno) 
go 
create index ix_dtfiled on aftxn (dtfiled) 
go 
create index ix_issuefrom_name on aftxn (issuefrom_name) 
go 
create index ix_issuefrom_objid on aftxn (issuefrom_objid) 
go 
create index ix_issueto_objid on aftxn (issueto_objid) 
go 
create index ix_org_objid on aftxn (org_objid) 
go 
create index ix_request_objid on aftxn (request_objid) 
go 
create index ix_request_reqno on aftxn (request_reqno) 
go 
create index ix_user_objid on aftxn (user_objid) 
go 


CREATE TABLE aftxnitem (
  objid varchar(50) NOT NULL,
  parentid varchar(100) NOT NULL,
  item_objid varchar(50) NULL,
  item_code varchar(50) NULL,
  item_title varchar(255) NULL,
  unit varchar(20) NULL,
  qty int NULL,
  qtyserved int NULL,
  remarks varchar(255) NULL,
  txntype varchar(50) NULL,
  cost decimal(16,2) NULL,
  constraint pk_aftxnitem PRIMARY KEY (objid) 
)
go 
create index ix_parentid on aftxnitem (parentid) 
go 
create index ix_item_objid on aftxnitem (item_objid) 
go 
alter table aftxnitem add CONSTRAINT fk_aftxnitem_parentid 
  FOREIGN KEY (parentid) REFERENCES aftxn (objid) 
go 


CREATE TABLE afunit (
  objid varchar(50) NOT NULL,
  itemid varchar(50) NOT NULL,
  unit varchar(10) NOT NULL,
  qty int NULL,
  saleprice decimal(16,2) NOT NULL,
  interval int DEFAULT '1',
  cashreceiptprintout varchar(255) NULL,
  cashreceiptdetailprintout varchar(255) NULL,
  constraint pk_afunit PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_itemid_unit on afunit (itemid,unit) 
go 
create index ix_itemid on afunit (itemid) 
go 

alter table afunit add CONSTRAINT fk_afunit_itemid 
  FOREIGN KEY (itemid) REFERENCES af (objid) 
go 



CREATE TABLE jev (
  objid varchar(150) NOT NULL,
  jevno varchar(50) NULL,
  jevdate date NULL,
  fundid varchar(50) NULL,
  dtposted datetime NULL,
  txntype varchar(50) NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  reftype varchar(50) NULL,
  amount decimal(16,4) NULL,
  state varchar(32) NULL,
  postedby_objid varchar(50) NULL,
  postedby_name varchar(255) NULL,
  verifiedby_objid varchar(50) NULL,
  verifiedby_name varchar(255) NULL,
  dtverified datetime NULL,
  batchid varchar(50) NULL,
  refdate date NULL,
  constraint pk_jev PRIMARY KEY (objid) 
)
go 
create index ix_batchid on jev (batchid) 
go 
create index ix_dtposted on jev (dtposted) 
go 
create index ix_dtverified on jev (dtverified) 
go 
create index ix_fundid on jev (fundid) 
go 
create index ix_jevdate on jev (jevdate) 
go 
create index ix_jevno on jev (jevno) 
go 
create index ix_postedby_objid on jev (postedby_objid) 
go 
create index ix_refdate on jev (refdate) 
go 
create index ix_refid on jev (refid) 
go 
create index ix_refno on jev (refno) 
go 
create index ix_reftype on jev (reftype) 
go 
create index ix_verifiedby_objid on jev (verifiedby_objid) 
go 


CREATE TABLE jevitem (
  objid varchar(150) NOT NULL,
  jevid varchar(150) NULL,
  accttype varchar(50) NULL,
  acctid varchar(50) NULL,
  acctcode varchar(32) NULL,
  acctname varchar(255) NULL,
  dr decimal(16,4) NULL,
  cr decimal(16,4) NULL,
  particulars varchar(255) NULL,
  itemrefid varchar(255) NULL,
  constraint pk_jevitem PRIMARY KEY (objid) 
)
go 
create index ix_jevid on jevitem (jevid) 
go 
create index ix_ledgertype on jevitem (accttype) 
go 
create index ix_acctid on jevitem (acctid) 
go 
create index ix_acctcode on jevitem (acctcode) 
go 
create index ix_acctname on jevitem (acctname) 
go 
create index ix_itemrefid on jevitem (itemrefid) 
go 
alter table jevitem add CONSTRAINT fk_jevitem_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 


CREATE TABLE bankaccount_ledger (
  objid varchar(150) NOT NULL,
  jevid varchar(150) NOT NULL,
  bankacctid varchar(50) NOT NULL,
  itemacctid varchar(50) NOT NULL,
  dr decimal(16,4) NOT NULL,
  cr decimal(16,4) NOT NULL,
  constraint pk_bankaccount_ledger PRIMARY KEY (objid) 
)
go 
create index ix_jevid on bankaccount_ledger (jevid) 
go 
create index ix_bankacctid on bankaccount_ledger (bankacctid) 
go 
create index ix_itemacctid on bankaccount_ledger (itemacctid) 
go 
alter table bankaccount_ledger add CONSTRAINT fk_bankaccount_ledger_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 


CREATE TABLE business_application_task_lock (
  refid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  constraint pk_business_application_task_lock PRIMARY KEY (refid,state) 
)
go 
create index ix_refid on business_application_task_lock (refid) 
go 
alter table business_application_task_lock 
  add CONSTRAINT fk_business_application_task_lock_refid 
  FOREIGN KEY (refid) REFERENCES business_application (objid)
go 


CREATE TABLE business_billitem_txntype (
  objid varchar(50) NOT NULL,
  title varchar(255) NULL,
  category varchar(50) NULL,
  acctid varchar(50) NULL,
  feetype varchar(50) NULL,
  domain varchar(100) NULL,
  role varchar(100) NULL,
  constraint pk_business_billitem_txntype PRIMARY KEY (objid) 
)
go 
create index ix_acctid on business_billitem_txntype (acctid)
go  


CREATE TABLE cashreceipt_reprint_log (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  approvedby_objid varchar(50) NOT NULL,
  approvedby_name varchar(150) NOT NULL,
  dtapproved datetime NOT NULL,
  reason varchar(255) NOT NULL,
  constraint pk_cashreceipt_reprint_log PRIMARY KEY (objid) 
)
go 
create index ix_approvedby_name on cashreceipt_reprint_log (approvedby_name)
go 
create index ix_approvedby_objid on cashreceipt_reprint_log (approvedby_objid)
go 
create index ix_dtapproved on cashreceipt_reprint_log (dtapproved)
go 
create index ix_receiptid on cashreceipt_reprint_log (receiptid)
go 

drop index ix_receiptid on cashreceipt_reprint_log 
go 
alter table cashreceipt_reprint_log 
  alter column receiptid nvarchar(50) not null 
go 
create index ix_receiptid on cashreceipt_reprint_log (receiptid) 
go 
alter table cashreceipt_reprint_log 
  add CONSTRAINT fk_cashreceipt_reprint_log_receiptid 
  FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid) 
go 


CREATE TABLE cashreceipt_share (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  refitem_objid varchar(50) NOT NULL,
  payableitem_objid varchar(50) NOT NULL,
  amount decimal(16,4) NOT NULL,
  share decimal(16,2) NULL,
  constraint pk_cashreceipt_share PRIMARY KEY (objid) 
)
go 
create index ix_receiptid on cashreceipt_share (receiptid) 
go 
create index ix_refitem_objid on cashreceipt_share (refitem_objid) 
go 
create index ix_payableitem_objid on cashreceipt_share (payableitem_objid) 
go 

drop index ix_receiptid on cashreceipt_share 
go 
alter table cashreceipt_share 
  alter column receiptid nvarchar(50) not null 
go 
create index ix_receiptid on cashreceipt_share (receiptid) 
go 
alter table cashreceipt_share 
  add CONSTRAINT fk_cashreceipt_share_receiptid 
  FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid) 
go 


CREATE TABLE cash_treasury_ledger (
  objid varchar(150) NOT NULL,
  jevid varchar(150) NULL,
  itemacctid varchar(50) NULL,
  dr decimal(16,4) NULL,
  cr decimal(16,4) NULL,
  constraint pk_cash_treasury_ledger PRIMARY KEY (objid) 
)
go 
create index ix_jevid on cash_treasury_ledger (jevid) 
go 
create index ix_itemacctid on cash_treasury_ledger (itemacctid) 
go 
alter table cash_treasury_ledger 
  add CONSTRAINT cash_treasury_ledger_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 


CREATE TABLE depositvoucher (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  controlno varchar(100) NOT NULL,
  controldate date NOT NULL,
  dtcreated datetime NOT NULL,
  createdby_objid varchar(50) NOT NULL,
  createdby_name varchar(255) NOT NULL,
  amount decimal(16,4) NOT NULL,
  dtposted datetime NULL,
  postedby_objid varchar(50) NULL,
  postedby_name varchar(255) NULL,
  constraint pk_depositvoucher PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_controlno on depositvoucher (controlno) 
go 
create index ix_state on depositvoucher (state) 
go 
create index ix_controldate on depositvoucher (controldate) 
go 
create index ix_createdby_objid on depositvoucher (createdby_objid) 
go 
create index ix_createdby_name on depositvoucher (createdby_name) 
go 
create index ix_dtcreated on depositvoucher (dtcreated) 
go 
create index ix_postedby_objid on depositvoucher (postedby_objid) 
go 
create index ix_postedby_name on depositvoucher (postedby_name) 
go 
create index ix_dtposted on depositvoucher (dtposted) 
go 


CREATE TABLE depositvoucher_fund (
  objid varchar(150) NOT NULL,
  state varchar(20) NOT NULL,
  parentid varchar(50) NOT NULL,
  fundid varchar(100) NOT NULL,
  amount decimal(16,4) NOT NULL,
  amountdeposited decimal(16,4) NOT NULL,
  totaldr decimal(16,4) NOT NULL,
  totalcr decimal(16,4) NOT NULL,
  dtposted datetime NULL,
  postedby_objid varchar(50) NULL,
  postedby_name varchar(255) NULL,
  postedby_title varchar(100) NULL,
  constraint pk_depositvoucher_fund PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_parentid_fundid on depositvoucher_fund (parentid,fundid) 
go 
create index ix_state on depositvoucher_fund (state) 
go 
create index ix_parentid on depositvoucher_fund (parentid) 
go 
create index ix_fundid on depositvoucher_fund (fundid) 
go 
create index ix_dtposted on depositvoucher_fund (dtposted) 
go 
create index ix_postedby_objid on depositvoucher_fund (postedby_objid) 
go 
create index ix_postedby_name on depositvoucher_fund (postedby_name) 
go 
alter table depositvoucher_fund 
  add CONSTRAINT fk_depositvoucher_fund_parentid 
  FOREIGN KEY (parentid) REFERENCES depositvoucher (objid) 
go 

drop index uix_parentid_fundid on depositvoucher_fund
go 
drop index ix_fundid on depositvoucher_fund
go 
alter table depositvoucher_fund 
  alter column fundid nvarchar(50) not null 
go 
create index ix_fundid on depositvoucher_fund (fundid)
go 
create unique index uix_parentid_fundid on depositvoucher_fund (parentid,fundid) 
go 
alter table depositvoucher_fund 
  add CONSTRAINT fk_depositvoucher_fund_fundid 
  FOREIGN KEY (fundid) REFERENCES fund (objid) 
go 



CREATE TABLE depositslip (
  objid varchar(100) NOT NULL,
  depositvoucherfundid varchar(150) NULL,
  createdby_objid varchar(50) NULL,
  createdby_name varchar(255) NULL,
  depositdate date NULL,
  dtcreated datetime NULL,
  bankacctid varchar(50) NULL,
  totalcash decimal(16,4) NULL,
  totalcheck decimal(16,4) NULL,
  amount decimal(16,4) NULL,
  validation_refno varchar(50) NULL,
  validation_refdate date NULL,
  cashbreakdown varchar(MAX),
  state varchar(10) NULL,
  deposittype varchar(50) NULL,
  checktype varchar(50) NULL,
  constraint pk_depositslip PRIMARY KEY (objid) 
)
go 
create index ix_depositvoucherid on depositslip (depositvoucherfundid) 
go 
create index ix_createdby_objid on depositslip (createdby_objid) 
go 
create index ix_createdby_name on depositslip (createdby_name) 
go 
create index ix_depositdate on depositslip (depositdate) 
go 
create index ix_dtcreated on depositslip (dtcreated) 
go 
create index ix_bankacctid on depositslip (bankacctid) 
go 
create index ix_validation_refno on depositslip (validation_refno) 
go 
create index ix_validation_refdate on depositslip (validation_refdate) 
go 
alter table depositslip 
  add CONSTRAINT fk_depositslip_depositvoucherfundid 
  FOREIGN KEY (depositvoucherfundid) REFERENCES depositvoucher_fund (objid)
go 


CREATE TABLE checkpayment (
  objid varchar(50) NOT NULL,
  bankid varchar(50) NULL,
  refno varchar(50) NULL,
  refdate date NULL,
  amount decimal(16,4) NULL,
  receiptid varchar(50) NULL,
  bank_name varchar(255) NULL,
  amtused decimal(16,4) NULL,
  receivedfrom varchar(MAX),
  state varchar(50) NULL,
  depositvoucherid varchar(50) NULL,
  fundid varchar(100) NULL,
  depositslipid varchar(100) NULL,
  split int NOT NULL,
  [external] int NOT NULL DEFAULT '0',
  collector_objid varchar(50) NULL,
  collector_name varchar(255) NULL,
  subcollector_objid varchar(50) NULL,
  subcollector_name varchar(255) NULL,
  constraint pk_checkpayment PRIMARY KEY (objid) 
)
go 
create index ix_bankid on checkpayment (bankid) 
go 
create index ix_collector_name on checkpayment (collector_name) 
go 
create index ix_collectorid on checkpayment (collector_objid) 
go 
create index ix_depositslipid on checkpayment (depositslipid) 
go 
create index ix_depositvoucherid on checkpayment (depositvoucherid) 
go 
create index ix_fundid on checkpayment (fundid) 
go 
create index ix_receiptid on checkpayment (receiptid) 
go 
create index ix_refdate on checkpayment (refdate) 
go 
create index ix_refno on checkpayment (refno) 
go 
create index ix_state on checkpayment (state) 
go 
create index ix_subcollector_objid on checkpayment (subcollector_objid) 
go 
alter table checkpayment 
  add CONSTRAINT fk_checkpayment_depositslipid 
  FOREIGN KEY (depositslipid) REFERENCES depositslip (objid) 
go 
alter table checkpayment 
  add CONSTRAINT fk_paymentcheck_depositvoucher 
  FOREIGN KEY (depositvoucherid) REFERENCES depositvoucher (objid) 
go 

drop index ix_fundid on checkpayment
go 
alter table checkpayment 
  alter column fundid nvarchar(50) not null 
go 
create index ix_fundid on checkpayment (fundid)
go 
alter table checkpayment 
  add CONSTRAINT fk_paymentcheck_fund 
  FOREIGN KEY (fundid) REFERENCES fund (objid) 
go 


CREATE TABLE checkpayment_deadchecks (
  objid varchar(50) NOT NULL,
  bankid varchar(50) NULL,
  refno varchar(50) NULL,
  refdate date NULL,
  amount decimal(16,4) NULL,
  collector_objid varchar(50) NULL,
  bank_name varchar(255) NULL,
  amtused decimal(16,4) NULL,
  receivedfrom varchar(255) NULL,
  state varchar(50) NULL,
  depositvoucherid varchar(50) NULL,
  fundid varchar(100) NULL,
  depositslipid varchar(100) NULL,
  split int NOT NULL,
  amtdeposited decimal(16,4) NULL,
  [external] int NULL,
  collector_name varchar(255) NULL,
  subcollector_objid varchar(50) NULL,
  subcollector_name varchar(255) NULL,
  collectorid varchar(50) NULL,
  constraint pk_checkpayment_deadchecks PRIMARY KEY (objid) 
)
go 
create index ix_bankid on checkpayment_deadchecks (bankid) 
go 
create index ix_collector_name on checkpayment_deadchecks (collector_name) 
go 
create index ix_collectorid on checkpayment_deadchecks (collector_objid) 
go 
create index ix_collectorid_ on checkpayment_deadchecks (collectorid) 
go 
create index ix_depositslipid on checkpayment_deadchecks (depositslipid) 
go 
create index ix_depositvoucherid on checkpayment_deadchecks (depositvoucherid) 
go 
create index ix_fundid on checkpayment_deadchecks (fundid) 
go 
create index ix_refdate on checkpayment_deadchecks (refdate) 
go 
create index ix_refno on checkpayment_deadchecks (refno) 
go 
create index ix_subcollector_objid on checkpayment_deadchecks (subcollector_objid) 
go 


CREATE TABLE checkpayment_dishonored (
  objid varchar(50) NOT NULL,
  checkpaymentid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  filedby_objid varchar(50) NOT NULL,
  filedby_name varchar(150) NOT NULL,
  remarks varchar(255) NOT NULL,
  constraint pk_checkpayment_dishonored PRIMARY KEY (objid) 
)
go 
create index ix_checkpaymentid on checkpayment_dishonored (checkpaymentid) 
go 
create index ix_dtfiled on checkpayment_dishonored (dtfiled) 
go 
create index ix_filedby_objid on checkpayment_dishonored (filedby_objid) 
go 
create index ix_filedby_name on checkpayment_dishonored (filedby_name) 
go 
alter table checkpayment_dishonored 
  add CONSTRAINT fk_checkpayment_dishonored_checkpaymentid 
  FOREIGN KEY (checkpaymentid) REFERENCES checkpayment (objid) 
go 


CREATE TABLE collectiongroup_org (
  objid varchar(100) NOT NULL,
  collectiongroupid varchar(50) NOT NULL,
  org_objid varchar(50) NOT NULL,
  org_name varchar(255) NOT NULL,
  org_type varchar(50) NOT NULL,
  constraint pk_collectiongroup_org PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_collectiongroup_org on collectiongroup_org (collectiongroupid,org_objid) 
go 
create index ix_collectiongroupid on collectiongroup_org (collectiongroupid) 
go 
create index ix_org_objid on collectiongroup_org (org_objid) 
go 

drop index uix_collectiongroup_org on collectiongroup_org
go 
drop index ix_collectiongroupid on collectiongroup_org
go 
alter table collectiongroup_org 
  alter column collectiongroupid nvarchar(50) not null 
go 
create index ix_collectiongroupid on collectiongroup_org (collectiongroupid) 
go 
alter table collectiongroup_org 
  add CONSTRAINT fk_collectiongroup_org_parent 
  FOREIGN KEY (collectiongroupid) REFERENCES collectiongroup (objid) 
go 

create UNIQUE index uix_collectiongroup_org on collectiongroup_org (collectiongroupid,org_objid) 
go 



CREATE TABLE collectiontype_org (
  objid varchar(100) NOT NULL,
  collectiontypeid varchar(50) NULL,
  org_objid varchar(50) NULL,
  org_name varchar(150) NULL,
  org_type varchar(50) NULL,
  constraint pk_collectiontype_org PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_collectiontype_org on collectiontype_org (collectiontypeid,org_objid) 
go 
create index ix_collectiontypeid on collectiontype_org (collectiontypeid) 
go 
create index ix_org_objid on collectiontype_org (org_objid) 
go 
create index ix_org_name on collectiontype_org (org_name) 
go 

drop index uix_collectiontype_org on collectiontype_org 
go 
drop index ix_collectiontypeid on collectiontype_org 
go 
alter table collectiontype_org 
  alter column collectiontypeid nvarchar(50) not null 
go 
create index ix_collectiontypeid on collectiontype_org (collectiontypeid) 
go 
alter table collectiontype_org 
  add CONSTRAINT fk_collectiontype_org_parent 
  FOREIGN KEY (collectiontypeid) REFERENCES collectiontype (objid) 
go 

create UNIQUE index uix_collectiontype_org on collectiontype_org (collectiontypeid,org_objid) 
go 



CREATE TABLE collectionvoucher (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  controlno varchar(100) NOT NULL,
  controldate date NOT NULL,
  dtposted datetime NOT NULL,
  liquidatingofficer_objid varchar(50) NULL,
  liquidatingofficer_name varchar(100) NULL,
  liquidatingofficer_title varchar(50) NULL,
  liquidatingofficer_signature varchar(MAX),
  amount decimal(18,2) NULL,
  totalcash decimal(18,2) NULL,
  totalcheck decimal(16,4) NULL,
  cashbreakdown varchar(MAX),
  totalcr decimal(16,4) NULL,
  depositvoucherid varchar(50) NULL,
  constraint pk_collectionvoucher PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_controlno on collectionvoucher (controlno) 
go 
create index ix_state on collectionvoucher (state) 
go 
create index ix_controldate on collectionvoucher (controldate) 
go 
create index ix_dtposted on collectionvoucher (dtposted) 
go 
create index ix_liquidatingofficer_objid on collectionvoucher (liquidatingofficer_objid) 
go 
create index ix_liquidatingofficer_name on collectionvoucher (liquidatingofficer_name) 
go 
create index ix_depositvoucherid on collectionvoucher (depositvoucherid) 
go 
alter table collectionvoucher 
  add CONSTRAINT fk_collectionvoucher_depositvoucherid 
  FOREIGN KEY (depositvoucherid) REFERENCES depositvoucher (objid) 
go 


drop index ix_liquidatingofficer_objid on collectionvoucher 
go 
alter table collectionvoucher 
  alter column liquidatingofficer_objid nvarchar(50) null 
go 
create index ix_liquidatingofficer_objid on collectionvoucher (liquidatingofficer_objid) 
go 
alter table collectionvoucher 
  add CONSTRAINT fk_collectionvoucher_liquidatingofficer 
  FOREIGN KEY (liquidatingofficer_objid) REFERENCES sys_user (objid) 
go 


CREATE TABLE collectionvoucher_fund (
  objid varchar(255) NOT NULL,
  controlno varchar(100) NOT NULL,
  parentid varchar(50) NOT NULL,
  fund_objid varchar(100) NOT NULL,
  fund_title varchar(100) NOT NULL,
  amount decimal(16,4) NOT NULL,
  totalcash decimal(16,4) NOT NULL,
  totalcheck decimal(16,4) NOT NULL,
  totalcr decimal(16,4) NOT NULL,
  cashbreakdown varchar(MAX),
  depositvoucherid varchar(50) NULL,
  constraint pk_collectionvoucher_fund PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_parentid_fund_objid on collectionvoucher_fund (parentid,fund_objid) 
go 
create index ix_controlno on collectionvoucher_fund (controlno) 
go 
create index ix_parentid on collectionvoucher_fund (parentid) 
go 
create index ix_fund_objid on collectionvoucher_fund (fund_objid) 
go 
create index ix_depositvoucherid on collectionvoucher_fund (depositvoucherid) 
go 
alter table collectionvoucher_fund 
  add CONSTRAINT fk_collectionvoucher_fund_parentid 
  FOREIGN KEY (parentid) REFERENCES collectionvoucher (objid) 
go 


drop index uix_parentid_fund_objid on collectionvoucher_fund 
go 
drop index ix_fund_objid on collectionvoucher_fund 
go 
alter table collectionvoucher_fund 
  alter column fund_objid nvarchar(50) not null 
go 
create index ix_fund_objid on collectionvoucher_fund (fund_objid) 
go 
alter table collectionvoucher_fund 
  add CONSTRAINT fk_collectionvoucher_fund_fund_objid 
  FOREIGN KEY (fund_objid) REFERENCES fund (objid) 
go 
create UNIQUE index uix_parentid_fund_objid on collectionvoucher_fund (parentid,fund_objid) 
go 


CREATE TABLE deposit_fund_transfer (
  objid varchar(150) NOT NULL,
  fromdepositvoucherfundid varchar(150) NOT NULL,
  todepositvoucherfundid varchar(150) NOT NULL,
  amount decimal(16,4) NOT NULL,
  constraint pk_deposit_fund_transfer PRIMARY KEY (objid) 
)
go 
create index ix_fromfundid on deposit_fund_transfer (fromdepositvoucherfundid) 
go 
create index ix_tofundid on deposit_fund_transfer (todepositvoucherfundid) 
go 
alter table deposit_fund_transfer 
  add CONSTRAINT fk_deposit_fund_transfer_fromdepositvoucherfundid 
  FOREIGN KEY (fromdepositvoucherfundid) REFERENCES depositvoucher_fund (objid) 
go 
alter table deposit_fund_transfer 
  add CONSTRAINT fk_deposit_fund_transfer_todepositvoucherfundid 
  FOREIGN KEY (todepositvoucherfundid) REFERENCES depositvoucher_fund (objid)
go 


if object_id('dbo.draftremittanceitem', 'U') IS NOT NULL 
  drop table draftremittanceitem;
go 
if object_id('dbo.draftremittance', 'U') IS NOT NULL 
  drop table draftremittance; 
go 

CREATE TABLE draftremittance (
  objid varchar(50) NOT NULL,
  state varchar(20) NOT NULL,
  dtfiled datetime NOT NULL,
  remittancedate datetime NOT NULL,
  collector_objid varchar(50) NOT NULL,
  collector_name varchar(255) NOT NULL,
  collector_title varchar(255) NOT NULL,
  amount decimal(18,2) NOT NULL,
  totalcash decimal(18,2) NOT NULL,
  totalnoncash decimal(18,2) NOT NULL,
  txnmode varchar(32) NOT NULL,
  lockid varchar(50) NULL,
  constraint pk_draftremittance PRIMARY KEY (objid) 
)
go 
create index ix_dtfiled on draftremittance (dtfiled) 
go 
create index ix_remittancedate on draftremittance (remittancedate) 
go 
create index ix_collector_objid on draftremittance (collector_objid) 
go 


CREATE TABLE draftremittanceitem (
  objid varchar(50) NOT NULL,
  remittanceid varchar(50) NOT NULL,
  controlid varchar(50) NOT NULL,
  batchid varchar(50) NULL,
  amount decimal(18,2) NOT NULL,
  totalcash decimal(18,2) NOT NULL,
  totalnoncash decimal(18,2) NOT NULL,
  voided int NOT NULL,
  cancelled int NOT NULL,
  lockid varchar(50) NULL,
  constraint pk_draftremittanceitem PRIMARY KEY (objid) 
)
go 
create index ix_remittanceid on draftremittanceitem (remittanceid) 
go 
create index ix_controlid on draftremittanceitem (controlid) 
go 
create index ix_batchid on draftremittanceitem (batchid) 
go 


CREATE TABLE eftpayment (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,4) NOT NULL,
  receivedfrom varchar(255) NULL,
  particulars varchar(255) NULL,
  bankacctid varchar(50) NOT NULL,
  fundid varchar(100) NULL,
  createdby_objid varchar(50) NOT NULL,
  createdby_name varchar(255) NOT NULL,
  receiptid varchar(50) NULL,
  receiptno varchar(50) NULL,
  payer_objid varchar(50) NULL,
  payer_name varchar(255) NULL,
  payer_address_objid varchar(50) NULL,
  payer_address_text varchar(255) NULL,
  constraint pk_eftpayment PRIMARY KEY (objid) 
)
go 
create index ix_state on eftpayment (state) 
go 
create index ix_refno on eftpayment (refno) 
go 
create index ix_refdate on eftpayment (refdate) 
go 
create index ix_bankacctid on eftpayment (bankacctid) 
go 
create index ix_fundid on eftpayment (fundid) 
go 
create index ix_createdby_objid on eftpayment (createdby_objid) 
go 
create index ix_receiptid on eftpayment (receiptid) 
go 
create index ix_payer_objid on eftpayment (payer_objid) 
go 
create index ix_payer_address_objid on eftpayment (payer_address_objid) 
go 

drop index ix_bankacctid on eftpayment 
go 
alter table eftpayment 
  alter column bankacctid nvarchar(50) not null 
go 
create index ix_bankacctid on eftpayment (bankacctid) 
go 
alter table eftpayment 
  add CONSTRAINT fk_eftpayment_bankacct 
  FOREIGN KEY (bankacctid) REFERENCES bankaccount (objid) 
go 

drop index ix_fundid on eftpayment 
go 
alter table eftpayment 
  alter column fundid nvarchar(50) null 
go 
create index ix_fundid on eftpayment (fundid) 
go 
alter table eftpayment 
  add CONSTRAINT fk_eftpayment_fund 
  FOREIGN KEY (fundid) REFERENCES fund (objid) 
go 


CREATE TABLE entityprofile (
  objid varchar(50) NOT NULL,
  idno varchar(50) NOT NULL,
  lastname varchar(60) NOT NULL,
  firstname varchar(60) NOT NULL,
  middlename varchar(60) NULL,
  birthdate date NULL,
  gender varchar(10) NULL,
  address varchar(MAX),
  defaultentityid varchar(50) NULL,
  constraint pk_entityprofile PRIMARY KEY (objid) 
)
go 
create index ix_defaultentityid on entityprofile (defaultentityid) 
go 
create index ix_firstname on entityprofile (firstname) 
go 
create index ix_idno on entityprofile (idno) 
go 
create index ix_lastname on entityprofile (lastname) 
go 
create index ix_lfname on entityprofile (lastname,firstname) 
go 


CREATE TABLE entity_ctc (
  objid varchar(50) NOT NULL,
  entityid varchar(50) NOT NULL,
  nonresident int NOT NULL,
  ctcno varchar(50) NOT NULL,
  dtissued date NOT NULL,
  placeissued varchar(255) NOT NULL,
  lgu_objid varchar(50) NULL,
  lgu_name varchar(255) NULL,
  barangay_objid varchar(50) NULL,
  barangay_name varchar(255) NOT NULL,
  createdby_objid varchar(50) NOT NULL,
  createdby_name varchar(160) NOT NULL,
  system int NOT NULL DEFAULT '0',
  constraint pk_entity_ctc PRIMARY KEY (objid) 
)
go 
create index ix_barangay_name on entity_ctc (barangay_name) 
go 
create index ix_barangay_objid on entity_ctc (barangay_objid) 
go 
create index ix_createdby_name on entity_ctc (createdby_name) 
go 
create index ix_createdby_objid on entity_ctc (createdby_objid) 
go 
create index ix_ctcno on entity_ctc (ctcno) 
go 
create index ix_dtissued on entity_ctc (dtissued) 
go 
create index ix_entityid on entity_ctc (entityid) 
go 
create index ix_lgu_name on entity_ctc (lgu_name) 
go 
create index ix_lgu_objid on entity_ctc (lgu_objid) 
go 


drop index ix_entityid on entity_ctc 
go 
alter table entity_ctc 
  alter column entityid nvarchar(50) not null 
go 
create index ix_entityid on entity_ctc (entityid) 
go 
alter table entity_ctc 
  add CONSTRAINT fk_entity_ctc_entityid 
  FOREIGN KEY (entityid) REFERENCES entity (objid) 
go 


CREATE TABLE entity_fingerprint (
  objid varchar(50) NOT NULL,
  entityid varchar(50) NULL,
  dtfiled datetime NULL,
  fingertype varchar(20) NULL,
  data varchar(MAX),
  image varchar(MAX),
  constraint pk_entity_fingerprint PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_entityid_fingertype on entity_fingerprint (entityid,fingertype) 
go 
create index ix_dtfiled on entity_fingerprint (dtfiled) 
go 


CREATE TABLE entity_reconciled (
  objid varchar(50) NOT NULL,
  info varchar(MAX),
  masterid varchar(50) NULL,
  constraint pk_entity_reconciled PRIMARY KEY (objid) 
)
go 
create index ix_masterid on entity_reconciled (masterid) 
go 


drop index ix_masterid on entity_reconciled 
go 
alter table entity_reconciled 
  alter column masterid nvarchar(50) null 
go 
create index ix_masterid on entity_reconciled (masterid) 
go 
alter table entity_reconciled 
  add CONSTRAINT FK_entity_reconciled_entity 
  FOREIGN KEY (masterid) REFERENCES entity (objid) 
go 


CREATE TABLE entity_reconciled_txn (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  tag char(1) NULL,
  constraint pk_entity_reconciled_txn PRIMARY KEY (objid,reftype,refid) 
)
go 


CREATE TABLE entity_relation_type (
  objid varchar(50) NOT NULL DEFAULT '',
  gender varchar(1) NULL,
  inverse_any varchar(50) NULL,
  inverse_male varchar(50) NULL,
  inverse_female varchar(50) NULL,
  constraint pk_entity_relation_type PRIMARY KEY (objid)
)
go 

INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('AUNT', 'F', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('BROTHER', 'M', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('COUSIN', NULL, 'COUSIN', 'COUSIN', 'COUSIN');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('DAUGHTER', 'F', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('FATHER', 'M', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('GRANDDAUGHTER', 'F', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('GRANDSON', 'M', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('HUSBAND', 'M', 'SPOUSE', 'SPOUSE', 'WIFE');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('MOTHER', 'F', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('NEPHEW', 'M', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('NIECE', 'F', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('SISTER', 'F', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('SON', 'M', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('SPOUSE', NULL, 'SPOUSE', 'HUSBAND', 'WIFE');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('UNCLE', 'M', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO entity_relation_type (objid, gender, inverse_any, inverse_male, inverse_female) VALUES ('WIFE', 'F', 'SPOUSE', 'HUSBAND', 'SPOUSE');


if object_id('dbo.entity_relation', 'U') IS NOT NULL 
  drop table entity_relation
go 

CREATE TABLE entity_relation (
  objid varchar(50) NOT NULL,
  entity_objid nvarchar(50) NULL,
  relateto_objid nvarchar(50) NULL,
  relation_objid varchar(50) NULL,
  constraint pk_entity_relation PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_sender_receiver on entity_relation (entity_objid,relateto_objid) 
go 
create index ix_entity_objid on entity_relation (entity_objid) 
go 
create index ix_relateto_objid on entity_relation (relateto_objid) 
go 
create index ix_relation_objid on entity_relation (relation_objid) 
go 
alter table entity_relation 
  add CONSTRAINT fk_entity_relation_entity_objid 
  FOREIGN KEY (entity_objid) REFERENCES entity (objid) 
go 
alter table entity_relation 
  add CONSTRAINT fk_entity_relation_relation_objid 
  FOREIGN KEY (relateto_objid) REFERENCES entity (objid) 
go 
alter table entity_relation 
  add CONSTRAINT fk_entity_relation_relation 
  FOREIGN KEY (relation_objid) REFERENCES entity_relation_type (objid) 
go 


CREATE TABLE fundgroup (
  objid varchar(50) NOT NULL,
  title varchar(100) NOT NULL,
  indexno int NOT NULL,
  constraint pk_fundgroup PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_title on fundgroup (title) 
go 


INSERT INTO fundgroup (objid, title, indexno) VALUES ('GENERAL', 'GENERAL', '0');
INSERT INTO fundgroup (objid, title, indexno) VALUES ('SEF', 'SEF', '1');
INSERT INTO fundgroup (objid, title, indexno) VALUES ('TRUST', 'TRUST', '2');


CREATE TABLE income_ledger (
  objid varchar(150) NOT NULL,
  jevid varchar(150) NULL,
  itemacctid varchar(50) NOT NULL,
  dr decimal(16,4) NOT NULL,
  cr decimal(16,4) NOT NULL,
  constraint pk_income_ledger PRIMARY KEY (objid) 
)
go 
create index ix_jevid on income_ledger (jevid) 
go 
create index ix_itemacctid on income_ledger (itemacctid) 
go 
alter table income_ledger 
  add CONSTRAINT fk_income_ledger_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 


drop index ix_itemacctid on income_ledger 
go 
alter table income_ledger 
  alter column itemacctid nvarchar(50) not null 
go 
create index ix_itemacctid on income_ledger (itemacctid) 
go 
alter table income_ledger 
  add CONSTRAINT fk_income_ledger_itemacctid 
  FOREIGN KEY (itemacctid) REFERENCES itemaccount (objid) 
go 


CREATE TABLE interfund_transfer_ledger (
  objid varchar(150) NOT NULL,
  jevid varchar(150) NULL,
  itemacctid nvarchar(50) NULL,
  dr decimal(16,4) NULL,
  cr decimal(16,4) NULL,
  constraint pk_interfund_transfer_ledger PRIMARY KEY (objid) 
)
go 
create index ix_jevid on interfund_transfer_ledger (jevid) 
go 
create index ix_itemacctid on interfund_transfer_ledger (itemacctid) 
go 
alter table interfund_transfer_ledger 
  add CONSTRAINT fk_interfund_transfer_ledger_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 
alter table interfund_transfer_ledger 
  add CONSTRAINT fk_interfund_transfer_ledger_itemacctid 
  FOREIGN KEY (itemacctid) REFERENCES itemaccount (objid) 
go 


if object_id('dbo.paymentorder_type', 'U') IS NOT NULL 
  drop table paymentorder_type; 
go 

CREATE TABLE paymentorder_type (
  objid varchar(50) NOT NULL,
  title varchar(150) NULL,
  collectiontype_objid nvarchar(50) NULL,
  queuesection varchar(50) NULL,
  constraint pk_paymentorder_type PRIMARY KEY (objid) 
)
go 
create index fk_paymentorder_type_collectiontype on paymentorder_type (collectiontype_objid) 
go 
alter table paymentorder_type 
  add CONSTRAINT fk_paymentorder_type_collectiontype_objid 
  FOREIGN KEY (collectiontype_objid) REFERENCES collectiontype (objid) 
go 


CREATE TABLE payable_ledger (
  objid varchar(50) NOT NULL,
  jevid varchar(150) NULL,
  refitemacctid varchar(50) NULL,
  itemacctid varchar(50) NOT NULL,
  dr decimal(16,4) NULL,
  cr decimal(16,4) NULL,
  constraint pk_payable_ledger PRIMARY KEY (objid) 
)
go 
create index ix_jevid on payable_ledger (jevid) 
go 
create index ix_itemacctid on payable_ledger (itemacctid) 
go 
create index ix_refitemacctid on payable_ledger (refitemacctid) 
go 
alter table payable_ledger 
  add CONSTRAINT fk_payable_ledger_jevid 
  FOREIGN KEY (jevid) REFERENCES jev (objid) 
go 



if object_id('dbo.sys_report', 'U') IS NOT NULL 
  drop table sys_report;
go 

CREATE TABLE sys_report (
  objid varchar(50) NOT NULL,
  folderid varchar(50) NULL,
  title varchar(255) NULL,
  filetype varchar(25) NULL,
  dtcreated datetime NULL,
  createdby_objid varchar(50) NULL,
  createdby_name varchar(255) NULL,
  datasetid nvarchar(50) NULL,
  template varchar(MAX),
  outputtype varchar(50) NULL,
  system int NULL,
  constraint pk_sys_report PRIMARY KEY (objid) 
)
go 
create index ix_datasetid on sys_report (datasetid) 
go 
create index ix_folderid on sys_report (folderid) 
go 
alter table sys_report 
  add CONSTRAINT fk_sys_report_datasetid  
  FOREIGN KEY (datasetid) REFERENCES sys_dataset (objid) 
go 


CREATE TABLE treasury_variableinfo (
  objid varchar(50) NOT NULL,
  state varchar(10) NOT NULL,
  name varchar(50) NOT NULL,
  datatype varchar(20) NOT NULL,
  caption varchar(50) NOT NULL,
  description varchar(100) NULL,
  arrayvalues varchar(MAX),
  system int NULL,
  sortorder int NULL,
  category varchar(100) NULL,
  handler varchar(50) NULL,
  constraint pk_treasury_variableinfo PRIMARY KEY (objid) 
)
go 
create index ix_name on treasury_variableinfo (name) 
go 


CREATE TABLE cashbook_revolving_fund (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  dtfiled datetime NOT NULL,
  filedby_objid varchar(50) NOT NULL,
  filedby_name varchar(150) NOT NULL,
  issueto_objid varchar(50) NOT NULL,
  issueto_name varchar(150) NOT NULL,
  controldate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  remarks varchar(255) NOT NULL,
  fund_objid varchar(100) NOT NULL,
  fund_title varchar(255) NOT NULL,
  constraint pk_cashbook_revolving_fund PRIMARY KEY (objid)
)
go 
create index ix_state on cashbook_revolving_fund (state) 
go 
create index ix_dtfiled on cashbook_revolving_fund (dtfiled) 
go 
create index ix_filedby_objid on cashbook_revolving_fund (filedby_objid) 
go 
create index ix_filedby_name on cashbook_revolving_fund (filedby_name) 
go 
create index ix_issueto_objid on cashbook_revolving_fund (issueto_objid) 
go 
create index ix_issueto_name on cashbook_revolving_fund (issueto_name) 
go 
create index ix_controldate on cashbook_revolving_fund (controldate) 
go 
create index ix_fund_objid on cashbook_revolving_fund (fund_objid) 
go 
create index ix_fund_title on cashbook_revolving_fund (fund_title) 
go 


CREATE TABLE cashreceipt_changelog (
  objid varchar(50) NOT NULL,
  receiptid nvarchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  filedby_objid varchar(50) NOT NULL,
  filedby_name varchar(150) NOT NULL,
  action varchar(255) NOT NULL,
  remarks varchar(255) NOT NULL,
  oldvalue text NOT NULL,
  newvalue text NOT NULL,
  constraint pk_cashreceipt_changelog PRIMARY KEY (objid) 
)
go 
create index ix_receiptid on cashreceipt_changelog (receiptid) 
go 
create index ix_dtfiled on cashreceipt_changelog (dtfiled) 
go 
create index ix_filedby_objid on cashreceipt_changelog (filedby_objid) 
go 
create index ix_filedby_name on cashreceipt_changelog (filedby_name) 
go 
create index ix_action on cashreceipt_changelog (action) 
go 
alter table cashreceipt_changelog 
  add CONSTRAINT fk_cashreceipt_changelog_receiptid 
  FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid) 
go 


CREATE TABLE af_control_detail (
  objid varchar(150) NOT NULL,
  state int NULL,
  controlid varchar(50) NOT NULL,
  indexno int NOT NULL,
  refid varchar(50) NOT NULL,
  aftxnitemid varchar(50) NULL,
  refno varchar(50) NOT NULL,
  reftype varchar(32) NOT NULL,
  refdate datetime NOT NULL,
  txndate datetime NOT NULL,
  txntype varchar(32) NOT NULL,
  receivedstartseries int NULL,
  receivedendseries int NULL,
  beginstartseries int NULL,
  beginendseries int NULL,
  issuedstartseries int NULL,
  issuedendseries int NULL,
  endingstartseries int NULL,
  endingendseries int NULL,
  qtyreceived int NOT NULL,
  qtybegin int NOT NULL,
  qtyissued int NOT NULL,
  qtyending int NOT NULL,
  qtycancelled int NOT NULL,
  remarks varchar(255) NULL,
  issuedto_objid varchar(50) NULL,
  issuedto_name varchar(255) NULL,
  respcenter_objid varchar(50) NULL,
  respcenter_name varchar(255) NULL,
  prevdetailid varchar(150) NULL,
  aftxnid varchar(100) NULL,
  constraint pk_af_control_detail PRIMARY KEY (objid) 
)
go 
create index ix_aftxnid on af_control_detail (aftxnid) 
go 
create index ix_aftxnitemid on af_control_detail (aftxnitemid) 
go 
create index ix_controlid on af_control_detail (controlid) 
go 
create index ix_issuedto_name on af_control_detail (issuedto_name) 
go 
create index ix_issuedto_objid on af_control_detail (issuedto_objid) 
go 
create index ix_prevdetailid on af_control_detail (prevdetailid) 
go 
create index ix_refdate on af_control_detail (refdate) 
go 
create index ix_refid on af_control_detail (refid) 
go 
create index ix_refitemid on af_control_detail (aftxnitemid) 
go 
create index ix_refno on af_control_detail (refno) 
go 
create index ix_reftype on af_control_detail (reftype) 
go 
create index ix_respcenter_name on af_control_detail (respcenter_name) 
go 
create index ix_respcenter_objid on af_control_detail (respcenter_objid) 
go 
create index ix_txndate on af_control_detail (txndate) 
go 
create index ix_txntype on af_control_detail (txntype) 
go 
alter table af_control_detail 
  add CONSTRAINT fk_af_control_detail_aftxnid 
  FOREIGN KEY (aftxnid) REFERENCES aftxn (objid) 
go 
alter table af_control_detail 
  add CONSTRAINT fk_af_control_detail_controlid 
  FOREIGN KEY (controlid) REFERENCES af_control (objid) 
go 


CREATE TABLE holiday (
  objid varchar(50) NOT NULL,
  year int NULL,
  month int NULL,
  day int NULL,
  week int NULL,
  dow int NULL,
  name varchar(255) NULL,
  constraint pk_holiday PRIMARY KEY (objid)
)
go 


CREATE TABLE af_allocation (
  objid varchar(50) NOT NULL,
  name varchar(100) NOT NULL,
  respcenter_objid varchar(50) NULL,
  respcenter_name varchar(100) NULL,
  constraint pk_af_allocation PRIMARY KEY (objid) 
)
go 
create index ix_name on af_allocation (name) 
go 
create index ix_respcenter_objid on af_allocation (respcenter_objid) 
go 
create index ix_respcenter_name on af_allocation (respcenter_name) 
go 


if object_id('dbo.income_summary', 'U') IS NOT NULL 
  drop table income_summary;
go 

CREATE TABLE income_summary (
  refid varchar(50) NOT NULL,
  refdate date NOT NULL,
  refno varchar(50) NULL,
  reftype varchar(50) NULL,
  acctid varchar(50) NOT NULL,
  fundid varchar(50) NOT NULL,
  amount decimal(16,4) NULL,
  orgid varchar(50) NOT NULL,
  collectorid varchar(50) NULL,
  refyear int NULL,
  refmonth int NULL,
  refqtr int NULL,
  remittanceid varchar(50) NOT NULL DEFAULT '',
  remittancedate date NULL,
  remittanceyear int NULL,
  remittancemonth int NULL,
  remittanceqtr int NULL,
  liquidationid varchar(50) NOT NULL DEFAULT '',
  liquidationdate date NULL,
  liquidationyear int NULL,
  liquidationmonth int NULL,
  liquidationqtr int NULL,
  constraint pk_income_summary PRIMARY KEY (refid,refdate,fundid,acctid,orgid,remittanceid,liquidationid)
)
go 
create index ix_refdate on income_summary (refdate) 
go 
create index ix_refno on income_summary (refno) 
go 
create index ix_acctid on income_summary (acctid) 
go 
create index ix_fundid on income_summary (fundid) 
go 
create index ix_orgid on income_summary (orgid) 
go 
create index ix_collectorid on income_summary (collectorid) 
go 
create index ix_refyear on income_summary (refyear) 
go 
create index ix_refmonth on income_summary (refmonth) 
go 
create index ix_refqtr on income_summary (refqtr) 
go 
create index ix_remittanceid on income_summary (remittanceid) 
go 
create index ix_remittancedate on income_summary (remittancedate) 
go 
create index ix_remittanceyear on income_summary (remittanceyear) 
go 
create index ix_remittancemonth on income_summary (remittancemonth) 
go 
create index ix_remittanceqtr on income_summary (remittanceqtr) 
go 
create index ix_liquidationid on income_summary (liquidationid) 
go 
create index ix_liquidationdate on income_summary (liquidationdate) 
go 
create index ix_liquidationyear on income_summary (liquidationyear) 
go 
create index ix_liquidationmonth on income_summary (liquidationmonth) 
go 
create index ix_liquidationqtr on income_summary (liquidationqtr) 
go 
