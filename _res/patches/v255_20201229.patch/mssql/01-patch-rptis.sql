/* 254032-03017*/

drop table rptbill_ledger_account
go
drop table rptbill_ledger_item
go 


/*================================================= 
*
*  PROVINCE-MUNI LEDGER SYNCHRONIZATION SUPPORT 
*
====================================================*/
CREATE TABLE rptledger_remote (
  objid nvarchar(50) NOT NULL,
  remote_objid nvarchar(50) NOT NULL,
  createdby_name nvarchar(255) NOT NULL,
  createdby_title nvarchar(100) DEFAULT NULL,
  dtcreated datetime NOT NULL,
  PRIMARY KEY (objid)
)
go 

alter table rptledger_remote 
add CONSTRAINT FK_rptledgerremote_rptledger FOREIGN KEY (objid) REFERENCES rptledger (objid)
go 





/*======================================
* AUTOMATIC MACH AV RECALC SUPPORT
=======================================*/
INSERT INTO rptparameter (objid, state, name, caption, description, paramtype, minvalue, maxvalue) 
VALUES ('TOTAL_VALUE', 'APPROVED', 'TOTAL_VALUE', 'TOTAL VALUE', '', 'decimal', '0', '0')
GO 



create table landtax_lgu_account_mapping (
  objid nvarchar(50) not null,
  lgu_objid nvarchar(50) not null,
  revtype nvarchar(50) not null,
  revperiod nvarchar(50) not null,
  item_objid nvarchar(50) not null
) 
go 

create index ix_objid on landtax_lgu_account_mapping(objid)
go 
create index fk_landtaxlguaccountmapping_sysorg on landtax_lgu_account_mapping(lgu_objid)
go 
create index fk_landtaxlguaccountmapping_itemaccount on landtax_lgu_account_mapping(item_objid)
go 
create index ix_revtype on landtax_lgu_account_mapping(revtype)
go 



 alter table landtax_lgu_account_mapping 
    add constraint fk_landtaxlguaccountmapping_itemaccount 
    foreign key (item_objid) references itemaccount (objid)
   go 

 alter table landtax_lgu_account_mapping 
    add constraint fk_landtaxlguaccountmapping_sysorg 
    foreign key (lgu_objid) references sys_org (objid)
   go 


delete from sys_rulegroup where ruleset = 'rptbilling' and name in ('before-misc-comp','misc-comp')
go 




/*======================================================
* rptledger payment
*=====================================================*/ 
create proc usp_droptable(
	@tablename nvarchar(50)
)
as 
if (exists(select * from sysobjects where id = object_id(@tablename)))
begin 
	exec ('drop table ' + @tablename)
end 
go 

exec usp_droptable 'cashreceiptitem_rpt_noledger'
go 

exec usp_droptable 'cashreceiptitem_rpt'
go 

exec usp_droptable 'rptledger_payment_share'
go 

exec usp_droptable 'rptledger_payment_item'
go 

exec usp_droptable 'rptledger_payment'
go 




create table rptledger_payment (
  objid nvarchar(100) not null,
  rptledgerid nvarchar(50) not null,
  type nvarchar(20) not null,
  receiptid nvarchar(50) null,
  receiptno nvarchar(50) not null,
  receiptdate date not null,
  paidby_name text not null,
  paidby_address nvarchar(150) not null,
  postedby nvarchar(100) not null,
  postedbytitle nvarchar(50) not null,
  dtposted datetime not null,
  fromyear int not null,
  fromqtr int not null,
  toyear int not null,
  toqtr int not null,
  amount decimal(12,2) not null,
  collectingagency nvarchar(50) default null,
  voided int not null,
  primary key (objid)
) 
go 


create index fk_rptledger_payment_rptledger on rptledger_payment(rptledgerid)
go 
create index fk_rptledger_payment_cashreceipt on rptledger_payment(receiptid)
go 
create index ix_receiptno on rptledger_payment(receiptno)
go 

alter table rptledger_payment 
add constraint fk_rptledger_payment_cashreceipt foreign key (receiptid) references cashreceipt (objid)
go 

alter table rptledger_payment 
add constraint fk_rptledger_payment_rptledger foreign key (rptledgerid) references rptledger (objid)
go 


create table rptledger_payment_item (
  objid nvarchar(50) not null,
  parentid nvarchar(100) not null,
  rptledgerfaasid nvarchar(50) default null,
  rptledgeritemid nvarchar(50) default null,
  rptledgeritemqtrlyid nvarchar(50) default null,
  year int not null,
  qtr int not null,
  basic decimal(16,2) not null,
  basicint decimal(16,2) not null,
  basicdisc decimal(16,2) not null,
  basicidle decimal(16,2) not null,
  basicidledisc decimal(16,2) default null,
  basicidleint decimal(16,2) default null,
  sef decimal(16,2) not null,
  sefint decimal(16,2) not null,
  sefdisc decimal(16,2) not null,
  firecode decimal(10,2) default null,
  sh decimal(16,2) not null,
  shint decimal(16,2) not null,
  shdisc decimal(16,2) not null,
  total decimal(16,2) default null,
  revperiod nvarchar(25) default null,
  partialled int not null,
  primary key (objid)
) 
go 

create index fk_rptledger_payment_item_parentid on rptledger_payment_item(parentid)
go 
create index fk_rptledger_payment_item_rptledgerfaasid on rptledger_payment_item(rptledgerfaasid)
go 
create index ix_rptledgeritemid on rptledger_payment_item(rptledgeritemid)
go 
create index ix_rptledgeritemqtrlyid on rptledger_payment_item(rptledgeritemqtrlyid)
go 


alter table rptledger_payment_item 
  add constraint fk_rptledger_payment_item_parentid 
  foreign key (parentid) references rptledger_payment (objid)
 go 
alter table rptledger_payment_item 
  add constraint fk_rptledger_payment_item_rptledgerfaasid 
  foreign key (rptledgerfaasid) references rptledgerfaas (objid)
 go 


create table rptledger_payment_share (
  objid nvarchar(50) not null,
  parentid nvarchar(100) null,
  revperiod nvarchar(25) not null,
  revtype nvarchar(25) not null,
  item_objid nvarchar(50) not null,
  amount decimal(16,4) not null,
  sharetype nvarchar(25) not null,
  discount decimal(16,4) null,
  primary key (objid)
)
go 

alter table rptledger_payment_share
  add constraint fk_rptledger_payment_share_parentid foreign key (parentid) 
  references rptledger_payment(objid)
 go 

alter table rptledger_payment_share
  add constraint fk_rptledger_payment_share_itemaccount foreign key (item_objid) 
  references itemaccount(objid)
 go 

create index fk_parentid on rptledger_payment_share(parentid)
go 
create index fk_item_objid on rptledger_payment_share(item_objid)
go 



insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  x.objid,
  x.rptledgerid,
  x.type,
  x.receiptid,
  x.receiptno,
  x.receiptdate,
  x.paidby_name,
  x.paidby_address,
  x.postedby,
  x.postedbytitle,
  x.dtposted,
  x.fromyear,
  (select min(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.fromyear) as fromqtr,
  x.toyear,
  (select max(qtr) from cashreceiptitem_rpt_online 
    where rptledgerid = x.rptledgerid and rptreceiptid = x.receiptid and year = x.toyear) as toqtr,
  x.amount,
  x.collectingagency,
  0 as voided
from (
  select
    (cro.rptledgerid + '-' + cr.objid) as objid,
    cro.rptledgerid,
    cr.txntype as type,
    cr.objid as receiptid,
    c.receiptno as receiptno,
    c.receiptdate as receiptdate,
    c.paidby as paidby_name,
    c.paidbyaddress as paidby_address,
    c.collector_name as postedby,
    c.collector_title as postedbytitle,
    c.txndate as dtposted,
    min(cro.year) as fromyear,
    max(cro.year) as toyear,
    sum(
      cro.basic + cro.basicint - cro.basicdisc + cro.sef + cro.sefint - cro.sefdisc + cro.firecode +
      cro.basicidle + cro.basicidleint - cro.basicidledisc
    ) as amount,
    null as collectingagency
  from cashreceipt_rpt cr 
  inner join cashreceipt c on cr.objid = c.objid 
  inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid
  left join cashreceipt_void cv on c.objid = cv.receiptid 
  where cv.objid is null 
  group by 
    cr.objid,
    cro.rptledgerid,
    cr.txntype,
    c.receiptno,
    c.receiptdate,
    c.paidby,
    c.paidbyaddress,
    c.collector_name,
    c.collector_title,
    c.txndate 
)x
go 


insert into rptledger_payment_item(
  objid,
  parentid,
  rptledgerfaasid,
  rptledgeritemid,
  rptledgeritemqtrlyid,
  year,
  qtr,
  basic,
  basicint,
  basicdisc,
  basicidle,
  basicidledisc,
  basicidleint,
  sef,
  sefint,
  sefdisc,
  firecode,
  sh,
  shint,
  shdisc,
  total,
  revperiod,
  partialled
)
select
  cro.objid,
  (cro.rptledgerid + '-' + cro.rptreceiptid) as parentid,
  cro.rptledgerfaasid,
  cro.rptledgeritemid,
  cro.rptledgeritemqtrlyid,
  cro.year,
  cro.qtr,
  cro.basic,
  cro.basicint,
  cro.basicdisc,
  cro.basicidle,
  cro.basicidledisc,
  cro.basicidleint,
  cro.sef,
  cro.sefint,
  cro.sefdisc,
  cro.firecode,
  0 as sh,
  0 as shint,
  0 as shdisc,
  cro.total,
  cro.revperiod,
  cro.partialled
from cashreceipt_rpt cr 
inner join cashreceipt c on cr.objid = c.objid 
inner join cashreceiptitem_rpt_online cro on c.objid = cro.rptreceiptid 
left join cashreceipt_void cv on c.objid = cv.receiptid 
where cv.objid is null 
go 





insert into rptledger_payment_share(
  objid,
  parentid,
  revperiod,
  revtype,
  item_objid,
  amount,
  sharetype,
  discount
)
select
  cra.objid,
  (cra.rptledgerid + '-' + cra.rptreceiptid) as parentid,
  cra.revperiod,
  cra.revtype,
  cra.item_objid,
  cra.amount,
  cra.sharetype,
  cra.discount
from cashreceipt_rpt cr 
inner join cashreceipt c on cr.objid = c.objid 
inner join cashreceiptitem_rpt_account cra on c.objid = cra.rptreceiptid 
left join cashreceipt_void cv on c.objid = cv.receiptid 
where cv.objid is null 
go 




insert into rptledger_payment(
  objid,
  rptledgerid,
  type,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided 
)
select 
  objid,
  rptledgerid,
  type,
  null as receiptid,
  refno as receiptno,
  refdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  (basic + basicint - basicdisc + sef + sefint - sefdisc + basicidle + firecode) as amount,
  collectingagency,
  0 as voided 
from rptledger_credit
go 


alter table rptledgeritem add sh decimal(16,2)
go 
alter table rptledgeritem add shdisc decimal(16,2)
go 
alter table rptledgeritem add shpaid decimal(16,2)
go 
alter table rptledgeritem add shint decimal(16,2)
go 

update rptledgeritem set 
    sh = 0, shdisc=0, shpaid = 0, shint = 0
where sh is null 
go 



alter table rptledgeritem_qtrly add sh decimal(16,2)
go 
alter table rptledgeritem_qtrly add shdisc decimal(16,2)
go 
alter table rptledgeritem_qtrly add shpaid decimal(16,2)
go 
alter table rptledgeritem_qtrly add shint decimal(16,2)
go 

update rptledgeritem_qtrly set 
    sh = 0, shdisc=0, shpaid = 0, shint = 0
where sh is null 
go 




alter table rptledger_compromise_item add sh decimal(16,2)
go 
alter table rptledger_compromise_item add shpaid decimal(16,2)
go 
alter table rptledger_compromise_item add shint decimal(16,2)
go 
alter table rptledger_compromise_item add shintpaid decimal(16,2)
go 

update rptledger_compromise_item set 
    sh = 0, shpaid = 0, shint = 0, shintpaid = 0
where sh is null 
go 


alter table rptledger_compromise_item_credit add sh decimal(16,2)
go 
alter table rptledger_compromise_item_credit add shint decimal(16,2)
go 

update rptledger_compromise_item_credit set 
    sh = 0, shint = 0
where sh is null
go 


drop proc usp_droptable
go 
/* 254032-03019 */

/*==================================================
*
*  CDU RATING SUPPORT 
*
=====================================================*/

alter table bldgrpu add cdurating varchar(15)
go 

alter table bldgtype add usecdu int
go 
update bldgtype set usecdu = 0 where usecdu is null
go 


alter table bldgtype_depreciation add excellent decimal(16,2)
go 
alter table bldgtype_depreciation add verygood decimal(16,2)
go 
alter table bldgtype_depreciation add good decimal(16,2)
go 
alter table bldgtype_depreciation add average decimal(16,2)
go 
alter table bldgtype_depreciation add fair decimal(16,2)
go 
alter table bldgtype_depreciation add poor decimal(16,2)
go 
alter table bldgtype_depreciation add verypoor decimal(16,2)
go 
alter table bldgtype_depreciation add unsound decimal(16,2)
go 


alter table batchgr_error drop column barangayid
go 
alter table batchgr_error drop column barangay
go 
alter table batchgr_error drop column tdno
go 


create view vw_batchgr_error 
as 
select 
    err.*,
		f.tdno,
    f.prevtdno, 
    f.fullpin as fullpin, 
    rp.pin as pin,
		b.name as barangay,
		o.name as lguname
from batchgr_error err 
inner join faas f on err.objid = f.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join barangay b on rp.barangayid = b.objid 
inner join sys_org o on f.lguid = o.objid
go 






/*=============================================================
*
* SKETCH 
*
==============================================================*/
CREATE TABLE faas_sketch (
  objid nvarchar(50) NOT NULL DEFAULT '',
  drawing text NOT NULL,
  PRIMARY KEY (objid)
)
go 



create index FK_faas_sketch_faas  on faas_sketch(objid)
go 

alter table faas_sketch 
  add constraint FK_faas_sketch_faas foreign key(objid) 
  references faas(objid)
go   



  
/*=============================================================
*
* CUSTOM RPU SUFFIX SUPPORT
*
==============================================================*/  

CREATE TABLE rpu_type_suffix (
  objid varchar(50) NOT NULL,
  rputype varchar(20) NOT NULL,
  [from] int NOT NULL,
  [to] int NOT NULL,
  PRIMARY KEY (objid)
) 
go 


insert into rpu_type_suffix (
  objid, rputype, [from], [to]
)
select 'LAND', 'land', 0, 0
union 
select 'BLDG-1001-1999', 'bldg', 1001, 1999
union 
select 'MACH-2001-2999', 'mach', 2001, 2999
union 
select 'PLANTTREE-3001-6999', 'planttree', 3001, 6999
union 
select 'MISC-7001-7999', 'misc', 7001, 7999
go 





/*=============================================================
*
* MEMORANDA TEMPLATE UPDATE 
*
==============================================================*/  
alter table memoranda_template add fields text
go 

update memoranda_template set fields = '[]' where fields is null
go 


/* 254032-03019.01 */

/*==================================================
*
*  BATCH GR UPDATES
*
=====================================================*/
drop table batchgr_error
go 
drop table batchgr_items_forrevision
go 
drop table batchgr_log
go 
drop view vw_batchgr_error
go 

/* 254032-03019.02 */

/*==============================================
* EXAMINATION UPDATES
==============================================*/

alter table examiner_finding add inspectedby_objid nvarchar(50)
go 
alter table examiner_finding add inspectedby_name nvarchar(100)
go 
alter table examiner_finding add inspectedby_title nvarchar(50)
go 
alter table examiner_finding add doctype nvarchar(50)
go 

create index ix_examiner_finding_inspectedby_objid on examiner_finding(inspectedby_objid)
go 


update e set 
	e.inspectedby_objid = (select top 1 assignee_objid from faas_task where refid = f.objid and state = 'examiner' order by enddate desc),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'faas'
from examiner_finding e, faas f
where e.parent_objid = f.objid
go 

update e set 
	e.inspectedby_objid = (select top 1 assignee_objid from subdivision_task where refid = s.objid and state = 'examiner' order by enddate desc),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'subdivision'
from examiner_finding e, subdivision s	
where e.parent_objid = s.objid
go 

update e set 
	e.inspectedby_objid = (select top 1 assignee_objid from consolidation_task where refid = c.objid and state = 'examiner' order by enddate desc),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'consolidation'
from  examiner_finding e, consolidation c	
where e.parent_objid = c.objid
go 

update e set 
	e.inspectedby_objid = (select top 1 assignee_objid from cancelledfaas_task where refid = c.objid and state = 'examiner' order by enddate desc),
	e.inspectedby_name = e.notedby,
	e.inspectedby_title = e.notedbytitle,
	e.doctype = 'cancelledfaas'
from examiner_finding e, cancelledfaas c	
where e.parent_objid = c.objid
go 



/*=============================================================== 	
* Use the script below to manually update the inspectedby_objid
* field for inspection done after the record has been approved.
*
* This query returns the list of examiners 
* with inspectedby_objid field not yet set.
* For each result, update the inspectedby_objid 
* by setting the firstname, lastname and notedby values
* in the query "-- update inspectedby_userid field"
*
*
*  select distinct notedby from examiner_finding 
*  where inspectedby_objid is null
go 
*
================================================================*/

-- update inspectedby_userid field
update examiner_finding set 
	inspectedby_objid = (select objid from sys_user where firstname like 'mirasol%' and lastname like 'gaspar%')
where inspectedby_objid is null 
and notedby like 'MIRASOL%GASPAR%'
go 







/*======================================================
*
*  TAX CLEARANCE UPDATE
*
======================================================*/

alter table rpttaxclearance add reporttype nvarchar(15)
GO 

update rpttaxclearance set reporttype = 'fullypaid' where reporttype is null
go 	





/*REVENUE PARENT ACCOUNTS  */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE', 'ACTIVE', '588-007', 'RPT BASIC ADVANCE', 'RPT BASIC ADVANCE', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT', 'ACTIVE', '588-001', 'RPT BASIC CURRENT', 'RPT BASIC CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT', 'ACTIVE', '588-004', 'RPT BASIC PENALTY CURRENT', 'RPT BASIC PENALTY CURRENT', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS', 'ACTIVE', '588-002', 'RPT BASIC PREVIOUS', 'RPT BASIC PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS', 'ACTIVE', '588-005', 'RPT BASIC PENALTY PREVIOUS', 'RPT BASIC PENALTY PREVIOUS', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR', 'ACTIVE', '588-003', 'RPT BASIC PRIOR', 'RPT BASIC PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR', 'ACTIVE', '588-006', 'RPT BASIC PENALTY PRIOR', 'RPT BASIC PENALTY PRIOR', 'REVENUE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_ADVANCE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE', 'RPT SEF ADVANCE', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_CURRENT', 'ACTIVE', '455-050', 'RPT SEF CURRENT', 'RPT SEF CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_CURRENT', 'ACTIVE', '455-050', 'RPT SEF PENALTY CURRENT', 'RPT SEF PENALTY CURRENT', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS', 'RPT SEF PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PREVIOUS', 'ACTIVE', '455-050', 'RPT SEF PENALTY PREVIOUS', 'RPT SEF PENALTY PREVIOUS', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEF_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PRIOR', 'RPT SEF PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_SEFINT_PRIOR', 'ACTIVE', '455-050', 'RPT SEF PENALTY PRIOR', 'RPT SEF PENALTY PRIOR', 'REVENUE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go





insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE' as objid, 'RPT_BASIC_ADVANCE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT' as objid, 'RPT_BASIC_CURRENT' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT' as objid, 'RPT_BASICINT_CURRENT' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS' as objid, 'RPT_BASIC_PREVIOUS' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS' as objid, 'RPT_BASICINT_PREVIOUS' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR' as objid, 'RPT_BASIC_PRIOR' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR' as objid, 'RPT_BASICINT_PRIOR' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE' as objid, 'RPT_SEF_ADVANCE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT' as objid, 'RPT_SEF_CURRENT' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT' as objid, 'RPT_SEFINT_CURRENT' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS' as objid, 'RPT_SEF_PREVIOUS' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS' as objid, 'RPT_SEFINT_PREVIOUS' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR' as objid, 'RPT_SEF_PRIOR' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR' as objid, 'RPT_SEFINT_PRIOR' as acctid, 'rpt_sefint_prior' as tag
go





/* BARANGAY SHARE PAYABLE */

INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_ADVANCE_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE BARANGAY SHARE', 'RPT BASIC ADVANCE BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT BARANGAY SHARE', 'RPT BASIC CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_CURRENT_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'RPT BASIC PENALTY CURRENT BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'RPT BASIC PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PREVIOUS_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'RPT BASIC PENALTY PREVIOUS BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASIC_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR BARANGAY SHARE', 'RPT BASIC PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO itemaccount (objid, state, code, title, description, type, fund_objid, fund_code, fund_title, defaultvalue, valuetype, org_objid, org_name, parentid) VALUES ('RPT_BASICINT_PRIOR_BRGY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'RPT BASIC PENALTY PRIOR BARANGAY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_BRGY_SHARE' as objid, 'RPT_BASIC_ADVANCE_BRGY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_BRGY_SHARE' as objid, 'RPT_BASIC_CURRENT_BRGY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_BRGY_SHARE' as objid, 'RPT_BASICINT_CURRENT_BRGY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_BRGY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_BRGY_SHARE' as objid, 'RPT_BASIC_PRIOR_BRGY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_BRGY_SHARE' as objid, 'RPT_BASICINT_PRIOR_BRGY_SHARE' as acctid, 'rpt_basicint_prior' as tag
go






/* MUNICIPALITY SHARE PAYABLE */

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC ADVANCE MUNICIPALITY SHARE', 'RPT BASIC ADVANCE MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT MUNICIPALITY SHARE', 'RPT BASIC CURRENT MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC CURRENT PENALTY MUNICIPALITY SHARE', 'RPT BASIC CURRENT PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS MUNICIPALITY SHARE', 'RPT BASIC PREVIOUS MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PREVIOUS PENALTY MUNICIPALITY SHARE', 'RPT BASIC PREVIOUS PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASIC_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR MUNICIPALITY SHARE', 'RPT BASIC PRIOR MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-049', 'RPT BASIC PRIOR PENALTY MUNICIPALITY SHARE', 'RPT BASIC PRIOR PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'GENERAL', '01', 'GENERAL', '0.00', 'ANY', NULL, NULL, NULL)
go

INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_ADVANCE_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF ADVANCE MUNICIPALITY SHARE', 'RPT SEF ADVANCE MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT MUNICIPALITY SHARE', 'RPT SEF CURRENT MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF CURRENT PENALTY MUNICIPALITY SHARE', 'RPT SEF CURRENT PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS MUNICIPALITY SHARE', 'RPT SEF PREVIOUS MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PREVIOUS PENALTY MUNICIPALITY SHARE', 'RPT SEF PREVIOUS PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEF_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR MUNICIPALITY SHARE', 'RPT SEF PRIOR MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go
INSERT INTO `itemaccount` (`objid`, `state`, `code`, `title`, `description`, `type`, `fund_objid`, `fund_code`, `fund_title`, `defaultvalue`, `valuetype`, `org_objid`, `org_name`, `parentid`) 
VALUES ('RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE', 'ACTIVE', '455-050', 'RPT SEF PRIOR PENALTY MUNICIPALITY SHARE', 'RPT SEF PRIOR PENALTY MUNICIPALITY SHARE', 'PAYABLE', 'SEF', '02', 'SEF', '0.00', 'ANY', NULL, NULL, NULL)
go



insert into itemaccount_tag (objid, acctid, tag)
select  'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_advance' as tag
union 
select  'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_current' as tag
union 
select  'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_current' as tag
union 
select  'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_previous' as tag
union 
select  'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_previous' as tag
union 
select  'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_basic_prior' as tag
union 
select  'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_basicint_prior' as tag
union 
select  'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_advance' as tag
union 
select  'RPT_SEF_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_current' as tag
union 
select  'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_current' as tag
union 
select  'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_previous' as tag
union 
select  'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_previous' as tag
union 
select  'RPT_SEF_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_SEF_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_sef_prior' as tag
union 
select  'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE' as objid, 'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE' as acctid, 'rpt_sefint_prior' as tag
go






/*===============================================================
*
* SET PARENT OF PROVINCE  ACCOUNTS
*
===============================================================*/


-- advance account 
update i set 
	i.parentid = 'RPT_BASIC_ADVANCE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basicadvacct_objid = i.objid 
and p.objid = o.objid
go


-- current account
update i set 
	i.parentid = 'RPT_BASIC_CURRENT', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basiccurracct_objid = i.objid 
and p.objid = o.objid
go

-- current int account
update i set 
	i.parentid = 'RPT_BASICINT_CURRENT', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basiccurrintacct_objid = i.objid 
and p.objid = o.objid
go



-- previous account
update i set 
	i.parentid = 'RPT_BASIC_PREVIOUS', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basicprevacct_objid = i.objid 
and p.objid = o.objid
go



