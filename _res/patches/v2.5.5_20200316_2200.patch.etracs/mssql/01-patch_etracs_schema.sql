-- alter table account_incometarget add CONSTRAINT fk_account_incometarget_itemid 
-- 	FOREIGN KEY (itemid) REFERENCES account (objid)
-- go 

-- CREATE TABLE business_closure ( 
--    objid varchar(50) NOT NULL, 
--    businessid varchar(50) NOT NULL, 
--    dtcreated datetime NOT NULL, 
--    createdby_objid varchar(50) NOT NULL, 
--    createdby_name varchar(150) NOT NULL, 
--    dtceased date NOT NULL, 
--    dtissued datetime NOT NULL, 
--    remarks text NULL,
--    CONSTRAINT pk_business_closure PRIMARY KEY (objid)
-- ) 
-- go 
-- CREATE UNIQUE INDEX uix_businessid on business_closure (businessid)
-- go 
-- CREATE INDEX ix_createdby_objid ON business_closure (createdby_objid)
-- go 
-- CREATE INDEX ix_dtceased ON business_closure (dtceased)
-- go 
-- CREATE INDEX ix_dtcreated ON business_closure (dtcreated)
-- go 
-- CREATE INDEX ix_dtissued ON business_closure (dtissued)
-- go 
-- alter table business_closure add CONSTRAINT fk_business_closure_businessid 
--    FOREIGN KEY (businessid) REFERENCES business (objid)
-- go 


-- create UNIQUE index uix_code on businessrequirementtype (code)
-- go  
-- create UNIQUE index uix_title on businessrequirementtype (title)
-- go 

-- create UNIQUE index uix_name on businessvariable (name)
-- go 

if object_id('dbo.cashreceipt_groupitem', 'U') IS NOT NULL 
   drop table cashreceipt_groupitem; 

if object_id('dbo.cashreceipt_group', 'U') IS NOT NULL 
   drop table cashreceipt_group; 

go 

CREATE TABLE cashreceipt_group ( 
   objid varchar(50) NOT NULL, 
   txndate datetime NOT NULL, 
   controlid varchar(50) NOT NULL, 
   amount decimal(16,2) NOT NULL, 
   totalcash decimal(16,2) NOT NULL, 
   totalnoncash decimal(16,2) NOT NULL, 
   cashchange decimal(16,2) NOT NULL,
   CONSTRAINT pk_cashreceipt_group PRIMARY KEY (objid)
) 
go 
CREATE INDEX ix_controlid ON cashreceipt_group (controlid)
go 
CREATE INDEX ix_txndate ON cashreceipt_group (txndate)
go 


CREATE TABLE cashreceipt_groupitem ( 
   objid nvarchar(50) NOT NULL, 
   parentid varchar(50) NOT NULL,
   CONSTRAINT pk_cashreceipt_groupitem PRIMARY KEY (objid)
) 
go 
create index ix_parentid on cashreceipt_groupitem (parentid)
go 
alter table cashreceipt_groupitem add CONSTRAINT fk_cashreceipt_groupitem_objid 
   FOREIGN KEY (objid) REFERENCES cashreceipt (objid) 
go 
alter table cashreceipt_groupitem add CONSTRAINT fk_cashreceipt_groupitem_parentid 
   FOREIGN KEY (parentid) REFERENCES cashreceipt_group (objid) 
go 


if object_id('dbo.cashreceipt_plugin', 'U') IS NOT NULL 
   drop table cashreceipt_plugin; 
go 

CREATE TABLE cashreceipt_plugin ( 
   objid varchar(50) NOT NULL, 
   connection varchar(150) NOT NULL, 
   servicename varchar(255) NOT NULL,
   CONSTRAINT pk_cashreceipt_plugin PRIMARY KEY (objid)
) 
go 


-- create unique index uix_receiptid on cashreceipt_void (receiptid)
-- go  


-- alter table collectiontype add info text null 
-- go  


-- CREATE TABLE entity_mapping ( 
--    objid varchar(50) NOT NULL, 
--    parent_objid varchar(50) NOT NULL, 
--    org_objid varchar(50) NULL,
--    CONSTRAINT pk_entity_mapping PRIMARY KEY (objid)
-- ) 
-- go 


