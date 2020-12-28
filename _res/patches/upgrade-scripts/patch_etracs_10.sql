use etracs255_aklan
go 

update itemaccount set state = 'INACTIVE' where state = 'DRAFT'
;

-- 
-- create table business_closure (
  -- objid varchar(50) not null, 
  -- businessid varchar(50) not null, 
  -- dtcreated datetime not null, 
  -- createdby_objid varchar(50) not null, 
  -- createdby_name varchar(150) not null, 
  -- dtceased date not null, 
  -- dtissued datetime not null, 
  -- remarks text null, 
  -- constraint pk_business_closure primary key (objid)
-- ) 
-- go 
-- create index ix_businessid on business_closure (businessid) 
-- go
-- create index ix_dtcreated on business_closure (dtcreated) 
-- go
-- create index ix_createdby_objid on business_closure (createdby_objid) 
-- go
-- create index ix_createdby_name on business_closure (createdby_name) 
-- go
-- create index ix_dtceased on business_closure (dtceased) 
-- go
-- create index ix_dtissued on business_closure (dtissued) 
-- go
-- 
-- alter table business_closure add constraint fk_business_closure_businessid 
  -- foreign key (businessid) references business (objid) 
-- go 


/*
CREATE TABLE report_bpdelinquency (
  objid varchar(50) NOT NULL,
  state varchar(25) NULL,
  dtfiled datetime NULL,
  userid varchar(50) NULL,
  username varchar(160) NULL,
  totalcount int(255) NULL,
  processedcount int(255) NULL,
  billdate date NULL,
  duedate date NULL,
  lockid varchar(50) NULL,
  constraint pk_report_bpdelinquency PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create index ix_dtfiled on report_bpdelinquency (dtfiled) 
;
create index ix_state on report_bpdelinquency (state) 
;
create index ix_userid on report_bpdelinquency (userid) 
;
create index ix_duedate on report_bpdelinquency (duedate) 
;
create index ix_billdate on report_bpdelinquency (billdate) 
;


CREATE TABLE report_bpdelinquency_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NULL,
  applicationid varchar(50) NULL,
  amount decimal(16,2) NULL,
  amtpaid decimal(16,2) NULL,
  surcharge decimal(16,2) NULL,
  interest decimal(16,2) NULL,
  balance decimal(16,2) NULL,
  total decimal(16,2) NULL,
  constraint pk_report_bpdelinquency_item PRIMARY KEY (objid) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_parentid on report_bpdelinquency_item (parentid) 
;
create index ix_applicationid on report_bpdelinquency_item (applicationid) 
;
*/

-- CREATE TABLE business_active_lob_history (
--   objid varchar(50) NOT NULL,
--   businessid varchar(50) NULL,
--   activeyear int NULL,
--   lobid varchar(50) NULL,
--   name varchar(255) NULL,
--   constraint pk_business_active_lob_history PRIMARY KEY (objid)
-- ) 
-- go
-- create index ix_businessid on business_active_lob_history (businessid)
-- go
-- create index ix_activeyear on business_active_lob_history (activeyear)
-- go
-- create index ix_lobid on business_active_lob_history (lobid) 
-- go
-- alter table business_active_lob_history 
--   add CONSTRAINT fk_business_active_lob_history_businessid 
--   FOREIGN KEY (businessid) REFERENCES business (objid) 
-- go 
-- alter table business_active_lob_history 
--   add CONSTRAINT fk_business_active_lob_history_lobid 
--   FOREIGN KEY (lobid) REFERENCES lob (objid) 
-- go 



-- CREATE TABLE business_active_lob_history_forprocess (
--   businessid varchar(50) NOT NULL,
--   constraint pk_business_active_lob_history_forprocess PRIMARY KEY (businessid)
-- ) 
-- go 


-- if object_id('dbo.vw_business_application_lob_retire', 'V') IS NOT NULL 
--   drop view dbo.vw_business_application_lob_retire; 
-- go 
-- create view vw_business_application_lob_retire AS 
-- select 
-- a.business_objid AS businessid, 
-- a.objid AS applicationid, 
-- a.appno AS appno, 
-- a.appyear AS appyear, 
-- a.dtfiled AS dtfiled, 
-- a.txndate AS txndate, 
-- a.tradename AS tradename, 
-- b.bin AS bin, 
-- alob.assessmenttype AS assessmenttype, 
-- alob.lobid AS lobid, 
-- alob.name AS lobname, 
-- a.objid AS refid, 
-- a.appno AS refno  
-- from business_application a 
--   inner join business_application_lob alob on alob.applicationid = a.objid 
--   inner join business b on b.objid = a.business_objid 
-- where alob.assessmenttype = 'RETIRE' 
--   and a.state = 'COMPLETED' 
--   and a.parentapplicationid is null 
-- union all 
-- select 
-- pa.business_objid AS businessid, 
-- pa.objid AS applicationid, 
-- pa.appno AS appno, 
-- pa.appyear AS appyear, 
-- pa.dtfiled AS dtfiled, 
-- pa.txndate AS txndate, 
-- pa.tradename AS tradename, 
-- b.bin AS bin, 
-- alob.assessmenttype AS assessmenttype, 
-- alob.lobid AS lobid, 
-- alob.name AS lobname, 
-- a.objid AS refid, 
-- a.appno AS refno  
-- from business_application a 
--   inner join business_application pa on pa.objid = a.parentapplicationid 
--   inner join business_application_lob alob on alob.applicationid = a.objid 
--   inner join business b on b.objid = pa.business_objid 
-- where alob.assessmenttype = 'RETIRE' 
--   and a.state = 'COMPLETED'
-- go 
