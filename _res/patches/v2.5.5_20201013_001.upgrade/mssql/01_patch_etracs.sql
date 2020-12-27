alter table rptpayment drop constraint fk_rptpayment_cashreceipt
go 

CREATE TABLE rptledger_redflag (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  caseno varchar(25) DEFAULT NULL,
  dtfiled datetime DEFAULT NULL,
  type varchar(25) NOT NULL,
  finding text,
  remarks text,
  blockaction varchar(25) DEFAULT NULL,
  filedby_objid varchar(50) DEFAULT NULL,
  filedby_name varchar(255) DEFAULT NULL,
  filedby_title varchar(50) DEFAULT NULL,
  resolvedby_objid varchar(50) DEFAULT NULL,
  resolvedby_name varchar(255) DEFAULT NULL,
  resolvedby_title varchar(50) DEFAULT NULL,
  dtresolved datetime DEFAULT NULL,
  constraint pk_rptledger_redflag PRIMARY KEY (objid)
) 
go 
create UNIQUE index uix_caseno on rptledger_redflag (caseno)
go 
create index ix_parent_objid on rptledger_redflag (parent_objid)
go 
create index ix_state on rptledger_redflag (state)
go 
create index ix_dtfiled on rptledger_redflag (dtfiled)
go 
create index ix_type on rptledger_redflag (type)
go 
create index ix_filedby_objid on rptledger_redflag (filedby_objid)
go 
create index ix_resolvedby_objid on rptledger_redflag (resolvedby_objid)
go 
create index ix_dtresolved on rptledger_redflag (dtresolved)
go 
alter table rptledger_redflag add CONSTRAINT fk_rptledger_redflag_filedby 
  FOREIGN KEY (filedby_objid) REFERENCES sys_user (objid)
go 
alter table rptledger_redflag add CONSTRAINT fk_rptledger_redflag_resolvedby 
  FOREIGN KEY (resolvedby_objid) REFERENCES sys_user (objid)
go 
alter table rptledger_redflag add CONSTRAINT fk_rptledger_redflag_rptledger 
  FOREIGN KEY (parent_objid) REFERENCES rptledger (objid)
go 


CREATE TABLE cashreceipt_plugin ( 
   objid varchar(50) NOT NULL, 
   connection varchar(150) NOT NULL, 
   servicename varchar(255) NOT NULL,
   CONSTRAINT pk_cashreceipt_plugin PRIMARY KEY (objid)
) 
go 

update cashreceipt_plugin set connection = objid where connection is null 
go 
