CREATE TABLE online_business_application (
  objid varchar(50) NOT NULL,
  state varchar(20) NOT NULL,
  dtcreated datetime NOT NULL,
  createdby_objid varchar(50) NOT NULL,
  createdby_name varchar(100) NOT NULL,
  controlno varchar(25) NOT NULL,
  prevapplicationid varchar(50) NOT NULL,
  business_objid varchar(50) NOT NULL,
  appyear int NOT NULL,
  apptype varchar(20) NOT NULL,
  appdate date NOT NULL,
  lobs text NOT NULL,
  infos varchar(MAX) NOT NULL,
  requirements varchar(MAX) NOT NULL,
  step int NOT NULL DEFAULT '0',
  dtapproved datetime NULL,
  approvedby_objid varchar(50) NULL,
  approvedby_name varchar(150) NULL,
  approvedappno varchar(25) NULL,
  constraint pk_online_business_application PRIMARY KEY (objid)
) 
go 

create index ix_state on online_business_application (state)
go 
create index ix_dtcreated on online_business_application (dtcreated)
go 
create index ix_controlno on online_business_application (controlno)
go 
create index ix_prevapplicationid on online_business_application (prevapplicationid)
go 
create index ix_business_objid on online_business_application (business_objid)
go 
create index ix_appyear on online_business_application (appyear)
go 
create index ix_appdate on online_business_application (appdate)
go 
create index ix_dtapproved on online_business_application (dtapproved)
go 
create index ix_approvedby_objid on online_business_application (approvedby_objid)
go 
create index ix_approvedby_name on online_business_application (approvedby_name)
go 

alter table online_business_application add CONSTRAINT fk_online_business_application_business_objid 
  FOREIGN KEY (business_objid) REFERENCES business (objid) 
go 
alter table online_business_application add CONSTRAINT fk_online_business_application_prevapplicationid 
  FOREIGN KEY (prevapplicationid) REFERENCES business_application (objid) 
go 



CREATE VIEW vw_online_business_application AS 
select 
  oa.objid AS objid, 
  oa.state AS state, 
  oa.dtcreated AS dtcreated, 
  oa.createdby_objid AS createdby_objid, 
  oa.createdby_name AS createdby_name, 
  oa.controlno AS controlno, 
  oa.apptype AS apptype, 
  oa.appyear AS appyear, 
  oa.appdate AS appdate, 
  oa.prevapplicationid AS prevapplicationid, 
  oa.business_objid AS business_objid, 
  b.bin AS bin, 
  b.tradename AS tradename, 
  b.businessname AS businessname, 
  b.address_text AS address_text, 
  b.address_objid AS address_objid, 
  b.owner_name AS owner_name, 
  b.owner_address_text AS owner_address_text, 
  b.owner_address_objid AS owner_address_objid, 
  b.yearstarted AS yearstarted, 
  b.orgtype AS orgtype, 
  b.permittype AS permittype, 
  b.officetype AS officetype, 
  oa.step AS step 
from online_business_application oa 
  inner join business_application a on a.objid = oa.prevapplicationid 
  inner join business b on b.objid = a.business_objid
go 