-- prevint account
update i set 
	i.parentid = 'RPT_BASICINT_PREVIOUS', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basicprevintacct_objid = i.objid 
and p.objid = o.objid
go


-- prior account
update i set 
	i.parentid = 'RPT_BASIC_PRIOR', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basicprioracct_objid = i.objid 
and p.objid = o.objid
go

-- priorint account
update i set 
	i.parentid = 'RPT_BASICINT_PRIOR', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.basicpriorintacct_objid = i.objid 
and p.objid = o.objid
go




-- advance account 
update i set 
	i.parentid = 'RPT_SEF_ADVANCE', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefadvacct_objid = i.objid 
and p.objid = o.objid
go


-- current account
update i set 
	i.parentid = 'RPT_SEF_CURRENT', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefcurracct_objid = i.objid 
and p.objid = o.objid
go

-- current int account
update i set 
	i.parentid = 'RPT_SEFINT_CURRENT', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefcurrintacct_objid = i.objid 
and p.objid = o.objid
go



-- previous account
update i set 
	i.parentid = 'RPT_SEF_PREVIOUS', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefprevacct_objid = i.objid 
and p.objid = o.objid
go



-- prevint account
update i set 
	i.parentid = 'RPT_SEFINT_PREVIOUS', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefprevintacct_objid = i.objid 
and p.objid = o.objid
go


-- prior account
update i set 
	i.parentid = 'RPT_SEF_PRIOR', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefprioracct_objid = i.objid 
and p.objid = o.objid
go

-- priorint account
update i set 
	i.parentid = 'RPT_SEFINT_PRIOR', 
	i.org_objid = p.objid,
	i.org_name = o.name 
from itemaccount i, province_taxaccount_mapping p, sys_org o
where p.sefpriorintacct_objid = i.objid 
and p.objid = o.objid
go






/*===============================================================
*
* SET PARENT OF MUNICIPALITY ACCOUNTS
*
===============================================================*/

-- advance account 
update i set 
	i.parentid = 'RPT_BASIC_ADVANCE_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basicadvacct_objid = i.objid 
and p.lguid = o.objid
go


-- current account
update i set 
	i.parentid = 'RPT_BASIC_CURRENT_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basiccurracct_objid = i.objid 
and p.lguid = o.objid
go

-- current int account
update i set 
	i.parentid = 'RPT_BASICINT_CURRENT_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basiccurrintacct_objid = i.objid 
and p.lguid = o.objid
go



-- previous account
update i set 
	i.parentid = 'RPT_BASIC_PREVIOUS_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basicprevacct_objid = i.objid 
and p.lguid = o.objid
go



-- prevint account
update i set 
	i.parentid = 'RPT_BASICINT_PREVIOUS_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basicprevintacct_objid = i.objid 
and p.lguid = o.objid
go


-- prior account
update i set 
	i.parentid = 'RPT_BASIC_PRIOR_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basicprioracct_objid = i.objid 
and p.lguid = o.objid
go

-- priorint account
update i set 
	i.parentid = 'RPT_BASICINT_PRIOR_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.basicpriorintacct_objid = i.objid 
and p.lguid = o.objid
go




-- advance account 
update i set 
	i.parentid = 'RPT_SEF_ADVANCE_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefadvacct_objid = i.objid 
and p.lguid = o.objid
go


-- current account
update i set 
	i.parentid = 'RPT_SEF_CURRENT_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefcurracct_objid = i.objid 
and p.lguid = o.objid
go

-- current int account
update i set 
	i.parentid = 'RPT_SEFINT_CURRENT_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefcurrintacct_objid = i.objid 
and p.lguid = o.objid
go



-- previous account
update i set 
	i.parentid = 'RPT_SEF_PREVIOUS_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefprevacct_objid = i.objid 
and p.lguid = o.objid
go



-- prevint account
update i set 
	i.parentid = 'RPT_SEFINT_PREVIOUS_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefprevintacct_objid = i.objid 
and p.lguid = o.objid
go


-- prior account
update i set 
	i.parentid = 'RPT_SEF_PRIOR_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefprioracct_objid = i.objid 
and p.lguid = o.objid
go

-- priorint account
update i set 
	i.parentid = 'RPT_SEFINT_PRIOR_MUNICIPALITY_SHARE', 
	i.org_objid = p.lguid,
	i.org_name = o.name 
from itemaccount i, municipality_taxaccount_mapping p, sys_org o
where p.sefpriorintacct_objid = i.objid 
and p.lguid = o.objid
go




/*===============================================================
*
* SET PARENT OF BARANGAY ACCOUNTS
*
===============================================================*/

-- advance account 
update i set 
	i.parentid = 'RPT_BASIC_ADVANCE_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basicadvacct_objid = i.objid 
and m.barangayid = o.objid
go


-- current account
update i set 
	i.parentid = 'RPT_BASIC_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basiccurracct_objid = i.objid 
and m.barangayid = o.objid
go

-- current int account
update i set 
	i.parentid = 'RPT_BASICINT_CURRENT_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basiccurrintacct_objid = i.objid 
and m.barangayid = o.objid
go



-- previous account
update i set 
	i.parentid = 'RPT_BASIC_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basicprevacct_objid = i.objid 
and m.barangayid = o.objid
go



-- prevint account
update i set 
	i.parentid = 'RPT_BASICINT_PREVIOUS_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basicprevintacct_objid = i.objid 
and m.barangayid = o.objid
go


-- prior account
update i set 
	i.parentid = 'RPT_BASIC_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basicprioracct_objid = i.objid 
and m.barangayid = o.objid
go

-- priorint account
update i set 
	i.parentid = 'RPT_BASICINT_PRIOR_BRGY_SHARE', 
	i.org_objid = m.barangayid,
	i.org_name = o.name 
from itemaccount i, brgy_taxaccount_mapping m, sys_org o	
where m.basicpriorintacct_objid = i.objid 
and m.barangayid = o.objid
go







/*============================================================
*
* 254032-03020
*
=============================================================*/
update cashreceiptitem_rpt_account set discount= 0 where discount is null
go 

alter table rptledger add lguid nvarchar(50)
go 

update rl set 
  rl.lguid = m.objid 
from rptledger rl, barangay b, sys_org m
where rl.barangayid = b.objid 
and b.parentid = m.objid 
and m.orgclass = 'municipality'
go 


update rl set 
  rl.lguid = c.objid
from rptledger rl, barangay b, sys_org d, sys_org c  
where rl.barangayid = b.objid 
and b.parentid = d.objid 
and d.parent_objid = c.objid 
and d.orgclass = 'district'
go 





create table rptpayment (
  objid nvarchar(100) not null,
  type nvarchar(50) default null,
  refid nvarchar(50) not null,
  reftype nvarchar(50) not null,
  receiptid nvarchar(50) default null,
  receiptno nvarchar(50) not null,
  receiptdate date not null,
  paidby_name text not null,
  paidby_address nvarchar(150) not null,
  postedby nvarchar(100) not null,
  postedbytitle nvarchar(50) not null,
  dtposted datetime not null,
  fromyear int not null,
  fromqtr int not null,
  toyear int not null,
  toqtr int not null,
  amount decimal(12,2) not null,
  collectingagency nvarchar(50) default null,
  voided int not null,
  primary key(objid)
)
go 

create index fk_rptpayment_cashreceipt on rptpayment(receiptid)
go 
create index ix_refid on rptpayment(refid)
go 
create index ix_receiptno on rptpayment(receiptno)
go 

alter table rptpayment 
  add constraint fk_rptpayment_cashreceipt 
  foreign key (receiptid) references cashreceipt (objid)
go 

  



create table rptpayment_item (
  objid nvarchar(50) not null,
  parentid nvarchar(100) not null,
  rptledgerfaasid nvarchar(50) default null,
  year int not null,
  qtr int default null,
  revtype nvarchar(50) not null,
  revperiod nvarchar(25) default null,
  amount decimal(16,2) not null,
  interest decimal(16,2) not null,
  discount decimal(16,2) not null,
  partialled int not null,
  priority int not null,
  primary key (objid)
)
go 

create index fk_rptpayment_item_parentid on rptpayment_item (parentid)
go   
create index fk_rptpayment_item_rptledgerfaasid on rptpayment_item (rptledgerfaasid)
go   

alter table rptpayment_item
  add constraint rptpayment_item_rptledgerfaas foreign key (rptledgerfaasid) 
  references rptledgerfaas (objid)
go   

alter table rptpayment_item
  add constraint rptpayment_item_rptpayment foreign key (parentid) 
  references rptpayment (objid)
go   





create table rptpayment_share (
  objid nvarchar(50) not null,
  parentid nvarchar(100) default null,
  revperiod nvarchar(25) not null,
  revtype nvarchar(25) not null,
  sharetype nvarchar(25) not null,
  item_objid nvarchar(50) not null,
  amount decimal(16,4) not null,
  discount decimal(16,4) default null,
  primary key (objid)
)
go 

create index fk_rptpayment_share_parentid on rptpayment_share(parentid)
go   
create index fk_rptpayment_share_item_objid on  rptpayment_share(item_objid)
go   

alter table rptpayment_share add constraint rptpayment_share_itemaccount 
  foreign key (item_objid) references itemaccount (objid)
go   

alter table rptpayment_share add constraint rptpayment_share_rptpayment 
  foreign key (parentid) references rptpayment (objid)
go   





insert into rptpayment(
  objid,
  type,
  refid,
  reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
)
select
  objid,
  type, 
  rptledgerid as refid,
  'rptledger' as reftype,
  receiptid,
  receiptno,
  receiptdate,
  paidby_name,
  paidby_address,
  postedby,
  postedbytitle,
  dtposted,
  fromyear,
  fromqtr,
  toyear,
  toqtr,
  amount,
  collectingagency,
  voided
from rptledger_payment
go 


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basic') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basic' as revtype,
  revperiod,
  basic as amount,
  basicint as interest,
  basicdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item
go 





insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sef') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sef' as revtype,
  revperiod,
  sef as amount,
  sefint as interest,
  sefdisc as discount,
  partialled,
  10000 as priority
from rptledger_payment_item
go 


insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-sh') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'sh' as revtype,
  revperiod,
  sh as amount,
  shint as interest,
  shdisc as discount,
  partialled,
  100 as priority
from rptledger_payment_item
where sh > 0
go 




insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-firecode') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'firecode' as revtype,
  revperiod,
  firecode as amount,
  0 as interest,
  0 as discount,
  partialled,
  50 as priority
from rptledger_payment_item
where firecode > 0
go 



insert into rptpayment_item(
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revtype,
  revperiod,
  amount,
  interest,
  discount,
  partialled,
  priority
)
select
  concat(objid, '-basicidle') as objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  'basicidle' as revtype,
  revperiod,
  basicidle as amount,
  basicidleint as interest,
  basicidledisc as discount,
  partialled,
  200 as priority
from rptledger_payment_item
where basicidle > 0
go 



update cashreceipt_rpt set txntype = 'online' where txntype = 'rptonline'
go 
update cashreceipt_rpt set txntype = 'manual' where txntype = 'rptmanual'
go 
update cashreceipt_rpt set txntype = 'compromise' where txntype = 'rptcompromise'
go 

update rptpayment set type = 'online' where type = 'rptonline'
go 
update rptpayment set type = 'manual' where type = 'rptmanual'
go 
update rptpayment set type = 'compromise' where type = 'rptcompromise'
go 


  
create table landtax_report_rptdelinquency (
  objid nvarchar(50) not null,
  rptledgerid nvarchar(50) not null,
  barangayid nvarchar(50) not null,
  year int not null,
  qtr int null,
  revtype nvarchar(50) not null,
  amount decimal(16,2) not null,
  interest decimal(16,2) not null,
  discount decimal(16,2) not null,
  dtgenerated datetime not null, 
  generatedby_name nvarchar(255) not null,
  generatedby_title nvarchar(100) not null,
  primary key (objid)
)
go 




create view vw_rptpayment_item_detail as
select
  objid,
  parentid,
  rptledgerfaasid,
  year,
  qtr,
  revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled 
from rptpayment_item rpi
go 




create view vw_rptpayment_item as
select 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled
from vw_rptpayment_item_detail x
group by 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod
go 


create view vw_landtax_report_rptdelinquency_detail 
as
select
  objid,
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from landtax_report_rptdelinquency
go 



