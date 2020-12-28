use etracs255_aklan
go 

create table cashreceipt_plugin (
	objid varchar(50) not null, 
	connection varchar(255) not null, 
	servicename varchar(255) not null,
	constraint pk_objid primary key (objid)
)
go 
create unique index uix_connection on cashreceipt_plugin (connection)
go 


alter table account_incometarget add CONSTRAINT fk_account_incometarget_itemid 
	FOREIGN KEY (itemid) REFERENCES account (objid)
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


alter table collectiontype add info text null 
go  


CREATE TABLE entity_mapping ( 
   objid varchar(50) NOT NULL, 
   parent_objid varchar(50) NOT NULL, 
   org_objid varchar(50) NULL,
   CONSTRAINT pk_entity_mapping PRIMARY KEY (objid)
) 
go 


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


CREATE TABLE sync_data ( 
   objid varchar(50) NOT NULL, 
   parentid varchar(50) NOT NULL, 
   refid varchar(50) NOT NULL, 
   reftype varchar(50) NOT NULL, 
   action varchar(50) NOT NULL, 
   orgid varchar(50) NULL, 
   remote_orgid varchar(50) NULL, 
   remote_orgcode varchar(20) NULL, 
   remote_orgclass varchar(20) NULL, 
   dtfiled datetime NOT NULL, 
   idx int NOT NULL, 
   sender_objid varchar(50) NULL, 
   sender_name varchar(150) NULL, 
   refno varchar(50) NULL,
   CONSTRAINT pk_sync_data PRIMARY KEY (objid)
) 
go 
create index ix_sync_data_dtfiled on sync_data (dtfiled)
go 
create index ix_sync_data_orgid on sync_data (orgid)
go 
create index ix_sync_data_refid on sync_data (refid)
go 
create index ix_sync_data_reftype on sync_data (reftype)
go 


CREATE TABLE sync_data_forprocess ( 
   objid varchar(50) NOT NULL,
   CONSTRAINT pk_sync_data_forprocess PRIMARY KEY (objid) 
) 
go 
alter table sync_data_forprocess add CONSTRAINT fk_sync_data_forprocess_sync_data 
   FOREIGN KEY (objid) REFERENCES sync_data (objid) 
go 


CREATE TABLE sync_data_pending ( 
   objid varchar(50) NOT NULL, 
   error text NULL, 
   expirydate datetime NULL,
   CONSTRAINT pk_sync_data_pending PRIMARY KEY (objid) 
) 
go 
create index ix_expirydate on sync_data_pending (expirydate)
go 
alter table sync_data_pending add CONSTRAINT fk_sync_data_pending_sync_data 
   FOREIGN KEY (objid) REFERENCES sync_data (objid)
go 


update aa set 
	aa.receivedstartseries = bb.issuedstartseries, aa.receivedendseries = bb.issuedendseries, aa.qtyreceived = bb.qtyissued, 
	aa.issuedstartseries = null, aa.issuedendseries = null, aa.qtyissued = 0 
from af_control_detail aa, ( 
		select objid, issuedstartseries, issuedendseries, qtyissued 
		from af_control_detail d 
		where d.reftype = 'ISSUE' and d.txntype = 'COLLECTION' 
			and d.qtyreceived = 0 
	)bb 
where aa.objid = bb.objid 
go  

update af_control_detail set receivedstartseries = null where receivedstartseries = 0 ; 
update af_control_detail set receivedendseries = null where receivedendseries  = 0 ; 
update af_control_detail set beginstartseries = null where beginstartseries = 0 ; 
update af_control_detail set beginendseries = null where beginendseries = 0 ; 
update af_control_detail set issuedstartseries = null where issuedstartseries = 0 ; 
update af_control_detail set issuedendseries = null where issuedendseries = 0 ; 
update af_control_detail set endingstartseries = null where endingstartseries = 0 ; 
update af_control_detail set endingendseries = null where endingendseries = 0 ; 


