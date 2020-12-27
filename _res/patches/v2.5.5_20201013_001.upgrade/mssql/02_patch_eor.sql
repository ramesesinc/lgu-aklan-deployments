
update paymentpartner set code='101', indexno='101' where objid='DBP';
update paymentpartner set code='102', indexno='102' where objid='LBP';


CREATE TABLE epayment_plugin (
  objid varchar(50) NOT NULL,
  connection varchar(50) NULL,
  servicename varchar(255) NULL,
  constraint pk_epayment_plugin PRIMARY KEY (objid)
) 
go 

INSERT INTO epayment_plugin (objid, connection, servicename) VALUES ('bpls', 'bpls', 'OnlineBusinessBillingService');
INSERT INTO epayment_plugin (objid, connection, servicename) VALUES ('rptcol', 'rpt', 'OnlineLandTaxBillingService');
INSERT INTO epayment_plugin (objid, connection, servicename) VALUES ('rpttaxclearance', 'landtax', 'OnlineRealtyTaxClearanceService');


CREATE TABLE eor_for_email (
  objid varchar(50) NOT NULL,
  txndate datetime NULL,
  email varchar(255) NULL,
  mobileno varchar(50) NULL,
  state int NULL,
  dtsent datetime NULL,
  errmsg text NULL,
  constraint pk_eor_for_email PRIMARY KEY (objid)
) 
go 
create index ix_txndate on eor_for_email (txndate) 
go 
create index ix_state on eor_for_email (state) 
go 
create index ix_dtsent on eor_for_email (dtsent) 
go 


if object_id('dbo.ztmp_fix_eor', 'U') IS NOT NULL 
  drop table dbo.ztmp_fix_eor; 
go 
select eor.objid 
into dbo.ztmp_fix_eor 
from eor 
  left join eor_remittance r on r.objid = eor.remittanceid 
where r.objid is null 
go 
update eor set remittanceid = null where objid in ( 
  select objid from ztmp_fix_eor 
)
go 
drop table dbo.ztmp_fix_eor
go 


alter table eor add constraint fk_eor_remittanceid 
  foreign key (remittanceid) references eor_remittance (objid) 
go 