create view vw_landtax_report_rptdelinquency
as
select
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title,
  sum(basic) as basic,
  sum(basicint) as basicint,
  sum(basicdisc) as basicdisc,
  sum(basicdp) as basicdp,
  sum(basicnet) as basicnet,
  sum(basicidle) as basicidle,
  sum(basicidleint) as basicidleint,
  sum(basicidledisc) as basicidledisc,
  sum(basicidledp) as basicidledp,
  sum(basicidlenet) as basicidlenet,
  sum(sef) as sef,
  sum(sefint) as sefint,
  sum(sefdisc) as sefdisc,
  sum(sefdp) as sefdp,
  sum(sefnet) as sefnet,
  sum(firecode) as firecode,
  sum(firecodeint) as firecodeint,
  sum(firecodedisc) as firecodedisc,
  sum(firecodedp) as firecodedp,
  sum(firecodenet) as firecodenet,
  sum(sh) as sh,
  sum(shint) as shint,
  sum(shdisc) as shdisc,
  sum(shdp) as shdp,
  sum(shnet) as shnet,
  sum(total) as total
from vw_landtax_report_rptdelinquency_detail
group by 
  rptledgerid,
  barangayid,
  year,
  qtr,
  dtgenerated,
  generatedby_name,
  generatedby_title
go 






create table rptledger_item (
  objid nvarchar(50) not null,
  parentid nvarchar(50) not null,
  rptledgerfaasid nvarchar(50) default null,
  remarks nvarchar(100) default null,
  basicav decimal(16,2) not null,
  sefav decimal(16,2) not null,
  av decimal(16,2) not null,
  revtype nvarchar(50) not null,
  year int not null,
  amount decimal(16,2) not null,
  amtpaid decimal(16,2) not null,
  priority int not null,
  taxdifference int not null,
  system int not null,
  primary key (objid)
) 
go 

create index fk_rptledger_item_rptledger on rptledger_item (parentid)
go  

alter table rptledger_item 
  add constraint fk_rptledger_item_rptledger foreign key (parentid) 
  references rptledger (objid)
go 




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basic') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  isnull(rli.basicav, rli.av),
  isnull(rli.sefav, rli.av),
  rli.av,
  'basic' as revtype,
  rli.year,
  rli.basic as amount,
  rli.basicpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basic > 0 
and rli.basicpaid < rli.basic
go 




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sef') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  isnull(rli.basicav, rli.av),
  isnull(rli.sefav, rli.av),
  rli.av,
  'sef' as revtype,
  rli.year,
  rli.sef as amount,
  rli.sefpaid as amtpaid,
  10000 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sef > 0 
and rli.sefpaid < rli.sef
go 




insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-firecode') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  isnull(rli.basicav, rli.av),
  isnull(rli.sefav, rli.av),
  rli.av,
  'firecode' as revtype,
  rli.year,
  rli.firecode as amount,
  rli.firecodepaid as amtpaid,
  1 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.firecode > 0 
and rli.firecodepaid < rli.firecode
go 



insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-basicidle') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  isnull(rli.basicav, rli.av),
  isnull(rli.sefav, rli.av),
  rli.av,
  'basicidle' as revtype,
  rli.year,
  rli.basicidle as amount,
  rli.basicidlepaid as amtpaid,
  5 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.basicidle > 0 
and rli.basicidlepaid < rli.basicidle
go 


insert into rptledger_item (
  objid,
  parentid,
  rptledgerfaasid,
  remarks,
  basicav,
  sefav,
  av,
  revtype,
  year,
  amount,
  amtpaid,
  priority,
  taxdifference,
  system
)
select 
  concat(rli.objid, '-sh') as objid,
  rli.rptledgerid as parentid,
  rli.rptledgerfaasid,
  rli.remarks,
  isnull(rli.basicav, rli.av),
  isnull(rli.sefav, rli.av),
  rli.av,
  'sh' as revtype,
  rli.year,
  rli.sh as amount,
  rli.shpaid as amtpaid,
  10 as priority,
  rli.taxdifference,
  0 as system
from rptledgeritem rli 
  inner join rptledger rl on rli.rptledgerid = rl.objid 
where rl.state = 'APPROVED' 
and rli.sh > 0 
and rli.shpaid < rli.sh
go 





/*====================================================================================
*
* RPTLEDGER AND RPTBILLING RULE SUPPORT 
*
======================================================================================*/

declare @ruleset nvarchar(50)
select @ruleset = 'rptledger' 


delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
)

delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
)

delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule where ruleset=@ruleset 

delete from sys_ruleset_fact where ruleset=@ruleset

delete from sys_ruleset_actiondef where ruleset=@ruleset

delete from sys_rulegroup where ruleset=@ruleset 

delete from sys_ruleset where name=@ruleset 
go 


declare @ruleset nvarchar(50)
select @ruleset = 'rptbilling' 


delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
)

delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
)

delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule where ruleset=@ruleset 

delete from sys_ruleset_fact where ruleset=@ruleset

delete from sys_ruleset_actiondef where ruleset=@ruleset

delete from sys_rulegroup where ruleset=@ruleset 

delete from sys_ruleset where name=@ruleset 
go 





INSERT INTO sys_ruleset (name, title, packagename, domain, role, permission) VALUES ('rptbilling', 'RPT Billing Rules', 'rptbilling', 'LANDTAX', 'RULE_AUTHOR', NULL)
go 
INSERT INTO sys_ruleset (name, title, packagename, domain, role, permission) VALUES ('rptledger', 'Ledger Billing Rules', 'rptledger', 'LANDTAX', 'RULE_AUTHOR', NULL)
go 


INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('LEDGER_ITEM', 'rptledger', 'Ledger Item Posting', '1')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('TAX', 'rptledger', 'Tax Computation', '2')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER_TAX', 'rptledger', 'Post Tax Computation', '3')
go 


INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('INIT', 'rptbilling', 'Init', '0')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('DISCOUNT', 'rptbilling', 'Discount Computation', '9')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER_DISCOUNT', 'rptbilling', 'After Discount Computation', '10')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('PENALTY', 'rptbilling', 'Penalty Computation', '7')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER_PENALTY', 'rptbilling', 'After Penalty Computation', '8')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('BEFORE_SUMMARY', 'rptbilling', 'Before Summary ', '19')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('SUMMARY', 'rptbilling', 'Summary', '20')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('AFTER_SUMMARY', 'rptbilling', 'After Summary', '21')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('BRGY_SHARE', 'rptbilling', 'Barangay Share Computation', '25')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('PROV_SHARE', 'rptbilling', 'Province Share Computation', '27')
go 
INSERT INTO sys_rulegroup (name, ruleset, title, sortorder) VALUES ('LGU_SHARE', 'rptbilling', 'LGU Share Computation', '26')
go 




create view vw_landtax_lgu_account_mapping
as 
select 
  ia.org_objid as org_objid,
  ia.org_name as org_name, 
  o.orgclass as org_class, 
  p.objid as parent_objid,
  p.code as parent_code,
  p.title as parent_title,
  ia.objid as item_objid,
  ia.code as item_code,
  ia.title as item_title,
  ia.fund_objid as item_fund_objid, 
  ia.fund_code as item_fund_code,
  ia.fund_title as item_fund_title,
  ia.type as item_type,
  pt.tag as item_tag
from itemaccount ia
inner join itemaccount p on ia.parentid = p.objid 
inner join itemaccount_tag pt on p.objid = pt.acctid
inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'APPROVED'
go 



/*=============================================================
*
* COMPROMISE UPDATE 
*
==============================================================*/


