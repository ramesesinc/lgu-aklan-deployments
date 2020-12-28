use etracs255_aklan
go 

alter table af add 
  baseunit varchar(10) NULL,
  defaultunit varchar(10) NULL   
go 

alter table af_control add 
  dtfiled date NULL,
  state varchar(50) NULL,
  unit varchar(25) NULL,
  batchno int NULL,
  respcenter_objid varchar(50) NULL,
  respcenter_name varchar(100) NULL,
  cost decimal(16,2) NULL,
  currentindexno int NULL,
  currentdetailid varchar(150) NULL,
  batchref varchar(50) NULL,
  lockid varchar(50) NULL,
  allocid varchar(50) NULL,
  ukey varchar(50) NOT NULL DEFAULT ''
go 

create index ix_dtfiled on af_control (dtfiled) 
go 
create index ix_state on af_control (state) 
go 
create index ix_batchno on af_control (batchno) 
go 
create index ix_respcenter_objid on af_control (respcenter_objid) 
go 
create index ix_respcenter_name on af_control (respcenter_name) 
go 
create index ix_currentdetailid on af_control (currentdetailid) 
go 
create index ix_allocid on af_control (allocid) 
go 
create index ix_ukey on af_control (ukey) 
go 

drop index ix_afid on af_control 
go 
alter table af_control alter column afid varchar(50) not null 
go 
create index ix_afid on af_control (afid) 
go 

alter table af_control alter column startseries int not null 
go 
alter table af_control alter column currentseries int not null 
go 
alter table af_control alter column endseries int not null 
go 


update af_control set ukey = convert(varchar(50), HashBytes('MD5', objid), 2); 
update af_control set prefix = '' where prefix is null; 
update af_control set suffix = '' where suffix is null; 

alter table af_control alter column prefix varchar(10) not null 
go 
alter table af_control alter column suffix varchar(10) not null 
go 
alter table af_control add default '' for prefix 
go 
alter table af_control add default '' for suffix 
go 
create unique index uix_af_control on af_control ( afid, startseries, prefix, suffix, ukey )
go 



update z20181120_af_inventory_detail set qtyreceived=0 where qtyreceived is null; 
update z20181120_af_inventory_detail set qtybegin=0 where qtybegin is null; 
update z20181120_af_inventory_detail set qtyissued=0 where qtyissued is null; 
update z20181120_af_inventory_detail set qtyending=0 where qtyending is null; 
update z20181120_af_inventory_detail set qtycancelled=0 where qtycancelled is null; 
update z20181120_af_inventory_detail set refno=refid where refdate is not null and refid is not null and refno is null ;


insert into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, remarks, 
  issuedto_objid, issuedto_name
) 
select 
  d.objid, 1 as state, d.controlid, d.[lineno], d.refid, d.refno, d.reftype, d.refdate, d.txndate, d.txntype, 
  d.receivedstartseries, d.receivedendseries, d.beginstartseries, d.beginendseries, 
  d.issuedstartseries, d.issuedendseries, d.endingstartseries, d.endingendseries, 
  d.qtyreceived, d.qtybegin, d.qtyissued, d.qtyending, d.qtycancelled, d.remarks, 
  a.owner_objid, a.owner_name 
from af_control a 
  inner join z20181120_af_inventory_detail d on d.controlid = a.objid 
where d.refdate is not null 
;
update af_control_detail set reftype='ISSUE', txntype='COLLECTION' where reftype='stockissue' and txntype in ('ISSUANCE-RECEIPT','ISSUE-RECEIPT') 
;
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='ISSUANCE-RECEIPT'
; 
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='COLLECTOR BEG.BAL.'
;
UPDATE af_control_detail set reftype=upper(reftype) where reftype = 'remittance' 
; 
update af_control_detail set reftype=upper(reftype), txntype='TRANSFER_COLLECTION' where reftype='TRANSFER'
; 


if object_id('dbo.z20181120_vw_af_inventory_detail', 'V') IS NOT NULL 
  drop view z20181120_vw_af_inventory_detail;
go 
create view z20181120_vw_af_inventory_detail as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost,  
  d.* 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
go 

if object_id('dbo.z20181120_vw_af_stockissuance', 'V') IS NOT NULL 
  drop view z20181120_vw_af_stockissuance;
go 
create view z20181120_vw_af_stockissuance as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.[lineno], d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE'
go 

if object_id('dbo.z20181120_vw_af_stockissuancereceipt', 'V') IS NOT NULL 
  drop view z20181120_vw_af_stockissuancereceipt;
go 
create view z20181120_vw_af_stockissuancereceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.[lineno], d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost, 
  d.receivedstartseries, d.receivedendseries, d.qtyreceived 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE-RECEIPT'
go 


if object_id('dbo.z20181120_vw_af_stockreceipt', 'V') IS NOT NULL 
  drop view z20181120_vw_af_stockreceipt;
go 
create view z20181120_vw_af_stockreceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.[lineno], d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockreceipt' 
  and d.txntype = 'RECEIPT'
go 


