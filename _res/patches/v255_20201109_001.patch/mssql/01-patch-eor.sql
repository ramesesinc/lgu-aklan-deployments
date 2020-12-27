DROP TABLE eor_payment_error 
go 

CREATE TABLE eor_payment_error (
  objid varchar(50) NOT NULL,
  txndate datetime NOT NULL,
  paymentrefid varchar(50) NOT NULL,
  errmsg text NOT NULL,
  errdetail varchar(MAX) NULL,
  errcode int NULL,
  laststate int NULL,
  constraint pk_eor_payment_error PRIMARY KEY (objid)
) 
go 
create UNIQUE index ix_paymentrefid on eor_payment_error (paymentrefid)
go 
create index ix_txndate on eor_payment_error (txndate)
go 


CREATE TABLE eor_manual_post (
  objid varchar(50) NOT NULL,
  state varchar(10) NULL,
  paymentorderno varchar(50) NULL,
  amount decimal(16,4) NULL,
  txntype varchar(50) NULL,
  paymentpartnerid varchar(50) NULL,
  traceid varchar(50) NULL,
  tracedate datetime NULL,
  reason text NULL,
  createdby_objid varchar(50) NULL,
  createdby_name varchar(255) NULL,
  dtcreated datetime NULL,
  constraint pk_eor_manual_post PRIMARY KEY (objid)
) 
go 
create UNIQUE index uix_paymentorderno on eor_manual_post (paymentorderno)
go 
create index ix_state on eor_manual_post (state)
go 
create index ix_paymentorderno on eor_manual_post (paymentorderno) 
go 
create index ix_paymentpartnerid on eor_manual_post (paymentpartnerid) 
go 
create index ix_traceid on eor_manual_post (traceid) 
go 
create index ix_tracedate on eor_manual_post (tracedate) 
go 
create index ix_dtcreated on eor_manual_post (dtcreated) 
go 
create index ix_createdby_objid on eor_manual_post (createdby_objid) 
go 
create index ix_createdby_name on eor_manual_post (createdby_name) 
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



CREATE TABLE sys_email_template (
  objid varchar(50) NOT NULL,
  subject varchar(255) NOT NULL,
  message varchar(MAX) NOT NULL,
  constraint pk_sys_email_template PRIMARY KEY (objid)
) 
go 