CREATE TABLE rptcompromise (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  txnno nvarchar(25) NOT NULL,
  txndate date NOT NULL,
  faasid nvarchar(50) DEFAULT NULL,
  rptledgerid nvarchar(50) NOT NULL,
  lastyearpaid int NOT NULL,
  lastqtrpaid int NOT NULL,
  startyear int NOT NULL,
  startqtr int NOT NULL,
  endyear int NOT NULL,
  endqtr int NOT NULL,
  enddate date NOT NULL,
  cypaymentrequired int DEFAULT NULL,
  cypaymentorno nvarchar(10) DEFAULT NULL,
  cypaymentordate date DEFAULT NULL,
  cypaymentoramount decimal(10,2) DEFAULT NULL,
  downpaymentrequired int NOT NULL,
  downpaymentrate decimal(10,0) NOT NULL,
  downpayment decimal(10,2) NOT NULL,
  downpaymentorno nvarchar(50) DEFAULT NULL,
  downpaymentordate date DEFAULT NULL,
  term int NOT NULL,
  numofinstallment int NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtforinstallment decimal(16,2) NOT NULL,
  amtpaid decimal(16,2) NOT NULL,
  firstpartyname nvarchar(100) NOT NULL,
  firstpartytitle nvarchar(50) NOT NULL,
  firstpartyaddress nvarchar(100) NOT NULL,
  firstpartyctcno nvarchar(15) NOT NULL,
  firstpartyctcissued nvarchar(100) NOT NULL,
  firstpartyctcdate date NOT NULL,
  firstpartynationality nvarchar(50) NOT NULL,
  firstpartystatus nvarchar(50) NOT NULL,
  firstpartygender nvarchar(10) NOT NULL,
  secondpartyrepresentative nvarchar(100) NOT NULL,
  secondpartyname nvarchar(100) NOT NULL,
  secondpartyaddress nvarchar(100) NOT NULL,
  secondpartyctcno nvarchar(15) NOT NULL,
  secondpartyctcissued nvarchar(100) NOT NULL,
  secondpartyctcdate date NOT NULL,
  secondpartynationality nvarchar(50) NOT NULL,
  secondpartystatus nvarchar(50) NOT NULL,
  secondpartygender nvarchar(10) NOT NULL,
  dtsigned date DEFAULT NULL,
  notarizeddate date DEFAULT NULL,
  notarizedby nvarchar(100) DEFAULT NULL,
  notarizedbytitle nvarchar(50) DEFAULT NULL,
  signatories nvarchar(1000) NOT NULL,
  manualdiff decimal(16,2) NOT NULL DEFAULT '0.00',
  cypaymentreceiptid nvarchar(50) DEFAULT NULL,
  downpaymentreceiptid nvarchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_rptcompromise_faasid on rptcompromise(faasid)
go 

create index ix_rptcompromise_ledgerid on rptcompromise(rptledgerid)
go 

alter table rptcompromise add CONSTRAINT fk_rptcompromise_faas 
  FOREIGN KEY (faasid) REFERENCES faas (objid)
go 

alter table rptcompromise add CONSTRAINT fk_rptcompromise_rptledger 
  FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 




CREATE TABLE rptcompromise_installment (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  installmentno int NOT NULL,
  duedate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtpaid decimal(16,2) NOT NULL,
  fullypaid int NOT NULL,
  PRIMARY KEY (objid)
)
go 


create index ix_rptcompromise_installment_rptcompromiseid on rptcompromise_installment(parentid)
go 

alter table rptcompromise_installment 
  add CONSTRAINT fk_rptcompromise_installment_rptcompromise 
  FOREIGN KEY (parentid) REFERENCES rptcompromise (objid)
go 



  CREATE TABLE rptcompromise_credit (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  receiptid nvarchar(50) DEFAULT NULL,
  installmentid nvarchar(50) DEFAULT NULL,
  collector_name nvarchar(100) NOT NULL,
  collector_title nvarchar(50) NOT NULL,
  orno nvarchar(10) NOT NULL,
  ordate date NOT NULL,
  oramount decimal(16,2) NOT NULL,
  amount decimal(16,2) NOT NULL,
  mode nvarchar(50) NOT NULL,
  paidby nvarchar(150) NOT NULL,
  paidbyaddress nvarchar(100) NOT NULL,
  partial int DEFAULT NULL,
  remarks nvarchar(100) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go  

create index ix_rptcompromise_credit_parentid on rptcompromise_credit(parentid)
go 

create index ix_rptcompromise_credit_receiptid on rptcompromise_credit(receiptid)
go 

create index ix_rptcompromise_credit_installmentid on rptcompromise_credit(installmentid)
go 


alter table rptcompromise_credit 
  add CONSTRAINT fk_rptcompromise_credit_rptcompromise_installment 
  FOREIGN KEY (installmentid) REFERENCES rptcompromise_installment (objid)
go   

alter table rptcompromise_credit 
  add CONSTRAINT fk_rptcompromise_credit_cashreceipt 
  FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go   

alter table rptcompromise_credit 
  add CONSTRAINT fk_rptcompromise_credit_rptcompromise 
  FOREIGN KEY (parentid) REFERENCES rptcompromise (objid)
go   



CREATE TABLE rptcompromise_item (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  rptledgerfaasid nvarchar(50) NOT NULL,
  revtype nvarchar(50) NOT NULL,
  revperiod nvarchar(50) NOT NULL,
  year int NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtpaid decimal(16,2) NOT NULL,
  interest decimal(16,2) NOT NULL,
  interestpaid decimal(16,2) NOT NULL,
  priority int DEFAULT NULL,
  taxdifference int DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_rptcompromise_item_rptcompromise on rptcompromise_item (parentid)
go   
create index ix_rptcompromise_item_rptledgerfaas on rptcompromise_item (rptledgerfaasid)
go   

alter table rptcompromise_item 
  add CONSTRAINT fk_rptcompromise_item_rptcompromise 
  FOREIGN KEY (parentid) REFERENCES rptcompromise (objid)
go   

alter table rptcompromise_item 
  add CONSTRAINT fk_rptcompromise_item_rptledgerfaas 
  FOREIGN KEY (rptledgerfaasid) REFERENCES rptledgerfaas (objid)
go   




/*=============================================================
*
* MIGRATE COMPROMISE RECORDS 
*
==============================================================*/
insert into rptcompromise(
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
)
select 
    objid,
    state,
    txnno,
    txndate,
    faasid,
    rptledgerid,
    lastyearpaid,
    lastqtrpaid,
    startyear,
    startqtr,
    endyear,
    endqtr,
    enddate,
    cypaymentrequired,
    cypaymentorno,
    cypaymentordate,
    cypaymentoramount,
    downpaymentrequired,
    downpaymentrate,
    downpayment,
    downpaymentorno,
    downpaymentordate,
    term,
    numofinstallment,
    amount,
    amtforinstallment,
    amtpaid,
    firstpartyname,
    firstpartytitle,
    firstpartyaddress,
    firstpartyctcno,
    firstpartyctcissued,
    firstpartyctcdate,
    firstpartynationality,
    firstpartystatus,
    firstpartygender,
    secondpartyrepresentative,
    secondpartyname,
    secondpartyaddress,
    secondpartyctcno,
    secondpartyctcissued,
    secondpartyctcdate,
    secondpartynationality,
    secondpartystatus,
    secondpartygender,
    dtsigned,
    notarizeddate,
    notarizedby,
    notarizedbytitle,
    signatories,
    manualdiff,
    cypaymentreceiptid,
    downpaymentreceiptid
from rptledger_compromise
go 


insert into rptcompromise_installment(
    objid,
    parentid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
)
select 
    objid,
    rptcompromiseid,
    installmentno,
    duedate,
    amount,
    amtpaid,
    fullypaid
from rptledger_compromise_installment    
go 


insert into rptcompromise_credit(
    objid,
    parentid,
    receiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    amount, 
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
)
select 
    objid,
    rptcompromiseid as parentid,
    rptreceiptid,
    installmentid,
    collector_name,
    collector_title,
    orno,
    ordate,
    oramount,
    oramount,
    mode,
    paidby,
    paidbyaddress,
    partial,
    remarks
from rptledger_compromise_credit    
go 



insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basic') as objid,
    rci.rptcompromiseid as parentid,
    (select top 1 objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled') as rptledgerfaasid,
    'basic' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basic) as amount,
    sum(rci.basicpaid) as amtpaid,
    sum(rci.basicint) as interest,
    sum(rci.basicintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basic > 0 
group by rc.rptledgerid, year, rptcompromiseid


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-sef') as objid,
    rci.rptcompromiseid as parentid,
    (select top 1 objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled') as rptledgerfaasid,
    'sef' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.sef) as amount,
    sum(rci.sefpaid) as amtpaid,
    sum(rci.sefint) as interest,
    sum(rci.sefintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.sef > 0
group by rc.rptledgerid, year, rptcompromiseid
go 


insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-basicidle') as objid,
    rci.rptcompromiseid as parentid,
    (select top 1 objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled') as rptledgerfaasid,
    'basicidle' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.basicidle) as amount,
    sum(rci.basicidlepaid) as amtpaid,
    sum(rci.basicidleint) as interest,
    sum(rci.basicidleintpaid) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
go 




insert into rptcompromise_item(
    objid,
    parentid,
    rptledgerfaasid,
    revtype,
    revperiod,
    year,
    amount,
    amtpaid,
    interest,
    interestpaid,
    priority,
    taxdifference
)
select 
    concat(min(rci.objid), '-firecode') as objid,
    rci.rptcompromiseid as parentid,
    (select top 1 objid from rptledgerfaas where rptledgerid = rc.rptledgerid and rci.year >= fromyear and (rci.year <= toyear or toyear = 0) and state <> 'cancelled') as rptledgerfaasid,
    'firecode' as revtype,
    'prior' as revperiod,
    year,
    sum(rci.firecode) as amount,
    sum(rci.firecodepaid) as amtpaid,
    sum(0) as interest,
    sum(0) as interestpaid,
    10000 as priority,
    0 as taxdifference
from rptledger_compromise_item rci 
inner join rptledger_compromise rc on rci.rptcompromiseid = rc.objid 
where rci.basicidle > 0
group by rc.rptledgerid, year, rptcompromiseid
go 





/*====================================================================
*
* LANDTAX RPT DELINQUENCY UPDATE 
*
====================================================================*/


if exists(select * from information_schema.tables where table_name = N'report_rptdelinquency_error')
begin 
  drop table report_rptdelinquency_error
end 

if exists(select * from information_schema.tables where table_name = N'report_rptdelinquency_forprocess')
begin 
  drop table report_rptdelinquency_forprocess
end 

if exists(select * from information_schema.tables where table_name = N'report_rptdelinquency_item')
begin 
  drop table report_rptdelinquency_item
end 

if exists(select * from information_schema.tables where table_name = N'report_rptdelinquency_barangay')
begin 
  drop table report_rptdelinquency_barangay
end 

if exists(select * from information_schema.tables where table_name = N'report_rptdelinquency')
begin 
  drop table report_rptdelinquency
end 
go 



CREATE TABLE report_rptdelinquency (
  objid nvarchar(50) NOT NULL,
  state nvarchar(50) NOT NULL,
  dtgenerated datetime NOT NULL,
  dtcomputed datetime NOT NULL,
  generatedby_name nvarchar(255) NOT NULL,
  generatedby_title nvarchar(100) NOT NULL,
  PRIMARY KEY (objid)
) 
go 

CREATE TABLE report_rptdelinquency_item (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  rptledgerid nvarchar(50) NOT NULL,
  barangayid nvarchar(50) NOT NULL,
  year integer NOT NULL,
  qtr integer DEFAULT NULL,
  revtype nvarchar(50) NOT NULL,
  amount decimal(16,2) NOT NULL,
  interest decimal(16,2) NOT NULL,
  discount decimal(16,2) NOT NULL,
  PRIMARY KEY (objid)
) 
go 

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
go 

create index fk_rptdelinquency_item_rptdelinquency on report_rptdelinquency_item(parentid)  
go 


alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_rptledger foreign key(rptledgerid)
  references rptledger(objid)
go 

create index fk_rptdelinquency_item_rptledger on report_rptdelinquency_item(rptledgerid)  
go 

alter table report_rptdelinquency_item 
  add constraint fk_rptdelinquency_item_barangay foreign key(barangayid)
  references barangay(objid)
go 

create index fk_rptdelinquency_item_barangay on report_rptdelinquency_item(barangayid)  
go 




CREATE TABLE report_rptdelinquency_barangay (
  objid nvarchar(50) not null, 
  parentid nvarchar(50) not null, 
  barangayid nvarchar(50) NOT NULL,
  count int not null,
  processed int not null, 
  errors int not null, 
  ignored int not null, 
  PRIMARY KEY (objid)
) 
go 


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_rptdelinquency foreign key(parentid)
  references report_rptdelinquency(objid)
go 

create index fk_rptdelinquency_barangay_rptdelinquency on report_rptdelinquency_item(parentid)  
go 


alter table report_rptdelinquency_barangay 
  add constraint fk_rptdelinquency_barangay_barangay foreign key(barangayid)
  references barangay(objid)
go 

create index fk_rptdelinquency_barangay_barangay on report_rptdelinquency_barangay(barangayid)  
go 


CREATE TABLE report_rptdelinquency_forprocess (
  objid nvarchar(50) NOT NULL,
  barangayid nvarchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_barangayid on report_rptdelinquency_forprocess(barangayid)
go 
  


CREATE TABLE report_rptdelinquency_error (
  objid nvarchar(50) NOT NULL,
  barangayid nvarchar(50) NOT NULL,
  error text NULL,
  ignored integer NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_barangayid on report_rptdelinquency_error(barangayid)
go
  




drop view vw_landtax_report_rptdelinquency_detail
go 

create view vw_landtax_report_rptdelinquency_detail 
as
select
  parentid, 
  rptledgerid,
  barangayid,
  year,
  qtr,
  case when revtype = 'basic' then amount else 0 end as basic,
  case when revtype = 'basic' then interest else 0 end as basicint,
  case when revtype = 'basic' then discount else 0 end as basicdisc,
  case when revtype = 'basic' then interest - discount else 0 end as basicdp,
  case when revtype = 'basic' then amount + interest - discount else 0 end as basicnet,
  case when revtype = 'basicidle' then amount else 0 end as basicidle,
  case when revtype = 'basicidle' then interest else 0 end as basicidleint,
  case when revtype = 'basicidle' then discount else 0 end as basicidledisc,
  case when revtype = 'basicidle' then interest - discount else 0 end as basicidledp,
  case when revtype = 'basicidle' then amount + interest - discount else 0 end as basicidlenet,
  case when revtype = 'sef' then amount else 0 end as sef,
  case when revtype = 'sef' then interest else 0 end as sefint,
  case when revtype = 'sef' then discount else 0 end as sefdisc,
  case when revtype = 'sef' then interest - discount else 0 end as sefdp,
  case when revtype = 'sef' then amount + interest - discount else 0 end as sefnet,
  case when revtype = 'firecode' then amount else 0 end as firecode,
  case when revtype = 'firecode' then interest else 0 end as firecodeint,
  case when revtype = 'firecode' then discount else 0 end as firecodedisc,
  case when revtype = 'firecode' then interest - discount else 0 end as firecodedp,
  case when revtype = 'firecode' then amount + interest - discount else 0 end as firecodenet,
  case when revtype = 'sh' then amount else 0 end as sh,
  case when revtype = 'sh' then interest else 0 end as shint,
  case when revtype = 'sh' then discount else 0 end as shdisc,
  case when revtype = 'sh' then interest - discount else 0 end as shdp,
  case when revtype = 'sh' then amount + interest - discount else 0 end as shnet,
  amount + interest - discount as total
from report_rptdelinquency_item 
go




drop  view vw_landtax_report_rptdelinquency
go 

create view vw_landtax_report_rptdelinquency
as
select
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title,
  sum(v.basic) as basic,
  sum(v.basicint) as basicint,
  sum(v.basicdisc) as basicdisc,
  sum(v.basicdp) as basicdp,
  sum(v.basicnet) as basicnet,
  sum(v.basicidle) as basicidle,
  sum(v.basicidleint) as basicidleint,
  sum(v.basicidledisc) as basicidledisc,
  sum(v.basicidledp) as basicidledp,
  sum(v.basicidlenet) as basicidlenet,
  sum(v.sef) as sef,
  sum(v.sefint) as sefint,
  sum(v.sefdisc) as sefdisc,
  sum(v.sefdp) as sefdp,
  sum(v.sefnet) as sefnet,
  sum(v.firecode) as firecode,
  sum(v.firecodeint) as firecodeint,
  sum(v.firecodedisc) as firecodedisc,
  sum(v.firecodedp) as firecodedp,
  sum(v.firecodenet) as firecodenet,
  sum(v.sh) as sh,
  sum(v.shint) as shint,
  sum(v.shdisc) as shdisc,
  sum(v.shdp) as shdp,
  sum(v.shnet) as shnet,
  sum(v.total) as total
from report_rptdelinquency rr 
inner join vw_landtax_report_rptdelinquency_detail v on rr.objid = v.parentid 
group by 
  v.rptledgerid,
  v.barangayid,
  v.year,
  v.qtr,
  rr.dtgenerated,
  rr.generatedby_name,
  rr.generatedby_title
go




/* 03021 */

/*============================================
*
* TAX DIFFERENCE
*
*============================================*/

CREATE TABLE rptledger_avdifference (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  rptledgerfaas_objid nvarchar(50) NOT NULL,
  year int NOT NULL,
  av decimal(16,2) NOT NULL,
  paid int NOT NULL,
  PRIMARY KEY (objid)
) 
go 

create index fk_rptledger on rptledger_avdifference (parent_objid)
go 

create index fk_rptledgerfaas on rptledger_avdifference (rptledgerfaas_objid)
go 
 
alter table rptledger_avdifference 
	add CONSTRAINT fk_rptledgerfaas FOREIGN KEY (rptledgerfaas_objid) 
	REFERENCES rptledgerfaas (objid)
go 

alter table rptledger_avdifference 
	add CONSTRAINT fk_rptledger FOREIGN KEY (parent_objid) 
	REFERENCES rptledger (objid)
go 



create view vw_rptledger_avdifference
as 
select 
  rlf.objid,
  'APPROVED' as state,
  d.parent_objid as rptledgerid,
  rl.faasid,
  rl.tdno,
  rlf.txntype_objid,
  rlf.classification_objid,
  rlf.actualuse_objid,
  rlf.taxable,
  rlf.backtax,
  d.year as fromyear,
  1 as fromqtr,
  d.year as toyear,
  4 as toqtr,
  d.av as assessedvalue,
  1 as systemcreated,
  rlf.reclassed,
  rlf.idleland,
  1 as taxdifference
from rptledger_avdifference d 
inner join rptledgerfaas rlf on d.rptledgerfaas_objid = rlf.objid 
inner join rptledger rl on d.parent_objid = rl.objid 
go 

/* 03022 */

/*============================================
*
* SYNC PROVINCE AND REMOTE LEGERS
*
*============================================*/

drop table rptledger_remote
go 

CREATE TABLE remote_mapping (
  objid nvarchar(50) NOT NULL,
  doctype nvarchar(50) NOT NULL,
  remote_objid nvarchar(50) NULL,
  createdby_name nvarchar(255) NOT NULL,
  createdby_title nvarchar(100) DEFAULT NULL,
  dtcreated datetime NOT NULL,
  orgcode nvarchar(10) DEFAULT NULL,
  remote_orgcode nvarchar(10) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 


create index ix_doctype on remote_mapping(doctype)
go 
create index ix_orgcode on remote_mapping(orgcode)
go 
create index ix_remote_orgcode on remote_mapping(remote_orgcode)
go 
create index ix_remote_objid on remote_mapping(remote_objid)
go 


create table sync_data (
  objid nvarchar(50) not null,
  parentid nvarchar(50) not null,
  refid nvarchar(50) not null,
  reftype nvarchar(50) not null,
  orgid nvarchar(50) null,
  remote_orgid nvarchar(50) null,
  remote_orgcode nvarchar(20) null,
  remote_orgclass nvarchar(20) null,
  action nvarchar(50) not null,
  dtfiled datetime not null,
  idx int not null,
  sender_objid nvarchar(50) null,
  sender_name nvarchar(150) null,
  primary key (objid)
)
go 

create index ix_sync_data_refid on sync_data(refid)
go 

create index ix_sync_data_reftype on sync_data(reftype)
go 

create index ix_sync_data_orgid on sync_data(orgid)
go 

create index ix_sync_data_dtfiled on sync_data(dtfiled)
go 



CREATE TABLE sync_data_forprocess (
  objid nvarchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 

alter table sync_data_forprocess add constraint fk_sync_data_forprocess_sync_data 
  foreign key (objid) references sync_data (objid)
go 

CREATE TABLE sync_data_pending (
  objid nvarchar(50) NOT NULL,
  error text,
  expirydate datetime,
  PRIMARY KEY (objid)
) 
go 


alter table sync_data_pending add constraint fk_sync_data_pending_sync_data 
  foreign key (objid) references sync_data (objid)
go 

create index ix_expirydate on sync_data_pending(expirydate)
go 


alter table faas alter column prevtdno nvarchar(1000)
go 



create view vw_txn_log 
as 
select 
  distinct
  u.objid as userid, 
  u.name as username, 
  txndate, 
  ref,
  action, 
  1 as cnt 
from txnlog t
inner join sys_user u on t.userid = u.objid 

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'faas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from faas_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'subdivision' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%assign%'

union 

select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'consolidation' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%consolidation%'

union 


select 
  u.objid as userid, 
  u.name as username,
  t.enddate as txndate, 
  'cancelledfaas' as ref,
  case 
    when t.state like '%receiver%' then 'receive'
    when t.state like '%examiner%' then 'examine'
    when t.state like '%taxmapper_chief%' then 'approve taxmap'
    when t.state like '%taxmapper%' then 'taxmap'
    when t.state like '%appraiser%' then 'appraise'
    when t.state like '%appraiser_chief%' then 'approve appraisal'
    when t.state like '%recommender%' then 'recommend'
    when t.state like '%approver%' then 'approve'
    else t.state 
  end action, 
  1 as cnt 
from subdivision_task t 
inner join sys_user u on t.actor_objid = u.objid 
where t.state not like '%cancelledfaas%'
go 



/*===================================================
* DELINQUENCY UPDATE 
====================================================*/


alter table report_rptdelinquency_barangay add idx int
go 

update report_rptdelinquency_barangay set idx = 0 where idx is null
go 


create view vw_faas_lookup
as 
SELECT 
f.*,
e.name as taxpayer_name, 
e.address_text as taxpayer_address,
pc.code AS classification_code, 
pc.code AS classcode, 
pc.name AS classification_name, 
pc.name AS classname, 
r.ry, r.rputype, r.totalmv, r.totalav,
r.totalareasqm, r.totalareaha, r.suffix, r.rpumasterid, 
rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.pintype, 
rp.section, rp.parcel, rp.stewardshipno, rp.pin, 
b.name AS barangay_name 
FROM faas f 
INNER JOIN faas_list fl on f.objid = fl.objid 
INNER JOIN rpu r ON f.rpuid = r.objid 
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
INNER JOIN barangay b ON rp.barangayid = b.objid 
INNER JOIN entity e on f.taxpayer_objid = e.objid
go 

drop  view vw_rptpayment_item_detail
go 

create view vw_rptpayment_item_detail
as 
select
  rpi.objid,
  rpi.parentid,
  rp.refid as rptledgerid, 
  rpi.rptledgerfaasid,
  rpi.year,
  rpi.qtr,
  rpi.revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled,
  rp.voided 
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid

go 

drop view vw_rptpayment_item 
go 

create view vw_rptpayment_item 
as 
select 
    x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled,
    x.voided 
from vw_rptpayment_item_detail x
group by 
  x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    x.voided

go     




drop index faas.ix_canceldate 
go 

alter table faas alter column canceldate date 
go 

create index ix_faas_canceldate on faas(canceldate)
go 


alter table machdetail alter column depreciation decimal(16,6)
go

/* 255-03001 */

-- create tables: resection and resection_item

if exists(select * from sysobjects where id = object_id('resectionaffectedrpu'))
begin 
	drop table resectionaffectedrpu
end 
go 


if exists(select * from sysobjects where id = object_id('resectionitem'))
begin 
	drop table resectionitem
end 
go 


if exists(select * from sysobjects where id = object_id('resection'))
begin 
	drop table resection
end 
go 


CREATE TABLE resection (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  txnno nvarchar(25) NOT NULL,
  txndate datetime NOT NULL,
  lgu_objid nvarchar(50) NOT NULL,
  barangay_objid nvarchar(50) NOT NULL,
  pintype nvarchar(3) NOT NULL,
  section nvarchar(3) NOT NULL,
  originlgu_objid nvarchar(50) NOT NULL,
  memoranda nvarchar(255) DEFAULT NULL,
  taskid nvarchar(50) DEFAULT NULL,
  taskstate nvarchar(50) DEFAULT NULL,
  assignee_objid nvarchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 



create UNIQUE index ux_resection_txnno on resection(txnno)
go 

create index FK_resection_lgu_org on resection(lgu_objid)
go 
create index FK_resection_barangay_org on resection(barangay_objid)
go 
create index FK_resection_originlgu_org on resection(originlgu_objid)
go 
create index ix_resection_state on resection(state)
go 


  alter table resection 
    add CONSTRAINT FK_resection_barangay_org FOREIGN KEY (barangay_objid) 
    REFERENCES sys_org (objid)
go     
  alter table resection 
    add CONSTRAINT FK_resection_lgu_org FOREIGN KEY (lgu_objid) 
    REFERENCES sys_org (objid)
go     
  alter table resection 
    add CONSTRAINT FK_resection_originlgu_org FOREIGN KEY (originlgu_objid) 
    REFERENCES sys_org (objid)
go     




CREATE TABLE resection_item (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  faas_objid nvarchar(50) NOT NULL,
  faas_rputype nvarchar(15) NOT NULL,
  faas_pin nvarchar(25) NOT NULL,
  faas_suffix int NOT NULL,
  newfaas_objid nvarchar(50) DEFAULT NULL,
  newfaas_rpuid nvarchar(50) DEFAULT NULL,
  newfaas_rpid nvarchar(50) DEFAULT NULL,
  newfaas_section nvarchar(3) DEFAULT NULL,
  newfaas_parcel nvarchar(3) DEFAULT NULL,
  newfaas_suffix int DEFAULT NULL,
  newfaas_tdno nvarchar(25) DEFAULT NULL,
  newfaas_fullpin nvarchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create UNIQUE index ux_resection_item_tdno on resection_item (newfaas_tdno)
go 

create index FK_resection_item_item on resection_item(parent_objid)
go   
create index FK_resection_item_faas on resection_item(faas_objid)
go   
create index FK_resection_item_newfaas on resection_item(newfaas_objid)
go   
create index ix_resection_item_fullpin on resection_item(newfaas_fullpin)
go   


alter table resection_item add CONSTRAINT FK_resection_item_faas FOREIGN KEY (faas_objid) 
  REFERENCES faas (objid)
go   
alter table resection_item add CONSTRAINT FK_resection_item_item FOREIGN KEY (parent_objid) 
  REFERENCES resection (objid)
go   
alter table resection_item add CONSTRAINT FK_resection_item_newfaas FOREIGN KEY (newfaas_objid) 
  REFERENCES faas (objid)
go     



CREATE TABLE resection_task (
  objid nvarchar(50) NOT NULL,
  refid nvarchar(50) DEFAULT NULL,
  parentprocessid nvarchar(50) DEFAULT NULL,
  state nvarchar(50) DEFAULT NULL,
  startdate datetime DEFAULT NULL,
  enddate datetime DEFAULT NULL,
  assignee_objid nvarchar(50) DEFAULT NULL,
  assignee_name nvarchar(100) DEFAULT NULL,
  assignee_title nvarchar(80) DEFAULT NULL,
  actor_objid nvarchar(50) DEFAULT NULL,
  actor_name nvarchar(100) DEFAULT NULL,
  actor_title nvarchar(80) DEFAULT NULL,
  message nvarchar(255) DEFAULT NULL,
  signature text,
  PRIMARY KEY (objid)
)
go 


create index  ix_assignee_objid on resection_task (assignee_objid)
go 
create index  ix_refid on resection_task (refid)
go 



delete from sys_wf_transition where processname ='resection'
go	
delete from sys_wf_node where processname ='resection'
go	

INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('start', 'resection', 'Start', 'start', '1', NULL, 'RPT', NULL)
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-receiver', 'resection', 'Assign Receiver', 'state', '2', '0', 'RPT', 'RECEIVER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('receiver', 'resection', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-examiner', 'resection', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('examiner', 'resection', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-taxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('taxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provtaxmapperchief', 'resection', 'For Taxmapping Approval', 'state', '25', '0', 'RPT', 'TAXMAPPER_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-taxmapping-approval', 'resection', 'For Taxmapper Chief Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('taxmapper_chief', 'resection', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provtaxmapperchief', 'resection', 'Taxmapping Chief Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-appraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('appraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-appraisal-chief', 'resection', 'For Appraisal Chief Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('appraiser_chief', 'resection', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provappraiserchief', 'resection', 'Appraisal Chief Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-recommender', 'resection', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provrecommender', 'resection', 'For Recommending Approval', 'state', '71', NULL, 'RPT', 'RECOMMENDER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('recommender', 'resection', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provrecommender', 'resection', 'Recommending Approval', 'state', '76', NULL, 'RPT', 'RECOMMENDER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-approver', 'resection', 'For Assessor Approval', 'state', '80', NULL, 'RPT', 'APPROVER,ASSESSOR')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('approver', 'resection', 'Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provtaxmapper', 'resection', 'For Taxmapping', 'state', '200', '0', 'RPT', 'TAXMAPPER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provappraiserchief', 'resection', 'For Appraisal Chief Approval', 'state', '201', '0', 'RPT', 'APPRAISAL_CHIEF')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provtaxmapper', 'resection', 'Taxmapping', 'state', '205', '0', 'RPT', 'TAXMAPPER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provappraiser', 'resection', 'For Appraisal', 'state', '210', '0', 'RPT', 'APPRAISER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provappraiser', 'resection', 'Appraisal', 'state', '215', '0', 'RPT', 'APPRAISER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('assign-provapprover', 'resection', 'For Provincial Assessor Approval', 'state', '220', '0', 'RPT', 'APPROVER')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('provapprover', 'resection', 'Provincial Assessor Approval', 'state', '230', NULL, 'RPT', 'APPROVER,ASSESSOR')
go
INSERT INTO sys_wf_node (name, processname, title, nodetype, idx, salience, domain, role) VALUES ('end', 'resection', 'End', 'end', '1000', NULL, 'RPT', NULL)
go


INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('start', 'resection', '', 'assign-receiver', '1', NULL, '[:]', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-receiver', 'resection', '', 'receiver', '2', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('receiver', 'resection', 'delete', 'end', '4', NULL, '[caption:''Delete'', confirm:''Delete?'', closeonend:true]', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('receiver', 'resection', 'submit_examiner', 'assign-examiner', '5', NULL, '[caption:''Submit For Examination'', confirm:''Submit?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('receiver', 'resection', 'submit_taxmapper', 'assign-provtaxmapper', '6', NULL, '[caption:''Submit For Taxmapping'', confirm:''Submit?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-examiner', 'resection', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('examiner', 'resection', 'return_receiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('examiner', 'resection', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:''Submit for Taxmapping'', confirm:''Submit for taxmapping?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-provtaxmapper', 'resection', '', 'provtaxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapper', 'resection', 'return_receiver', 'receiver', '25', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapper', 'resection', 'return_examiner', 'examiner', '26', NULL, '[caption:''Return to Examiner'',confirm:''Return to examiner?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapper', 'resection', 'submit', 'assign-provtaxmapperchief', '27', NULL, '[caption:''Submit for Approval'', confirm:''Submit for approval?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-provtaxmapperchief', 'resection', '', 'provtaxmapperchief', '30', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapperchief', 'resection', 'return_receiver', 'receiver', '31', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapperchief', 'resection', 'return_taxmapper', 'provtaxmapper', '32', NULL, '[caption:''Return to Taxmapper'',confirm:''Return to taxmapper?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provtaxmapperchief', 'resection', 'submit', 'assign-provappraiser', '33', NULL, '[caption:''Submit for Appraisal'', confirm:''Submit for appraisal?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-provappraiser', 'resection', '', 'provappraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiser', 'resection', 'return_receiver', 'receiver', '44', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiser', 'resection', 'return_provtaxmapper', 'provtaxmapper', '46', NULL, '[caption:''Return to Taxmapper'',confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiser', 'resection', 'submit', 'assign-provappraiserchief', '47', NULL, '[caption:''Submit for Approval'', confirm:''Submit for approval?'', messagehandler:\"default\"]', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-provappraiserchief', 'resection', '', 'provappraiserchief', '50', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiserchief', 'resection', 'return_receiver', 'receiver', '51', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiserchief', 'resection', 'return_taxmapper', 'provtaxmapper', '52', NULL, '[caption:''Return to Taxmapper'',confirm:''Return to taxmapper?'',messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiserchief', 'resection', 'return_appraiser', 'provappraiser', '53', NULL, '[caption:''Return to Appraiser'',confirm:''Return to appraiser?'',messagehandler:''default'']', '', NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provappraiserchief', 'resection', 'submit', 'assign-provrecommender', '54', NULL, '[caption:''Submit for Recommending Approval'', confirm:''Submit for recommending approval?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-provrecommender', 'resection', '', 'provrecommender', '60', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provrecommender', 'resection', 'return_appraiser', 'provappraiser', '61', NULL, '[caption:''Return to Appraiser'',confirm:''Return to appraiser?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provrecommender', 'resection', 'return_taxmapper', 'provtaxmapper', '62', NULL, '[caption:''Return to Taxmapper'',confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provrecommender', 'resection', 'submit_approver', 'assign-approver', '63', NULL, '[caption:''Submit for Assessor Approval'', confirm:''Submit to assessor approval?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('assign-approver', 'resection', '', 'approver', '80', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('approver', 'resection', 'return_receiver', 'receiver', '83', NULL, '[caption:''Return to Receiver'',confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('approver', 'resection', 'return_provtaxmapper', 'provtaxmapper', '85', NULL, '[caption:''Return to Taxmapper'',confirm:''Return to Taxmapper?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('approver', 'resection', 'return_provappraiser', 'provappraiser', '86', NULL, '[caption:''Return to Appraiser'',confirm:''Return to Appraiser?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('approver', 'resection', 'approve', 'provapprover', '90', NULL, '[caption:''Approve'', confirm:''Approve FAAS?'', messagehandler:\"default\", closeonend:false]', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provapprover', 'resection', 'backforprovapproval', 'approver', '95', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition (parentid, processname, [action], [to], idx, eval, properties, permission, ui) VALUES ('provapprover', 'resection', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', NULL, NULL)
go



/* 255-03001 */
alter table rptcertification add properties nvarchar(2000)
go 

	
alter table faas_signatory add reviewer_objid nvarchar(50)
go 
alter table faas_signatory add reviewer_name nvarchar(100)
go 
alter table faas_signatory add reviewer_title nvarchar(75)
go 
alter table faas_signatory add reviewer_dtsigned datetime
go 
alter table faas_signatory add reviewer_taskid nvarchar(50)
go 
alter table faas_signatory add assessor_name nvarchar(100)
go 
alter table faas_signatory add assessor_title nvarchar(100)
go 


alter table cancelledfaas_signatory add reviewer_objid nvarchar(50)
go 
alter table cancelledfaas_signatory add reviewer_name nvarchar(100)
go 
alter table cancelledfaas_signatory add reviewer_title nvarchar(75)
go 
alter table cancelledfaas_signatory add reviewer_dtsigned datetime
go 
alter table cancelledfaas_signatory add reviewer_taskid nvarchar(50)
go 
alter table cancelledfaas_signatory add assessor_name nvarchar(100)
go 
alter table cancelledfaas_signatory add assessor_title nvarchar(100)
go 



    

CREATE TABLE rptacknowledgement (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  txnno nvarchar(25) NOT NULL,
  txndate datetime DEFAULT NULL,
  taxpayer_objid nvarchar(50) DEFAULT NULL,
  txntype_objid nvarchar(50) DEFAULT NULL,
  releasedate datetime DEFAULT NULL,
  releasemode nvarchar(50) DEFAULT NULL,
  receivedby nvarchar(255) DEFAULT NULL,
  remarks nvarchar(255) DEFAULT NULL,
  pin nvarchar(25) DEFAULT NULL,
  createdby_objid nvarchar(25) DEFAULT NULL,
  createdby_name nvarchar(25) DEFAULT NULL,
  createdby_title nvarchar(25) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create UNIQUE index  ux_rptacknowledgement_txnno on rptacknowledgement(txnno)
go 
create index ix_rptacknowledgement_pin on rptacknowledgement(pin)
go 
create index ix_rptacknowledgement_taxpayerid on rptacknowledgement(taxpayer_objid)
go 


CREATE TABLE rptacknowledgement_item (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  trackingno nvarchar(25) NULL,
  faas_objid nvarchar(50) DEFAULT NULL,
  newfaas_objid nvarchar(50) DEFAULT NULL,
  remarks nvarchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

alter table rptacknowledgement_item 
  add constraint fk_rptacknowledgement_item_rptacknowledgement
  foreign key (parent_objid) references rptacknowledgement(objid)
go 

create index ix_rptacknowledgement_parentid on rptacknowledgement_item(parent_objid)
go 

create unique index ux_rptacknowledgement_itemno on rptacknowledgement_item(trackingno)
go 

create index ix_rptacknowledgement_item_faasid  on rptacknowledgement_item(faas_objid)
go 

create index ix_rptacknowledgement_item_newfaasid on rptacknowledgement_item(newfaas_objid)
go 


    

drop  view vw_faas_lookup
go 

CREATE view vw_faas_lookup AS 
select 
  fl.objid AS objid,
  fl.state AS state,
  fl.rpuid AS rpuid,
  fl.utdno AS utdno,
  fl.tdno AS tdno,
  fl.txntype_objid AS txntype_objid,
  fl.effectivityyear AS effectivityyear,
  fl.effectivityqtr AS effectivityqtr,
  fl.taxpayer_objid AS taxpayer_objid,
  fl.owner_name AS owner_name,
  fl.owner_address AS owner_address,
  fl.prevtdno AS prevtdno,
  fl.cancelreason AS cancelreason,
  fl.cancelledbytdnos AS cancelledbytdnos,
  fl.lguid AS lguid,
  fl.realpropertyid AS realpropertyid,
  fl.displaypin AS fullpin,
  fl.originlguid AS originlguid,
  e.name AS taxpayer_name,
  e.address_text AS taxpayer_address,
  pc.code AS classification_code,
  pc.code AS classcode,
  pc.name AS classification_name,
  pc.name AS classname,
  fl.ry AS ry,
  fl.rputype AS rputype,
  fl.totalmv AS totalmv,
  fl.totalav AS totalav,
  fl.totalareasqm AS totalareasqm,
  fl.totalareaha AS totalareaha,
  fl.barangayid AS barangayid,
  fl.cadastrallotno AS cadastrallotno,
  fl.blockno AS blockno,
  fl.surveyno AS surveyno,
  fl.pin AS pin,
  fl.barangay AS barangay_name,
  fl.trackingno
from faas_list fl
left join propertyclassification pc on fl.classification_objid = pc.objid
left join entity e on fl.taxpayer_objid = e.objid
go 


/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE rptledger_tag (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  tag nvarchar(255) NOT NULL,
  PRIMARY KEY (objid)
)
go 

create UNIQUE index ux_rptledger_tag on rptledger_tag(parent_objid,tag)
go 

create index FK_rptledgertag_rptledger on rptledger_tag(parent_objid)
go 
  
alter table rptledger_tag 
    add CONSTRAINT FK_rptledgertag_rptledger 
    FOREIGN KEY (parent_objid) REFERENCES rptledger (objid)
go     



/* 255-03013 */
alter table resection_item add newfaas_claimno nvarchar(25)
go
alter table resection_item add faas_claimno nvarchar(25)
go 




/* 255-03015 */

create table rptcertification_online (
  objid nvarchar(50) not null,
  state nvarchar(25) not null,
  reftype nvarchar(25) not null,
  refid nvarchar(50) not null,
  refno nvarchar(50) not null,
  refdate date not null,
  orno nvarchar(25) default null,
  ordate date default null,
  oramount decimal(16,2) default null,
  primary key (objid)
)
go 

alter table rptcertification_online 
	add constraint fk_rptcertification_online_rptcertification foreign key (objid) references rptcertification (objid)
go 
 
create index ix_state on rptcertification_online(state)
go 
 
create index ix_refid on rptcertification_online(refid)
go 
 
create index ix_refno on rptcertification_online(refno)
go 
 
create index ix_orno on rptcertification_online(orno)
go 
  



CREATE TABLE assessmentnotice_online (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  reftype nvarchar(25) NOT NULL,
  refid nvarchar(50) NOT NULL,
  refno nvarchar(50) NOT NULL,
  refdate date NOT NULL,
  orno nvarchar(25) DEFAULT NULL,
  ordate date DEFAULT NULL,
  oramount decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on assessmentnotice_online (state)
go 
create index ix_refid on assessmentnotice_online (refid)
go 
create index ix_refno on assessmentnotice_online (refno)
go 
create index ix_orno on assessmentnotice_online (orno)
go 
  
alter table assessmentnotice_online 
  add CONSTRAINT fk_assessmentnotice_online_assessmentnotice 
  FOREIGN KEY (objid) REFERENCES assessmentnotice (objid)
go   



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE faasannotation_faas (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  faas_objid nvarchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
go

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
go

create index ix_parent_objid on faasannotation_faas(parent_objid)
go

create index ix_faas_objid on faasannotation_faas(faas_objid)
go


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
go

alter table faasannotation alter column faasid nvarchar(50) null
go



-- insert annotated faas
insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
go
  


/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
go

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
go 




/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE rptledger_redflag (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  caseno nvarchar(25) NULL,
  dtfiled datetime NULL,
  type nvarchar(25) NOT NULL,
  finding text,
  remarks text,
  blockaction nvarchar(25) DEFAULT NULL,
  filedby_objid nvarchar(50) DEFAULT NULL,
  filedby_name nvarchar(255) DEFAULT NULL,
  filedby_title nvarchar(50) DEFAULT NULL,
  resolvedby_objid nvarchar(50) DEFAULT NULL,
  resolvedby_name nvarchar(255) DEFAULT NULL,
  resolvedby_title nvarchar(50) DEFAULT NULL,
  dtresolved datetime NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on rptledger_redflag(parent_objid)
go
create index ix_state on rptledger_redflag(state)
go
create unique index ux_caseno on rptledger_redflag(caseno)
go
create index ix_type on rptledger_redflag(type)
go
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
go
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
go




/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby nvarchar(100)
go 
alter table subdivision_task add returnedby nvarchar(100)
go 
alter table consolidation_task add returnedby nvarchar(100)
go 
alter table cancelledfaas_task add returnedby nvarchar(100)
go 
alter table resection_task add returnedby nvarchar(100)
go 




/* 255-03016 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/
alter table rptpayment_share add iscommon int
go 

alter table rptpayment_share add year int
go 

update rptpayment_share set iscommon = 0 where iscommon is null 
go 




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date
go 

DELETE FROM sys_wf_transition WHERE processname = 'batchgr'
go
DELETE FROM sys_wf_node WHERE processname = 'batchgr'
go


INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL)
go

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('receiver', 'batchgr', 'submit', 'assign-provtaxmapper', '5', NULL, '[caption:''Submit For Taxmapping'', confirm:''Submit?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:''Approve'', confirm:''Approve record?'', messagehandler:''rptmessage:sign'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [ui]) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', NULL, NULL)
go


/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
if exists(select * from sysobjects where id = object_id('batchgr')) 
begin 
	select * into zz_tmp_batchgr  from batchgr
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_item')) 
begin 
	select * into zz_tmp_batchgr_item  from batchgr_item
end 
go 


if exists(select * from sysobjects where id = object_id('vw_batchgr')) 
begin 
	drop view vw_batchgr
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_log')) 
begin 
	drop table batchgr_log
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_error')) 
begin 
	drop table batchgr_error
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_forprocess')) 
begin 
	drop table batchgr_forprocess
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_task')) 
begin 
	drop table batchgr_task
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_item')) 
begin 
	drop table batchgr_item
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr')) 
begin 
	drop table batchgr
end 
go 



create table batchgr (
  objid nvarchar(50) not null,
  state nvarchar(50) not null,
  ry int not null,
  txntype_objid nvarchar(5) not null,
  txnno nvarchar(25) not null,
  txndate datetime not null,
  effectivityyear int not null,
  effectivityqtr int not null,
  memoranda nvarchar(255) not null,
  originlguid nvarchar(50) not null,
  lguid nvarchar(50) not null,
  barangayid nvarchar(50) not null,
  rputype nvarchar(15) default null,
  classificationid nvarchar(50) default null,
  section nvarchar(10) default null,
  primary key (objid)
)
go 

create index ix_state on batchgr(state)
go
create index ix_ry on batchgr(ry)
go
create index ix_txnno on batchgr(txnno)
go
create index ix_lguid on batchgr(lguid)
go
create index ix_barangayid on batchgr(barangayid)
go
create index ix_classificationid on batchgr(classificationid)
go
create index ix_section on batchgr(section)
go

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lguid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangayid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classificationid) 
references propertyclassification(objid)
go


create table batchgr_item (
  objid nvarchar(50) not null,
  parent_objid nvarchar(50) not null,
  state nvarchar(50) not null,
  rputype nvarchar(15) not null,
  tdno nvarchar(50) not null,
  fullpin nvarchar(50) not null,
  pin nvarchar(50) not null,
  suffix int not null,
  subsuffix int null,
  newfaasid nvarchar(50) default null,
  error text,
  primary key (objid)
) 
go

create index ix_parent_objid on batchgr_item(parent_objid)
go
create index ix_tdno on batchgr_item(tdno)
go
create index ix_pin on batchgr_item(pin)
go
create index ix_newfaasid on batchgr_item(newfaasid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_batchgr foreign key(parent_objid) 
references batchgr(objid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(newfaasid) 
references faas(objid)
go

create table batchgr_task (
  objid nvarchar(50) not null,
  refid nvarchar(50) default null,
  parentprocessid nvarchar(50) default null,
  state nvarchar(50) default null,
  startdate datetime default null,
  enddate datetime default null,
  assignee_objid nvarchar(50) default null,
  assignee_name nvarchar(100) default null,
  assignee_title nvarchar(80) default null,
  actor_objid nvarchar(50) default null,
  actor_name nvarchar(100) default null,
  actor_title nvarchar(80) default null,
  message nvarchar(255) default null,
  signature text,
  returnedby nvarchar(100) default null,
  primary key (objid)
)
go 

create index ix_assignee_objid on batchgr_task(assignee_objid)
go
create index ix_refid on batchgr_task(refid)
go

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
go


create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lguid = l.objid 
left join sys_org b on bg.barangayid = b.objid
left join propertyclassification pc on bg.classificationid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
go







/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/
if exists(select * from sysobjects where id = object_id('entity_mapping')) 
begin 
  drop table entity_mapping
end 
go 

CREATE TABLE entity_mapping (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  org_objid nvarchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

if exists(select * from sysobjects where id = object_id('vw_entity_mapping')) 
begin 
  drop view vw_entity_mapping
end 
go 

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
go



/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item')) 
begin 
  drop view vw_rptcertification_item
end 
go 

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
go




/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
if exists(select * from sysobjects where id = object_id('subdivision_assist_item')) 
begin 
  drop view subdivision_assist_item
end 
go 

if exists(select * from sysobjects where id = object_id('subdivision_assist')) 
begin 
  drop view subdivision_assist
end 
go 




CREATE TABLE subdivision_assist (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  taskstate nvarchar(50) NOT NULL,
  assignee_objid nvarchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
go

create index ix_parent_objid on subdivision_assist(parent_objid)
go

create index ix_assignee_objid on subdivision_assist(assignee_objid)
go

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
go


CREATE TABLE subdivision_assist_item (
  objid nvarchar(50) NOT NULL,
  subdivision_objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  pintype nvarchar(10) NOT NULL,
  section nvarchar(5) NOT NULL,
  startparcel int NOT NULL,
  endparcel int NOT NULL,
  parcelcount int NOT NULL,
  parcelcreated int NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
go

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
go

create index ix_parent_objid on subdivision_assist_item(parent_objid)
go







/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

if exists(select * from sysobjects where id = object_id('rpttaxcredit')) 
begin 
  drop view rpttaxcredit
end 
go 


CREATE TABLE rpttaxcredit (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  type nvarchar(25) NOT NULL,
  txnno nvarchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  reftype nvarchar(25) DEFAULT NULL,
  refid nvarchar(50) DEFAULT NULL,
  refno nvarchar(25) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtapplied decimal(16,2) NOT NULL,
  rptledger_objid nvarchar(50) NOT NULL,
  srcledger_objid nvarchar(50) DEFAULT NULL,
  remarks nvarchar(255) DEFAULT NULL,
  approvedby_objid nvarchar(50) DEFAULT NULL,
  approvedby_name nvarchar(150) DEFAULT NULL,
  approvedby_title nvarchar(75) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go


create index ix_state on rpttaxcredit(state)
go

create index ix_type on rpttaxcredit(type)
go

create unique index ux_txnno on rpttaxcredit(txnno)
go

create index ix_reftype on rpttaxcredit(reftype)
go

create index ix_refid on rpttaxcredit(refid)
go

create index ix_refno on rpttaxcredit(refno)
go

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
go

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
go







/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE machine_smv (
  objid nvarchar(50) NOT NULL,
  parent_objid nvarchar(50) NOT NULL,
  machine_objid nvarchar(50) NOT NULL,
  expr nvarchar(255) NOT NULL,
  previd nvarchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on machine_smv(parent_objid)
go
create index ix_machine_objid on machine_smv(machine_objid)
go
create index ix_previd on machine_smv(previd)
go
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
go



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
go

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
go


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
go


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
go


alter table machdetail add smvid nvarchar(50)
go 
alter table machdetail add params text
go

update machdetail set params = '[]' where params is null
go

create index ix_smvid on machdetail(smvid)
go


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
go 





/*==================================================
**
** SUBDIVISION AFFECTED RPUS TXNTYPE (DP)
**
===================================================*/

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
go



alter table bldgrpu add occpermitno varchar(25)
go

alter table rpu add isonline int
go

update rpu set isonline = 0 where isonline is null 
go 



if exists(select * from sysobjects where id = OBJECT_ID('sync_data_forprocess'))
begin 
  drop table sync_data_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('sync_data_pending'))
begin 
  drop table sync_data_pending
end 
go 


if exists(select * from sysobjects where id = OBJECT_ID('sync_data'))
begin 
  drop table sync_data
end 
go 



if exists(select * from sysobjects where id = OBJECT_ID('syncdata_pending'))
begin 
  drop table syncdata_pending
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forprocess'))
begin 
  drop table syncdata_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_item'))
begin 
  drop table syncdata_item
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata'))
begin 
  drop table syncdata
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forsync'))
begin 
  drop table syncdata_forsync
end 
go 



CREATE TABLE syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(100) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(100) NOT NULL,
  orgid varchar(25) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(100) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_dtfiled ON syncdata_forsync (dtfiled)
go
CREATE INDEX ix_createdbyid ON syncdata_forsync (createdby_objid)
go
CREATE INDEX ix_reftype ON syncdata_forsync (reftype) 
go
CREATE INDEX ix_refno ON syncdata_forsync (refno)
go


CREATE TABLE syncdata (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) DEFAULT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(20) DEFAULT NULL,
  remote_orgclass varchar(20) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(150) DEFAULT NULL,
  fileid varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_reftype on syncdata (reftype)
go
CREATE INDEX ix_refno on syncdata (refno)
go
CREATE INDEX ix_orgid on syncdata (orgid)
go
CREATE INDEX ix_dtfiled on syncdata (dtfiled)
go
CREATE INDEX ix_fileid on syncdata (fileid)
go
CREATE INDEX ix_refid on syncdata (refid)
go


CREATE TABLE syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(255) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) NOT NULL,
  error text,
  idx int NOT NULL,
  info text,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_parentid ON syncdata_item(parentid)
go
CREATE INDEX ix_refid ON syncdata_item(refid)
go
CREATE INDEX ix_refno ON syncdata_item(refno)
go


ALTER TABLE syncdata_item 
ADD CONSTRAINT fk_syncdataitem_syncdata 
FOREIGN KEY (parentid) REFERENCES syncdata (objid)
GO 



CREATE TABLE syncdata_forprocess (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_parentid ON syncdata_forprocess (parentid)
go 

ALTER TABLE syncdata_forprocess 
ADD CONSTRAINT fk_syncdata_forprocess_syncdata_item 
FOREIGN KEY (objid) REFERENCES syncdata_item (objid)
go


CREATE TABLE syncdata_pending (
  objid varchar(50) NOT NULL,
  error text,
  expirydate datetime DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_expirydate ON syncdata_pending(expirydate)
go 

ALTER TABLE syncdata_pending 
ADD CONSTRAINT fk_syncdata_pending_syncdata 
FOREIGN KEY (objid) REFERENCES syncdata (objid)
go



/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
go


update pf set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
from faas_previous pf, faas f, rpu r
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
go 




/* 255-03020 */

alter table syncdata_item add async int
go 
alter table syncdata_item add dependedaction nvarchar(100)
go


create index ix_state on syncdata(state)
go
create index ix_state on syncdata_item(state)
go


create table syncdata_offline_org (
	orgid nvarchar(50) not null,
	expirydate datetime not null,
	primary key(orgid)
)
go




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/
if exists(select * from sysobjects where id = OBJECT_ID('vw_rpu_assessment'))
begin 
  drop table vw_rpu_assessment
end 
go 


create view vw_rpu_assessment as 
select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
go 




alter table rptledger_item add fromqtr int
go 
alter table rptledger_item add toqtr int
GO




CREATE TABLE batch_rpttaxcredit (
  objid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  txndate date NOT NULL,
  txnno nvarchar(25) NOT NULL,
  rate decimal(10,2) NOT NULL,
  paymentfrom date DEFAULT NULL,
  paymentto nvarchar(255) DEFAULT NULL,
  creditedyear int NOT NULL,
  reason nvarchar(255) NOT NULL,
  validity date NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_state on batch_rpttaxcredit(state)
go
create index ix_txnno on batch_rpttaxcredit(txnno)
go

CREATE TABLE batch_rpttaxcredit_ledger (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  state nvarchar(25) NOT NULL,
  error nvarchar(255) NULL,
	barangayid nvarchar(50) not null, 
  PRIMARY KEY (objid)
) 
go


create index ix_parentid on batch_rpttaxcredit_ledger (parentid)
go
create index ix_state on batch_rpttaxcredit_ledger (state)
go
create index ix_barangayid on batch_rpttaxcredit_ledger (barangayid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
go




CREATE TABLE batch_rpttaxcredit_ledger_posted (
  objid nvarchar(50) NOT NULL,
  parentid nvarchar(50) NOT NULL,
  barangayid nvarchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

create index ix_parentid on batch_rpttaxcredit_ledger_posted(parentid)
go
create index ix_barangayid on batch_rpttaxcredit_ledger_posted(barangayid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
go

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
go

alter table rpttaxcredit add info text
go


alter table rpttaxcredit add discapplied decimal(16,2) not null
go

update rpttaxcredit set discapplied = 0 where discapplied is null 
go