insert into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, 
  remarks, issuedto_objid, issuedto_name 
) 
select distinct 
  (ir.controlid +'-00') as objid, 1 as state, ir.controlid, 0 as indexno, 
  r.refid, r.refno, 'PURCHASE_RECEIPT' as reftype, r.refdate, r.txndate, 'PURCHASE' as txntype, 
  ir.receivedstartseries, ir.receivedendseries, 
  null as beginstartseries, null as beginendseries, 
  null as issuedstartseries, null as issuedendseries, 
  ir.receivedstartseries as endingstartseries, ir.receivedendseries as endingendseries, 
  ir.qtyreceived, 0 as qtybegin, 0 as qtyissued, ir.qtyreceived as qtyending, 0 as qtycancelled, 
  convert(char(255), r.remarks) as remarks, null as issuedto_objid, null as issuedto_name 
from ( 
  select ir.objid as issuancereceiptid,  
    (select top 1 objid from z20181120_vw_af_stockissuance where refid=ir.refid and afid=ir.afid order by [lineno] desc) as issuanceid 
  from z20181120_vw_af_stockissuancereceipt ir 
)t1 
  inner join z20181120_vw_af_stockissuancereceipt ir on ir.objid = t1.issuancereceiptid 
  inner join af_control afc on afc.objid = ir.controlid 
  inner join z20181120_vw_af_stockissuance i on i.objid = t1.issuanceid 
  inner join z20181120_vw_af_stockreceipt r on r.controlid = i.controlid 
go 

update af_control_detail set 
  beginstartseries = issuedstartseries, 
  beginendseries = isnull(endingendseries, issuedendseries) 
where reftype='REMITTANCE' and txntype='REMITTANCE' 
go 

update aa set 
  aa.issuedto_objid = bb.collector_objid, 
  aa.issuedto_name = bb.collector_name 
from 
  af_control_detail aa, ( 
    select d.objid, d.refid, r.collector_objid, r.collector_name 
    from af_control_detail d 
      inner join remittance r on r.objid = d.refid 
    where d.reftype='REMITTANCE' 
      and d.txntype='REMITTANCE' 
  )bb 
where aa.objid = bb.objid 
go 


update aa set 
  aa.dtfiled = bb.refdate 
from   
  af_control aa, ( 
    select controlid, min(refdate) as refdate 
    from af_control_detail 
    group by controlid 
  )bb 
where aa.objid = bb.controlid 
  and aa.dtfiled is null 
; 

update af_control set state = 'ISSUED' where state is null 
;

update aaa set 
  aaa.currentindexno = bbb.indexno, 
  aaa.currentdetailid = bbb.objid 
from 
  af_control aaa, ( 
    select d.controlid, d.indexno, d.objid 
    from ( 
      select a.objid, 
        (
          select top 1 objid from af_control_detail 
          where controlid=a.objid 
          order by refdate desc, txndate desc, indexno desc 
        ) as lastdetailid 
      from af_control a 
    )t1, af_control_detail d 
    where d.objid = t1.lastdetailid 
  )bbb 
where aaa.objid = bbb.controlid 
; 

update aa set 
  aa.currentdetailid = bb.currentdetailid, 
  aa.currentindexno = bb.currentindexno 
from 
  af_control aa, ( 
    select t1.*, d.indexno as currentindexno  
    from ( 
      select a.objid, 
        (select top 1 objid from af_control_detail where controlid = a.objid order by refdate desc, txndate desc) as currentdetailid 
      from af_control a 
      where a.currentdetailid is null 
    )t1, af_control_detail d 
    where d.objid = t1.currentdetailid 
  )bb 
where aa.objid = bb.objid 
;

update aa set 
  aa.unit = bb.unit 
from 
  af_control aa, ( 
    select afc.objid, ai.unit  
    from af_control afc, z20181120_af_inventory ai  
    where afc.objid = ai.objid 
      and afc.unit is null 
  )bb 
where aa.objid = bb.objid 
;

update aa set 
  aa.batchref = bb.refno, aa.batchno = 1  
from 
  af_control aa, ( 
    select d.controlid, d.refno 
    from ( 
      select a.objid, 
        (
          select top 1 objid from af_control_detail 
          where controlid = a.objid and reftype in ('BEGIN_BALANCE','FORWARD','PURCHASE_RECEIPT','TRANSFER') 
          order by refdate, txndate, indexno desc 
        ) as detailid 
      from af_control a 
      where a.batchref is null 
    )t1, af_control_detail d 
    where d.objid = t1.detailid 
  )bb 
where aa.objid = bb.controlid 
; 

update aa set 
  aa.dtfiled = bb.receiptdate 
from 
  af_control aa, ( 
    select afc.objid, 
      (select min(receiptdate) from cashreceipt where controlid = afc.objid) as receiptdate 
    from af_control afc 
    where afc.dtfiled is null
  )bb 
where aa.objid = bb.objid
; 

select * 
into ztmp_afcontrol_no_dtfiled
from af_control where dtfiled is null 
go  
delete from af_control where objid in (
  select objid from ztmp_afcontrol_no_dtfiled 
  where objid = af_control.objid 
)
go 

drop index ix_dtfiled on af_control 
go 
alter table af_control 
  alter column dtfiled date not null
go  
create index ix_dtfiled on af_control (dtfiled)
go 

drop index ix_state on af_control 
go 
alter table af_control 
  alter column state varchar(50) not null 
go  
create index ix_state on af_control (state) 
go 


update af_control_detail set 
  reftype='ISSUE', txntype='SALE' 
where reftype='stocksale' 
  and txntype='SALE-RECEIPT' 
;


INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('0016-STUB', '0016', 'STUB', '50', '0.00', '1', 'cashreceipt-form:0016', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('907-STUB', '907', 'STUB', '50', '0.00', '1', 'cashreceipt-form:907', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('51-STUB', '51', 'STUB', '50', '0.00', '1', 'cashreceipt:printout:51', 'cashreceiptdetail:printout:51');
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('52-STUB', '52', 'STUB', '50', '0.00', '1', 'cashreceipt-form:52', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('53-STUB', '53', 'STUB', '50', '0.00', '1', 'cashreceipt-form:53', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('54-STUB', '54', 'STUB', '50', '0.00', '1', 'cashreceipt-form:54', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('56-STUB', '56', 'STUB', '50', '0.00', '1', 'cashreceipt-form:56', 'cashreceiptdetail:printout:56');
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('57-STUB', '57', 'STUB', '50', '0.00', '1', 'cashreceipt-form:57', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('58-STUB', '58', 'STUB', '50', '0.00', '1', 'cashreceipt-form:58', NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('CT1-PAD', 'CT1', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('CT10-PAD', 'CT10', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('CT2-PAD', 'CT2', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO afunit (objid, itemid, unit, qty, saleprice, interval, cashreceiptprintout, cashreceiptdetailprintout) VALUES ('CT5-PAD', 'CT5', 'PAD', '2000', '0.00', '1', NULL, NULL);


update aa set 
  aa.unit = bb.unit 
from 
  af_control aa, ( 
    select afc.objid, 
      (select top 1 unit from afunit where itemid=afc.afid) as unit 
    from af_control afc 
    where afc.unit is null
  )bb 
where aa.objid = bb.objid
; 

alter table af_control 
  alter column unit varchar(25) not null 
go 


insert into afrequest ( 
  objid, reqno, state, dtfiled, reqtype, itemclass, 
  requester_objid, requester_name, requester_title, 
  org_objid, org_name, vendor 
) 
select distinct 
  sr.objid, sr.reqno, sr.state, sr.dtfiled, 'COLLECTION' as reqtype, sr.itemclass, 
  sr.requester_objid, sr.requester_name, sr.requester_title, 
  sr.org_objid, sr.org_name, sr.vendor 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
  inner join z20181120_stockrequest sr on sr.objid = si.request_objid 
;


insert into afrequestitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, qty, qtyreceived 
) 
select 
  sri.objid, sri.parentid, sri.item_objid, sri.item_code, sri.item_title, 
  sri.unit, sri.qty, sri.qtyreceived 
from afrequest req 
  inner join z20181120_stockrequestitem sri on sri.parentid = req.objid 
; 


insert into aftxn ( 
  objid, state, request_objid, request_reqno, controlno, dtfiled, 
  user_objid, user_name, issueto_objid, issueto_name, issueto_title, 
  org_objid, org_name, txndate, txntype, cost 
) 
select 
  si.objid, 'POSTED' as state, si.request_objid, si.request_reqno, si.issueno, si.dtfiled, 
  si.user_objid, si.user_name, si.issueto_objid, si.issueto_name, si.issueto_title, 
  si.org_objid, si.org_name, si.dtfiled, 'ISSUE' as txntype, null as cost 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
;

insert into aftxnitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, 
  qty, qtyserved, remarks, txntype, cost 
) 
select 
  si.objid, si.parentid, si.item_objid, si.item_code, si.item_title, si.unit, 
  si.qtyrequested, si.qtyissued, si.remarks, 'COLLECTION' as txntype, 0 as cost 
from aftxn a 
  inner join z20181120_stockissueitem si on si.parentid = a.objid 
;



alter table bank add 
  depositsliphandler varchar(50) NULL, 
  cashreport varchar(255) NULL, 
  checkreport varchar(255) NULL 
go 
alter table bank add _ukey varchar(50) not null default ''
go 
update bank set _ukey=objid where _ukey=''
go 
create UNIQUE index ux_bank_code_branch on bank (code,branchname,_ukey) 
go 


create UNIQUE index ux_bank_name_branch on bank (name,branchname) 
go 
create index ix_name on bank (name)
go 
create index ix_state on bank (state)
go 
create index ix_code on bank (code)
go 


-- alter table bankaccount modify fund_objid varchar(100) null not null ;  
alter table bankaccount add acctid nvarchar(50) null 
go 
create index ix_acctid on bankaccount (acctid) 
go 
alter table bankaccount 
  add constraint fk_bankaccount_acctid 
  foreign key (acctid) references itemaccount (objid) 
go 


alter table batchcapture_collection_entry_item 
  alter column item_title varchar(255) NULL 
go 
alter table batchcapture_collection_entry_item 
  alter column fund_objid nvarchar(50) NULL
go 


alter table cashreceipt 
  alter column payer_name varchar(800) null
go 
alter table cashreceipt 
  alter column paidby varchar(800) not null 
go 
alter table cashreceipt add 
  remittanceid varchar(50) null, 
  subcollector_remittanceid varchar(50) null 
go 


create index ix_remittanceid on cashreceipt (remittanceid)
go
create index ix_subcollector_remittanceid on cashreceipt (subcollector_remittanceid)
go 

create index ix_paidby on cashreceipt (paidby) 
go 
create index ix_payer_name on cashreceipt (payer_name) 
go 
create index ix_formtype on cashreceipt (formtype) 
go 


drop index fk_cashreceiptitem on cashreceiptitem 
go 
drop index ix_receiptid on cashreceiptitem 
go 
alter table cashreceiptitem 
  alter column receiptid nvarchar(50) not null 
go 
create index ix_receiptid on cashreceiptitem (receiptid) 
go 


select * 
into ztmp_cashreceiptitem_no_item_objid 
from cashreceiptitem where item_objid is null
go 
delete from cashreceiptitem where objid in (
  select objid from ztmp_cashreceiptitem_no_item_objid 
  where objid = cashreceiptitem.objid 
)
go


drop index ix_item_objid on cashreceiptitem
go 
alter table cashreceiptitem 
  alter column item_objid nvarchar(50) not null 
go
create index ix_item_objid on cashreceiptitem (item_objid) 
go 
 
alter table cashreceiptitem 
  alter column item_code varchar(100) not null 
go 
alter table cashreceiptitem 
  alter column item_title varchar(255) not null 
go 
alter table cashreceiptitem 
  alter column amount decimal(16,4) not null 
go 

create index ix_item_code on cashreceiptitem (item_code) 
go 
create index ix_item_title on cashreceiptitem (item_title) 
go 

-- alter table cashreceiptitem add sortorder int default '0'
-- go 
update cashreceiptitem set sortorder=0 where sortorder is null 
go 
alter table cashreceiptitem 
  alter column sortorder int not null 
go 

alter table cashreceiptitem add item_fund_objid varchar(100) null 
go 
create index ix_item_fund_objid on cashreceiptitem (item_fund_objid) 
go 

update ci set 
  ci.item_fund_objid = ia.fund_objid 
from cashreceiptitem ci, itemaccount ia 
where ci.item_objid = ia.objid 
go 
update cashreceiptitem set item_fund_objid = 'GENERAL' where item_fund_objid is null 
go 

drop index ix_item_fund_objid on cashreceiptitem 
go 
alter table cashreceiptitem 
  alter column item_fund_objid nvarchar(50) not null 
go 
create index ix_item_fund_objid on cashreceiptitem (item_fund_objid) 
go 
alter table cashreceiptitem 
  add constraint fk_cashreceiptitem_item_fund_objid 
  foreign key (item_fund_objid) REFERENCES fund (objid) 
go 


drop index ix_account_fund_objid on cashreceiptpayment_creditmemo 
go 
alter table cashreceiptpayment_creditmemo 
  alter column account_fund_objid nvarchar(50) null 
go 
create index ix_account_fund_objid on cashreceiptpayment_creditmemo (account_fund_objid) 
go 


EXEC sp_rename N'[dbo].[cashreceiptpayment_noncash].[bank]', N'_bank', 'COLUMN'
go 
alter table cashreceiptpayment_noncash 
  alter column _bank varchar(50) null 
go 

drop index ix_bankid on cashreceiptpayment_noncash
go 
EXEC sp_rename N'[dbo].[cashreceiptpayment_noncash].[bankid]', N'_bankid', 'COLUMN'
go 
alter table cashreceiptpayment_noncash 
  alter column _bankid varchar(50) null 
go 

EXEC sp_rename N'[dbo].[cashreceiptpayment_noncash].[deposittype]', N'_deposittype', 'COLUMN'
go 
alter table cashreceiptpayment_noncash 
  alter column _deposittype varchar(50) null 
go 


drop index ix_account_fund_objid on cashreceiptpayment_noncash
go 
alter table cashreceiptpayment_noncash 
  alter column account_fund_objid nvarchar(50) null 
go 
create index ix_account_fund_objid on cashreceiptpayment_noncash (account_fund_objid) 
go 


alter table cashreceiptpayment_noncash add 
  fund_objid nvarchar(50) null, 
  refid varchar(50) null, 
  checkid varchar(50) null, 
  voidamount decimal(16,4) null 
go 
create index ix_fund_objid on cashreceiptpayment_noncash (fund_objid) 
go 
create index ix_refid on cashreceiptpayment_noncash (refid) 
go 
create index ix_checkid on cashreceiptpayment_noncash (checkid) 
go 

alter table cashreceiptpayment_noncash 
  add constraint fk_cashreceiptpayment_noncash_fund_objid 
  foreign key (fund_objid) references fund (objid) 
go  


create unique index uix_receiptid on cashreceipt_cancelseries (receiptid)
go 

update cashreceipt set paidby = substring(paidby, 1, 800) ; 
update cashreceipt set payer_name = substring(payer_name, 1, 800) ; 

alter table cashreceipt 
  alter column paidby varchar(800) not null 
go 
alter table cashreceipt 
  alter column payer_name varchar(800) null 
go 


select t1.receiptid, (
    select top 1 objid 
    from cashreceipt_void 
    where receiptid = t1.receiptid 
    order by txndate 
  ) as validreceiptid 
into ztmp_duplicate_cashreceipt_void 
from (
  select receiptid, count(*) as icount 
  from cashreceipt_void  
  group by receiptid
  having count(*) > 1 
)t1 
go 
create index ix_receiptid on ztmp_duplicate_cashreceipt_void (receiptid)
go 
create index ix_validreceiptid on ztmp_duplicate_cashreceipt_void (validreceiptid)
go 

select v.objid  
into ztmp_duplicate_cashreceipt_void_for_deletion 
from cashreceipt_void v 
  inner join ztmp_duplicate_cashreceipt_void z on (z.receiptid = v.receiptid and z.validreceiptid <> v.objid) 
go 
delete from cashreceipt_void where objid in (select objid from ztmp_duplicate_cashreceipt_void_for_deletion) 
go 
drop table ztmp_duplicate_cashreceipt_void_for_deletion
go 
drop table ztmp_duplicate_cashreceipt_void
go 


create unique index uix_receiptid on cashreceipt_void (receiptid)
go 


select * 
into z20181120_collectiongroup 
from collectiongroup 
go  

drop index ix_afno on collectiongroup 
go 
alter table collectiongroup drop column afno 
go 
drop index ix_org_objid on collectiongroup 
go 
alter table collectiongroup drop column org_objid 
go 
alter table collectiongroup drop column org_name 
go 


create index ix_collectiongroupid on collectiongroup_revenueitem (collectiongroupid) 
go 

EXEC sp_rename N'[dbo].[collectiongroup_revenueitem].[revenueitemid]', N'account_objid', 'COLUMN'
go 
alter table collectiongroup_revenueitem 
  alter column account_objid nvarchar(50) not null 
go 

EXEC sp_rename N'[dbo].[collectiongroup_revenueitem].[orderno]', N'sortorder', 'COLUMN'
go 
alter table collectiongroup_revenueitem 
  alter column sortorder int not null 
go 

alter table collectiongroup_revenueitem add 
  objid varchar(100) NULL,
  account_title varchar(255) NULL,
  tag varchar(255) NULL 
go 


update collectiongroup_revenueitem set 
  objid = convert(varchar(50), hashbytes('MD5', (collectiongroupid +'|'+ account_objid)), 2)
go 
update aa set 
  aa.account_title = bb.title 
from collectiongroup_revenueitem aa, itemaccount bb 
where aa.account_objid = bb.objid 
go 

alter table collectiongroup_revenueitem drop constraint PK__collecti__BA8154AD62AFA012
go 
EXEC sp_rename N'[dbo].[collectiongroup_revenueitem]', N'collectiongroup_account'
go 
create unique index uix_collectiongroup_account on collectiongroup_account (collectiongroupid, account_objid) 
go 

alter table collectiongroup_account 
  alter column objid varchar(50) not null 
go 
alter table collectiongroup_account 
  alter column account_title varchar(255) not null 
go 

alter table collectiongroup_account 
  add constraint pk_collectiongroup_account primary key (objid) 
go 


select * 
into ztmp_collectiongroup_account_no_parent_reference
from collectiongroup_account where collectiongroupid not in (
  select objid from collectiongroup 
  where objid = collectiongroup_account.collectiongroupid 
) 
go 
delete from collectiongroup_account where objid in (
  select objid from ztmp_collectiongroup_account_no_parent_reference 
  where objid = collectiongroup_account.objid 
)
go 
alter table collectiongroup_account 
  add constraint fk_collectiongroup_account_collectiongroupid 
  foreign key (collectiongroupid) references collectiongroup (objid) 
go 
alter table collectiongroup_account 
  add constraint fk_collectiongroup_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
go 


insert into collectiongroup_org ( 
  objid, collectiongroupid, org_objid, org_name, org_type 
) 
select * 
from ( 
  select 
    ('CGO-'+ convert(varchar(50), hashbytes('MD5', (g.objid +'|'+ g.org_objid)), 2)) as objid, 
    g.objid as collectiongroupid, o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiongroup g, sys_org o 
  where g.org_objid = o.objid 
)t1 
go 


create index ix_state on collectiongroup (state) 
go 
update collectiongroup set state = 'ACTIVE' 
go 


update collectiontype set allowbatch=0 where allowbatch is null ;
update collectiontype set allowonline=0 where allowonline is null ;
update collectiontype set allowoffline=0 where allowoffline is null ;

alter table collectiontype add default 0 for allowbatch 
go 
alter table collectiontype add default 0 for allowoffline 
go 
-- alter table collectiontype add default 0 for allowonline 
-- go 


alter table collectiontype add  
  allowpaymentorder int default '0',
  allowcreditmemo int default '0', 
  allowkiosk int default '0',
  system int default '0'  
go  

select * 
into z20181120_collectiontype 
from collectiontype 
go 

create index ix_state on collectiontype (state) 
go  
update collectiontype set state = 'ACTIVE' 
go 


create index ix_collectiontypeid on collectiontype_account (collectiontypeid) 
go 
alter table collectiontype_account add objid varchar(50) null 
go 
update collectiontype_account set objid = ('CTA-'+ convert(varchar(50), hashbytes('MD5', (collectiontypeid +'|'+ account_objid)), 2))
go 
alter table collectiontype_account alter column objid varchar(50) not null 
go 
alter table collectiontype_account drop constraint PK__collecti__56B943F91C5D1EBA
go 
alter table collectiontype_account add constraint pk_collectiontype_account primary key (objid) 
go 
create unique index uix_collectiontype_account on collectiontype_account (collectiontypeid, account_objid)
go 


insert into collectiontype_org ( 
  objid, collectiontypeid, org_objid, org_name, org_type 
) 
select * from ( 
  select 
    ('CTO-'+ convert(varchar(50), hashbytes('MD5', (a.objid +'|'+ o.objid)), 2)) as objid, 
    a.objid as collectiontypeid, o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiontype a, sys_org o 
  where a.org_objid = o.objid 
)t1 
;  


alter table creditmemo add 
  receiptdate date NULL,
  issuereceipt int NULL,
  type varchar(25) NULL
go  
create index ix_receiptdate on creditmemo (receiptdate) 
go 


drop index ix_fund_objid on creditmemotype
go 
alter table creditmemotype 
  alter column fund_objid nvarchar(50) null 
go 
create index ix_fund_objid on creditmemotype (fund_objid) 
go 
alter table creditmemotype 
  add constraint fk_creditmemotype_fund_objid 
  foreign key (fund_objid) references fund (objid) 
go 

EXEC sp_rename N'[dbo].[creditmemotype].[HANDLER]', N'handler', 'COLUMN'
go 
alter table creditmemotype alter column handler varchar(50) null 
go 


drop index ix_entityname on entity 
go 
drop index ix_entity_entityname on entity 
go 
alter table entity alter column entityname varchar(800) not null 
go 
create index ix_entityname on entity (entityname) 
go 

alter table entity alter column email varchar(50) null 
go 
alter table entity add state varchar(25) null 
go 
create index ix_state on entity (state) 
go 
update entity set state = 'ACTIVE' where state is null
go 


create unique index uix_idtype_idno on entityid (entityid, idtype, idno)
go 
 
select id.objid 
into ztmp_invalid_entityid 
from entityid id 
  left join entity e on e.objid = id.entityid 
where id.entityid is not null 
  and e.objid is null 
go 
delete from entityid where objid in ( 
  select objid from  ztmp_invalid_entityid
)
go 
drop table ztmp_invalid_entityid 
go 

alter table entityid add constraint fk_entityid_entityid 
  foreign key (entityid) references entity (objid) 
go 


drop index ix_lastname on entityindividual
go 
drop index ix_lfname on entityindividual
go 
alter table entityindividual alter column lastname varchar(100) not null 
go 
create index ix_lastname on entityindividual (lastname) 
go 

drop index ix_firstname on entityindividual 
go 
alter table entityindividual alter column firstname varchar(100) not null 
go 
create index ix_firstname on entityindividual (firstname) 
go 

create index ix_lfname on entityindividual (lastname,firstname) 
go 

alter table entityindividual alter column tin varchar(50) null 
go 
alter table entityindividual add profileid varchar(50) null
go 
create index ix_profileid on entityindividual (profileid)
go 


drop index ix_tin on entityjuridical 
go 
alter table entityjuridical alter column tin varchar(50) null 
go 
create index ix_tin on entityjuridical (tin) 
go 

alter table entityjuridical alter column administrator_address varchar(255) null 
go 

alter table entityjuridical add 
  administrator_objid varchar(50) null, 
  administrator_address_objid varchar(50) null, 
  administrator_address_text varchar(255) null 
go 
-- create index ix_dtregistered on entityjuridical (dtregistered)
-- go 
create index ix_administrator_objid on entityjuridical (administrator_objid)
go 
-- create index ix_administrator_name on entityjuridical (administrator_name)
-- go 
create index ix_administrator_address_objid on entityjuridical (administrator_address_objid)
go 


update entityjuridical set 
  administrator_address_text = administrator_address
where administrator_address_text is null 
go 


-- alter table entitymember add member_address varchar(255) null 
-- go 
alter table entitymember alter column member_name varchar(800) not null 
go 


alter table entity_address alter column street varchar(255) null 
go 


-- alter table fund alter column objid varchar(100) not null 
-- go 

alter table fund add 
  groupid varchar(50) NULL,
  depositoryfundid varchar(100) NULL 
go 
create index ix_groupid on fund (groupid) 
go  
create index ix_depositoryfundid on fund (depositoryfundid) 
go 


update fund set state = 'ACTIVE' 
; 
update fund set 
  groupid = objid, depositoryfundid = objid, system = 1, parentid = null  
where objid in ('GENERAL', 'SEF', 'TRUST') 
; 
update fund set depositoryfundid = objid where depositoryfundid is null 
;
update a set 
  a.groupid = b.objid 
from fund a, fund b 
where a.parentid = b.objid 
  and b.objid in ('GENERAL','SEF','TRUST') 
  and a.groupid is null 
;
update fund set system=0 where system is null 
;
update fund set groupid = 'GENERAL' where groupid is null 
;  


-- update fund set title='GENERAL PROPER' where objid='GENERAL';
-- update fund set title='SEF PROPER' where objid='SEF';
-- update fund set title='TRUST PROPER' where objid='TRUST';

update aa set 
  aa.depositoryfundid = aa.objid 
from fund aa, ( select distinct fund_objid from bankaccount ) bb 
where aa.objid = bb.fund_objid 
;


alter table itemaccount alter column state nvarchar(10) not null 
go 
alter table itemaccount alter column code nvarchar(50) not null 
go 
alter table itemaccount alter column title nvarchar(255) not null 
go 
alter table itemaccount alter column type nvarchar(25) not null 
go 

alter table itemaccount alter column fund_objid nvarchar(50) null
go 
alter table itemaccount add constraint fk_itemaccount_fund_objid 
  foreign key (fund_objid) references fund (objid)
go 

alter table itemaccount add 
  generic int DEFAULT '0',
  sortorder int DEFAULT '0',
  hidefromlookup int NOT NULL DEFAULT '0' 
go 
create index ix_state on itemaccount (state) 
go 
create index ix_generic on itemaccount (generic) 
go 
create index ix_type on itemaccount (type) 
go 

update itemaccount set state = 'ACTIVE' where state = 'APPROVED' ; 


alter table remittance_fund alter column fund_objid nvarchar(50) not null
go 
alter table remittance_fund add constraint fk_remittance_fund_fund_objid 
  foreign key (fund_objid) references fund (objid)
go 

alter table remittance_fund alter column fund_title nvarchar(100) not null
go 


EXEC sp_rename N'[dbo].[remittance].[txnno]', N'controlno', 'COLUMN'
go 
alter table remittance alter column controlno nvarchar(50) not null 
go 

EXEC sp_rename N'[dbo].[remittance].[totalnoncash]', N'totalcheck', 'COLUMN'
go 
alter table remittance alter column totalcheck decimal(16,2) not null 
go 

alter table remittance alter column liquidatingofficer_objid nvarchar(50) NULL 
go 
alter table remittance alter column liquidatingofficer_name nvarchar(100) NULL 
go 
alter table remittance alter column liquidatingofficer_title nvarchar(100) NULL 
go 


update remittance set remittancedate = dtposted where remittancedate is null ;

EXEC sp_rename N'[dbo].[remittance].[remittancedate]', N'controldate', 'COLUMN'
go 

drop index ix_remittancedate on remittance 
go 
alter table remittance alter column controldate datetime not null 
go 
create index ix_controldate on remittance (controldate) 
go 


alter table remittance add 
  totalcr decimal(16,2) NULL,
  collector_signature varchar(MAX) NULL,
  liquidatingofficer_signature varchar(MAX) NULL,
  collectionvoucherid varchar(50) NULL 
go 

alter table remittance add _ukey varchar(50) not null default ''
go 
update remittance set _ukey = objid
go 


create unique index uix_controlno on remittance (controlno,_ukey) 
go 
create index ix_collectionvoucherid on remittance (collectionvoucherid) 
go 


update remittance set totalcr = 0.0 where totalcr is null 
;
alter table remittance alter column totalcr decimal(16,2) not null 
go 

alter table remittance 
  add constraint fk_remittance_collectionvoucherid 
  foreign key (collectionvoucherid) references collectionvoucher (objid) 
go 


alter table remittance_af add 
  controlid varchar(50) NULL,
  receivedstartseries int NULL,
  receivedendseries int NULL,
  beginstartseries int NULL,
  beginendseries int NULL,
  issuedstartseries int NULL,
  issuedendseries int NULL,
  endingstartseries int NULL,
  endingendseries int NULL,
  qtyreceived int NULL,
  qtybegin int NULL,
  qtyissued int NULL,
  qtyending int NULL,
  qtycancelled int NULL,
  remarks varchar(255) NULL 
go 
create index ix_controlid on remittance_af (controlid) 
go 


alter table remittance_fund alter column fund_objid nvarchar(50) not null 
go 
alter table remittance_fund alter column fund_title nvarchar(100) not null 
go 
alter table remittance_fund add 
  totalcash decimal(16,4) NULL,
  totalcheck decimal(16,4) NULL,
  totalcr decimal(16,4) NULL,
  cashbreakdown varchar(MAX) NULL,
  controlno varchar(100) NULL 
go 

update remittance_fund set totalcash = amount where totalcash is null ; 
update remittance_fund set totalcheck = 0.0 where totalcheck is null ; 
update remittance_fund set totalcr = 0.0 where totalcr is null ; 

alter table remittance_fund alter column amount decimal(16,4) not null 
go 
alter table remittance_fund alter column totalcash decimal(16,4) not null 
go 
alter table remittance_fund alter column totalcheck decimal(16,4) not null 
go 
alter table remittance_fund alter column totalcr decimal(16,4) not null 
go 
drop index remittanceid on remittance_fund
go 
alter table remittance_fund alter column remittanceid nvarchar(50) not null 
go 
create index ix_remittanceid on remittance_fund (remittanceid) 
go 
alter table remittance_fund 
  add constraint fk_remittance_fund_remittanceid 
  foreign key (remittanceid) references remittance (objid) 
go 


select rf.* 
into ztmp_remittance_fund_duplicates
from ( 
  select rf.remittanceid, rf.fund_objid, count(*) as icount 
  from remittance_fund rf 
  group by rf.remittanceid, rf.fund_objid 
  having count(*) > 1 
)t1, remittance_fund rf 
where rf.remittanceid = t1.remittanceid   
  and rf.fund_objid = t1.fund_objid 
go 
delete from remittance_fund where objid in (
  select objid from ztmp_remittance_fund_duplicates 
  where objid = remittance_fund.objid 
)
go 

create unique index uix_remittance_fund on remittance_fund (remittanceid, fund_objid) 
go 

insert into remittance_fund (
  objid, remittanceid, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr
)
select 
  ('REMFUND-'+ convert(varchar(50), hashbytes('MD5', (remittanceid + fund_objid)), 2)) as objid, remittanceid, fund_objid, 
  (select top 1 fund_title from ztmp_remittance_fund_duplicates where remittanceid = t1.remittanceid and fund_objid = t1.fund_objid) as fund_title, 
  amount, totalcash, totalcheck, totalcr 
from ( 
  select 
    rf.remittanceid, rf.fund_objid, 
    sum(rf.amount) as amount, sum(rf.totalcash) as totalcash, 
    sum(rf.totalcheck) as totalcheck, sum(rf.totalcr) as totalcr
  from ztmp_remittance_fund_duplicates rf 
  group by rf.remittanceid, rf.fund_objid 
)t1
go 


alter table sys_org alter column root int not null 
go 
alter table sys_org add default 0 for root 
go 


CREATE TABLE sys_requirement_type (
  objid varchar(50) NOT NULL,
  code varchar(50) NOT NULL,
  title varchar(255) NOT NULL,
  handler varchar(50) DEFAULT NULL,
  type varchar(50) DEFAULT NULL,
  system int DEFAULT NULL,
  agency varchar(50) DEFAULT NULL,
  sortindex int NOT NULL,
  verifier varchar(50) DEFAULT NULL,
  constraint pk_sys_requirement_type PRIMARY KEY (objid) 
)
go 
create UNIQUE index uix_code on sys_requirement_type (code)
go 


alter table sys_rule add noloop int not null default '1'
go

alter table sys_rule alter column name varchar(255) not null 
go 

alter table sys_rule_actiondef_param drop constraint PK__sys_rule__530D6FE44BEC364B
go 
alter table sys_rule_actiondef_param alter column objid varchar(255) not null
go 
alter table sys_rule_actiondef_param 
  add constraint pk_sys_rule_actiondef_param 
  primary key (objid)
go 


alter table sys_rule_action_param alter column actiondefparam_objid varchar(255) NOT NULL
go 

alter table sys_rule_condition add notexist int NOT NULL default '0'
go 

alter table sys_rule_condition_constraint alter column field_objid varchar(255) null
go 

alter table sys_rule_fact_field drop constraint PK__sys_rule__530D6FE45D16C24D
go 
alter table sys_rule_fact_field alter column objid varchar(255) not null 
go 
alter table sys_rule_fact_field 
  add constraint pk_sys_rule_fact_field 
  primary key (objid) 
go 

alter table sys_securitygroup alter column objid varchar(100) not null
go 


alter table sys_session add terminalid varchar(50) null
go 
alter table sys_session_log add terminalid varchar(50) null
go 

alter table sys_wf_node alter column idx int not null
go 
alter table sys_wf_node add 
  properties text NULL,
  ui text NULL,
  tracktime int null 
go 


alter table sys_wf_transition add ui text null 
go 


alter table cashreceipt alter column paidbyaddress varchar(800) NOT NULL 
go 

drop index ix_remittanceid on cashreceipt 
go 
alter table cashreceipt alter column remittanceid nvarchar(50) null 
go 
create index ix_remittanceid on cashreceipt (remittanceid) 
go 
alter table cashreceipt 
  add constraint fk_cashreceipt_remittanceid 
  foreign key (remittanceid) references remittance (objid) 
go 

drop index ix_subcollector_remittanceid on cashreceipt 
go 
alter table cashreceipt alter column subcollector_remittanceid nvarchar(50) null 
go 
create index ix_subcollector_remittanceid on cashreceipt (subcollector_remittanceid) 
go 
alter table cashreceipt 
  add constraint fk_cashreceipt_subcollector_remittanceid 
  foreign key (subcollector_remittanceid) references subcollector_remittance (objid)
go 


update aa set 
  aa.remittanceid = bb.remittanceid  
from cashreceipt aa, z20181120_remittance_cashreceipt bb 
where aa.objid = bb.objid
;

update aa set 
  aa.subcollector_remittanceid = bb.remittanceid  
from cashreceipt aa, subcollector_remittance_cashreceipt bb 
where aa.objid = bb.objid 
;


drop index ix_refitem_objid on cashreceipt_share
go 
alter table cashreceipt_share alter column refitem_objid nvarchar(50) not null 
go 
create index ix_refitem_objid on cashreceipt_share (refitem_objid) 
go 
alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_refitem_objid 
  foreign key (refitem_objid) references itemaccount (objid) 
go 

drop index ix_payableitem_objid on cashreceipt_share
go 
alter table cashreceipt_share alter column payableitem_objid nvarchar(50) not null 
go 
create index ix_payableitem_objid on cashreceipt_share (payableitem_objid) 
go 
alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_payableitem_objid 
  foreign key (payableitem_objid) references itemaccount (objid) 
go 


create index ix_txnno on certification (txnno) 
go 
create index ix_txndate on certification (txndate) 
go 
create index ix_type on certification (type) 
go 
create index ix_name on certification (name) 
go 
create index ix_orno on certification (orno) 
go 
create index ix_ordate on certification (ordate) 
go 
create index ix_createdbyid on certification (createdbyid) 
go 
create index ix_createdby on certification (createdby) 
go 


drop index ix_fund_objid on collectiontype
go 
alter table collectiontype alter column fund_objid nvarchar(50) null 
go 
create index ix_fund_objid on collectiontype (fund_objid) 
go 

alter table collectiontype alter column fund_title varchar(255) null 
go 


create index ix_account_title on collectiontype_account (account_title) 
go 

create index ix_entityname_state on entity (state,entityname)
go 

alter table txnlog alter column refid varchar(255) not null 
go 
create index ix_refid on txnlog (refid)
go 