update aa set 
	aa.remarks = 'COLLECTION' 
from af_control_detail aa, ( 
		select d.objid 
		from af_control_detail d 
			inner join af_control a on a.objid = d.controlid 
		where d.reftype = 'ISSUE' and d.txntype = 'COLLECTION' 
			and d.remarks = 'SALE' 
	)bb 
where aa.objid = bb.objid 
go 

update aa set 
	aa.beginstartseries = bb.receivedstartseries, aa.beginendseries = bb.receivedendseries, aa.qtybegin = bb.qtyreceived, 
	aa.receivedstartseries = null, aa.receivedendseries = null, aa.qtyreceived = 0 
from af_control_detail aa, ( 
		select rd.objid, rd.receivedstartseries, rd.receivedendseries, rd.qtyreceived 
		from ( 
			select tt.*, (
					select top 1 objid from af_control_detail 
					where controlid = tt.controlid and reftype in ('ISSUE','MANUAL_ISSUE') 
					order by refdate, txndate, indexno 
				) as pdetailid, (
					select top 1 objid from af_control_detail 
					where controlid = tt.controlid and refdate = tt.refdate 
						and reftype = tt.reftype and txntype = tt.txntype and qtyreceived > 0 
					order by refdate, txndate, indexno 
				) as cdetailid 
			from ( 
				select d.controlid, d.reftype, d.txntype, min(d.refdate) as refdate  
				from af_control_detail d 
				where d.reftype = 'remittance' and d.txntype = 'remittance' 
				group by d.controlid, d.reftype, d.txntype 
			)tt 
		)tt 
			inner join af_control_detail rd on rd.objid = tt.cdetailid 
			inner join af_control_detail pd on pd.objid = tt.pdetailid 
		where pd.refdate <> rd.refdate 
	)bb 
where aa.objid = bb.objid 
go 



INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('liquidation_report_show_accountable_forms', '0', 'Show Accoutable Forms in RCD Liquidation Report ', NULL, 'TC')
;




update aa set 
	aa.refdate = bb.receiptdate 
from af_control_detail aa, (
		select t2.*, (select min(receiptdate) from cashreceipt where controlid = t2.controlid) as receiptdate 
		from ( 
			select t1.* 
			from ( 
				select d.controlid, d.refdate, d.reftype, d.refid, d.objid as cdetailid, (
					select top 1 objid from af_control_detail 
						where controlid = d.controlid 
							order by refdate, txndate, indexno 
					) as firstdetailid 
				from aftxn aft 
					inner join aftxnitem afi on afi.parentid = aft.objid 
					inner join af_control_detail d on d.aftxnitemid = afi.objid 
				where aft.txntype = 'FORWARD' 
			)t1, af_control_detail d 
			where d.objid = t1.firstdetailid 
				and d.objid <> t1.cdetailid 
		)t2 
	)bb 
where aa.objid = bb.cdetailid 
	and bb.receiptdate is not null 
; 



EXEC sp_rename N'[dbo].[creditmemo].[payername]', N'_payername', 'COLUMN'
go 
create index ix_payer_name on creditmemo (payer_name)
go 

create index ix_payer_address_objid on creditmemo (payer_address_objid)
go 


EXEC sp_rename N'[dbo].[creditmemo].[payeraddress]', N'_payeraddress', 'COLUMN'
go 
update creditmemo set payer_address_text = _payeraddress where payer_address_text is null 
go 



create index ix_state on fund (state) 
go 


-- create index ix_fund_objid on collectiontype (fund_objid) 
-- go 


-- create index ix_collector_objid on remittance (collector_objid)
-- go 
create index ix_collector_name on remittance (collector_name)
go 
-- create index ix_liquidatingofficer_objid on remittance (liquidatingofficer_objid)
-- go 
create index ix_liquidatingofficer_name on remittance (liquidatingofficer_name) 
go 


create index ix_controlno on remittance_fund (controlno) 
go 