-- alter table lob add _ukey varchar(50) not null default ''
-- go 
-- update lob set _ukey=objid where _ukey=''
-- go 
-- create unique index uix_name on lob (name, _ukey)
-- go 


if object_id('dbo.paymentorder', 'U') IS NOT NULL 
  drop table dbo.paymentorder; 
go 
CREATE TABLE paymentorder (
   objid varchar(50) NOT NULL, 
   txndate datetime NULL, 
   payer_objid varchar(50) NULL, 
   payer_name text NULL, 
   paidby text NULL, 
   paidbyaddress varchar(150) NULL, 
   particulars text NULL, 
   amount decimal(16,2) NULL, 
   txntype varchar(50) NULL, 
   expirydate date NULL, 
   refid varchar(50) NULL, 
   refno varchar(50) NULL, 
   info text NULL, 
   txntypename varchar(255) NULL, 
   locationid varchar(50) NULL, 
   origin varchar(50) NULL, 
   issuedby_objid varchar(50) NULL, 
   issuedby_name varchar(150) NULL, 
   org_objid varchar(50) NULL, 
   org_name varchar(255) NULL, 
   items text NULL, 
   collectiontypeid varchar(50) NULL, 
   queueid varchar(50) NULL,
   CONSTRAINT pk_paymentorder PRIMARY KEY (objid)
) 
go 
create index ix_collectiontypeid on paymentorder (collectiontypeid)
go 
create index ix_issuedby_name on paymentorder (issuedby_name)
go 
create index ix_issuedby_objid on paymentorder (issuedby_objid)
go 
create index ix_locationid on paymentorder (locationid)
go 
create index ix_org_name on paymentorder (org_name)
go 
create index ix_org_objid on paymentorder (org_objid)
go 


-- CREATE TABLE sync_data ( 
--    objid varchar(50) NOT NULL, 
--    parentid varchar(50) NOT NULL, 
--    refid varchar(50) NOT NULL, 
--    reftype varchar(50) NOT NULL, 
--    action varchar(50) NOT NULL, 
--    orgid varchar(50) NULL, 
--    remote_orgid varchar(50) NULL, 
--    remote_orgcode varchar(20) NULL, 
--    remote_orgclass varchar(20) NULL, 
--    dtfiled datetime NOT NULL, 
--    idx int NOT NULL, 
--    sender_objid varchar(50) NULL, 
--    sender_name varchar(150) NULL, 
--    refno varchar(50) NULL,
--    CONSTRAINT pk_sync_data PRIMARY KEY (objid)
-- ) 
-- go 
-- create index ix_sync_data_dtfiled on sync_data (dtfiled)
-- go 
-- create index ix_sync_data_orgid on sync_data (orgid)
-- go 
-- create index ix_sync_data_refid on sync_data (refid)
-- go 
-- create index ix_sync_data_reftype on sync_data (reftype)
-- go 


-- CREATE TABLE sync_data_forprocess ( 
--    objid varchar(50) NOT NULL,
--    CONSTRAINT pk_sync_data_forprocess PRIMARY KEY (objid) 
-- ) 
-- go 
-- alter table sync_data_forprocess add CONSTRAINT fk_sync_data_forprocess_sync_data 
--    FOREIGN KEY (objid) REFERENCES sync_data (objid) 
-- go 


-- CREATE TABLE sync_data_pending ( 
--    objid varchar(50) NOT NULL, 
--    error text NULL, 
--    expirydate datetime NULL,
--    CONSTRAINT pk_sync_data_pending PRIMARY KEY (objid) 
-- ) 
-- go 
-- create index ix_expirydate on sync_data_pending (expirydate)
-- go 
-- alter table sync_data_pending add CONSTRAINT fk_sync_data_pending_sync_data 
--    FOREIGN KEY (objid) REFERENCES sync_data (objid)
-- go 


-- CREATE UNIQUE INDEX uix_ruleset_name ON sys_rule (ruleset,name)
-- go 
