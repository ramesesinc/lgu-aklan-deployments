use etracs255_aklan
go 


drop index ix_itemid on account_incometarget
go 
delete from account_incometarget where itemid is null 
go 
alter table account_incometarget alter column itemid varchar(50) not null 
go 
create index ix_itemid on account_incometarget (itemid)
go 



alter table account_maingroup alter column title varchar(255) not null 
go 
alter table account_maingroup alter column [version] int not null 
go 


alter table af_allocation alter column name varchar(100) not null 
go 


drop index uix_primary on af_control
go 
drop index ix_afid on af_control
go 
alter table af_control alter column afid varchar(50) not null 
go 
create unique index uix_primary on af_control (afid, startseries, prefix, suffix, ukey)
go 
create index ix_afid on af_control (afid)
go 


drop index uix_primary on af_control
go 
alter table af_control alter column startseries int not null 
go 
alter table af_control alter column currentseries int not null 
go 
alter table af_control alter column endseries int not null 
go 
create unique index uix_primary on af_control (afid, startseries, prefix, suffix, ukey)
go 



update aa set 
	aa.dtfiled = bb.refdate 
from af_control aa, ( 
		select a.objid, 
			(select min(refdate) from af_control_detail where controlid = a.objid) as refdate 
		from af_control a 
		where dtfiled is null 
)bb 
where aa.objid = bb.objid
	and aa.dtfiled is null 
go 

update aa set 
	aa.dtfiled = bb.receiptdate 
from af_control aa, ( 
		select a.objid, 
			(select min(receiptdate) from cashreceipt where controlid = a.objid) as receiptdate  
		from af_control a 
		where dtfiled is null 
)bb 
where aa.objid = bb.objid
	and aa.dtfiled is null 
go 

if object_id('dbo.ztmp_invalid_afcontrol', 'U') IS NOT NULL 
  drop table dbo.ztmp_invalid_afcontrol; 
go 
select objid 
into dbo.ztmp_invalid_afcontrol
from af_control where dtfiled is null 
go 

delete from af_control where objid in (
	select objid from dbo.ztmp_invalid_afcontrol 
)
go 

drop table dbo.ztmp_invalid_afcontrol
go 


drop index ix_dtfiled on af_control
go 
alter table af_control alter column dtfiled date not null 
go 
create index ix_dtfiled on af_control (dtfiled) 
go 


alter table af_control alter column state varchar(50) not null 
go 


drop index ix_state on afrequest 
go 
alter table afrequest alter column state varchar(10) not null 
go 
create index ix_state on afrequest (state)
go 


alter table afrequest add 
	[dtapproved] datetime NULL ,
	[approvedby_objid] varchar(50) NULL ,
	[approvedby_name] varchar(160) NULL 
go 


EXEC sp_rename N'[dbo].[bankaccount_entry]', N'z20181120_bankaccount_entry' 
go 


alter table bankaccount_ledger alter column objid varchar(150) not null
go 
alter table bankaccount_ledger alter column jevid varchar(150) not null
go 
alter table bankaccount_ledger alter column bankacctid varchar(50) not null
go 
alter table bankaccount_ledger alter column itemacctid varchar(50) not null
go 
alter table bankaccount_ledger alter column [dr] decimal(16,4) not null
go 
alter table bankaccount_ledger alter column [cr] decimal(16,4) not null
go 


drop index ix_batchcapture_collection_entry_parentid on batchcapture_collection_entry
go 
alter table batchcapture_collection_entry alter column parentid varchar(50) not null 
go 
create index ix_parentid on batchcapture_collection_entry (parentid)
go 


drop index ix_batchcapture_collection_entry_item_parentid on batchcapture_collection_entry_item
go 
alter table batchcapture_collection_entry_item alter column parentid varchar(50) not null 
go 
create index ix_parentid on batchcapture_collection_entry_item (parentid)
go 


alter table batchcapture_collection_entry_item alter column item_objid varchar(50) not null 
go 


drop index ix_batchcapture_collection_entry_item_item_code on batchcapture_collection_entry_item
go 
alter table batchcapture_collection_entry_item alter column item_code varchar(50) not null 
go 
create index ix_item_code on batchcapture_collection_entry_item (item_code)
go 


alter table batchcapture_collection_entry_item alter column item_title varchar(255) not null 
go 

alter table batchcapture_collection_entry_item alter column fund_objid varchar(100) not null 
go 

alter table batchcapture_collection_entry_item alter column fund_code varchar(50) not null 
go 

alter table batchcapture_collection_entry_item alter column fund_title varchar(50) not null 
go 

alter table batchcapture_collection_entry_item alter column amount decimal(16,2) not null 
go 

create index ix_fund_objid on batchcapture_collection_entry_item (fund_objid)
go 


CREATE TABLE [dbo].[business_application_task_lock] (
[refid] varchar(50) NOT NULL ,
[state] varchar(50) NOT NULL 
)
go 


CREATE TABLE [dbo].[business_closure] (
[objid] varchar(50) NOT NULL ,
[businessid] varchar(50) NOT NULL ,
[dtcreated] datetime NOT NULL ,
[createdby_objid] varchar(50) NOT NULL ,
[createdby_name] varchar(150) NOT NULL ,
[dtceased] date NOT NULL ,
[dtissued] datetime NOT NULL ,
[remarks] text NULL 
)
go 

CREATE TABLE [dbo].[cashbook_revolving_fund] (
[objid] varchar(50) NOT NULL ,
[state] varchar(25) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[issueto_objid] varchar(50) NOT NULL ,
[issueto_name] varchar(150) NOT NULL ,
[controldate] date NOT NULL ,
[amount] decimal(16,2) NOT NULL ,
[remarks] varchar(255) NOT NULL ,
[fund_objid] varchar(100) NOT NULL ,
[fund_title] varchar(255) NOT NULL 
)
go 

CREATE TABLE [dbo].[cashreceipt_changelog] (
[objid] varchar(50) NOT NULL ,
[receiptid] varchar(50) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[action] varchar(255) NOT NULL ,
[remarks] varchar(255) NOT NULL ,
[oldvalue] text NOT NULL ,
[newvalue] text NOT NULL 
)
go 


EXEC sp_rename N'[dbo].[cashreceipt_check]', N'z20181120_cashreceipt_check' 
go 


alter table cashreceiptitem alter column item_code varchar(100) not null 
go 

drop index ix_item_title on cashreceiptitem
go 
alter table cashreceiptitem alter column item_title varchar(100) not null 
go 
create index ix_item_title on cashreceiptitem (item_title)
go 

alter table cashreceiptitem alter column amount decimal(16,4) not null 
go 


alter table cashreceiptpayment_noncash alter column [account_fund_objid] varchar(100) NULL
go 
create index ix_account_fund_objid on cashreceiptpayment_noncash (account_fund_objid) 
go 

alter table cashreceiptpayment_noncash alter column fund_objid varchar(100) NULL
go 


CREATE TABLE [dbo].[checkpayment_dishonored] (
[objid] varchar(50) NOT NULL ,
[checkpaymentid] varchar(50) NOT NULL ,
[dtfiled] datetime NOT NULL ,
[filedby_objid] varchar(50) NOT NULL ,
[filedby_name] varchar(150) NOT NULL ,
[remarks] varchar(255) NOT NULL 
)
go 


alter table collectiongroup_account alter column sortorder int not null 
go 


alter table collectiontype_account alter column objid varchar(100) not null 
go 


drop index ix_liquidationid on collectionvoucher_fund 
go 
alter table collectionvoucher_fund alter column parentid varchar(50) not null 
go 
create index ix_parentid on collectionvoucher_fund (parentid)
go 

alter table collectionvoucher_fund alter column fund_objid varchar(100) not null 
go 
alter table collectionvoucher_fund alter column fund_title varchar(100) not null 
go 
alter table collectionvoucher_fund alter column amount decimal(16,4) not null 
go 
alter table collectionvoucher_fund alter column totalcash decimal(16,4) not null 
go 
alter table collectionvoucher_fund alter column totalcheck decimal(16,4) not null 
go 
alter table collectionvoucher_fund alter column totalcr decimal(16,4) not null 
go 


alter table creditmemotype alter column fund_objid varchar(100) null 
go 
create index ix_fund_objid on creditmemotype (fund_objid) 
go 


drop index ix_state on depositvoucher 
go 
alter table depositvoucher alter column state varchar(50) not null 
go 
create index ix_state on depositvoucher (state) 
go 

drop index ix_controlno on depositvoucher 
go 
alter table depositvoucher alter column controlno varchar(50) not null 
go 
create index ix_controlno on depositvoucher (controlno) 
go 

drop index ix_controldate on depositvoucher
go 
alter table depositvoucher alter column controldate date not null 
go 
create index ix_controldate on depositvoucher (controldate) 
go 

drop index ix_dtcreated on depositvoucher
go 
alter table depositvoucher alter column dtcreated datetime not null 
go 
create index ix_dtcreated on depositvoucher (dtcreated) 
go 

drop index ix_createdby_objid on depositvoucher
go 
drop index ix_createdby_name on depositvoucher
go 

alter table depositvoucher alter column createdby_objid varchar(50) not null 
go 
alter table depositvoucher alter column createdby_name varchar(255) not null 
go 
alter table depositvoucher alter column amount decimal(16,4) not NULL 
go 


alter table depositvoucher_fund alter column state varchar(20) not null 
go 


drop index ix_parentid on depositvoucher_fund
go 
alter table depositvoucher_fund alter column parentid varchar(50) not null 
go 
create index ix_parentid on depositvoucher_fund (parentid)
go 

drop index ix_fundid on depositvoucher_fund
go 
alter table depositvoucher_fund alter column fundid varchar(100) not null 
go 
create index ix_fundid on depositvoucher_fund (fundid)
go 

alter table depositvoucher_fund alter column amount decimal(16,4) not null 
go 
alter table depositvoucher_fund alter column amountdeposited decimal(16,4) not null 
go 
update depositvoucher_fund set totaldr=0 where totaldr is null 
go 
update depositvoucher_fund set totalcr=0 where totalcr is null 
go 
alter table depositvoucher_fund alter column totaldr decimal(16,4) not null 
go 
alter table depositvoucher_fund alter column totalcr decimal(16,4) not null 
go 


alter table eftpayment alter column state varchar(50) not null 
go 

drop index ix_refno on eftpayment 
go 
alter table eftpayment alter column refno varchar(50) not null 
go 
create index ix_refno on eftpayment (refno)
go 

alter table eftpayment alter column refdate date not null 
go 
alter table eftpayment alter column amount decimal(16,4) not null 
go 

drop index ix_bankacctid on eftpayment 
go 
alter table eftpayment alter column bankacctid varchar(50) not null 
go 
create index ix_bankacctid on eftpayment (bankacctid)
go 

alter table eftpayment alter column createdby_objid varchar(50) not null 
go 
alter table eftpayment alter column createdby_name varchar(255) not null 
go 


drop index ix_entityname on entity 
go 
alter table entity alter column entityname varchar(900) not null 
go 
create index ix_entityname on entity (entityname)
go 

alter table entity add state varchar(25) NULL 
go 
update entity set state = 'ACTIVE' where state is null 
go 
create index ix_state on entity (state)
go 


CREATE TABLE [dbo].[entityidcard] (
[objid] varchar(50) NOT NULL ,
[entityid] varchar(50) NOT NULL ,
[idtype] varchar(50) NOT NULL ,
[idno] varchar(25) NOT NULL ,
[expiry] varchar(50) NULL 
)
go


alter table entityjuridical alter column administrator_address_text varchar(255) null 
go 


drop table epayment
go 


alter table fundgroup alter column title varchar(100) not null 
go 
alter table fundgroup alter column indexno int not null 
go 


CREATE TABLE [dbo].[holiday] (
[objid] varchar(50) NOT NULL ,
[year] int NULL ,
[month] int NULL ,
[day] int NULL ,
[week] int NULL ,
[dow] int NULL ,
[name] varchar(255) NULL 
)
go 


drop index ix_jevid on income_ledger
go 
alter table income_ledger alter column jevid varchar(150) not null 
go 
create index ix_jevid on income_ledger (jevid)
go 

alter table income_ledger alter column dr decimal(16,4) not null 
go 
alter table income_ledger alter column cr decimal(16,4) not null 
go 



alter table itemaccount alter column sortorder int null
go 
alter table itemaccount add default 0 for sortorder
go 
update itemaccount set sortorder=0 where sortorder is null 
go 
alter table itemaccount alter column sortorder int not null
go 



update itemaccount_tag set objid=NEWID() where objid is null 
go 
alter table itemaccount_tag alter column objid varchar(50) not null 
go 
alter table itemaccount_tag drop constraint PK__itemacco__F0D46B2B3DF3E806
go 
alter table itemaccount_tag add constraint pk_itemaccount_tag primary key(objid)
go 



CREATE TABLE [dbo].[lob_report_category] (
[objid] varchar(50) NOT NULL ,
[parentid] varchar(50) NULL ,
[groupid] varchar(50) NULL ,
[title] varchar(255) NULL ,
[itemtype] varchar(25) NULL 
)
go

CREATE TABLE [dbo].[lob_report_category_mapping] (
[objid] varchar(50) NOT NULL ,
[lobid] varchar(50) NOT NULL ,
[categoryid] varchar(50) NOT NULL 
)
go 

CREATE TABLE [dbo].[lob_report_group] (
[objid] varchar(50) NOT NULL ,
[title] varchar(255) NULL 
)
go 


drop table payable_summary
go 


drop index uix_remittance_fund on remittance_fund 
go 
alter table remittance_fund alter column remittanceid varchar(50) not null 
go 
create index uix_remittance_fund on remittance_fund (remittanceid, fund_objid)
go 
create index ix_remittanceid on remittance_fund (remittanceid)
go 

alter table remittance_fund alter column [amount] decimal(16,4) not NULL
go 


alter table sys_requirement_type alter column title varchar(255) not null 
go 


alter table sys_rule alter column name varchar(255) not null 
go 

alter table sys_rule add default 1 for noloop
go 


drop index parentid on sys_rule_action_param
go 
alter table sys_rule_action_param alter column [parentid] varchar(50) NOT NULL
go
create index ix_parentid on sys_rule_action_param (parentid)
go 

alter table sys_rule_action_param alter column [actiondefparam_objid] varchar(255) NOT NULL
go


alter table sys_rule_actiondef alter column actionclass varchar(255) null 
go 


drop index parentid on sys_rule_condition
go 
alter table sys_rule_condition alter column parentid varchar(50) not null 
go 
create index ix_parentid on sys_rule_condition (parentid)
go 


alter table sys_rule_condition add default 0 for notexist
go 


alter table sys_rule_condition_constraint alter column field_objid varchar(255) null 
go 


drop index parentid on sys_rule_condition_var
go 
alter table sys_rule_condition_var alter column parentid varchar(50) not null 
go 
create index ix_parentid on sys_rule_condition_var (parentid)
go 


alter table sys_rule_fact_field alter column objid varchar(255) not null 
go 


alter table sys_usergroup_member drop constraint FK_sys_usergroup_member_securitygorup
go 
alter table sys_usergroup_member drop constraint sys_usergroup_member_ibfk_3
go 
alter table sys_usergroup_member alter column securitygroup_objid varchar(100) null 
go 

alter table sys_securitygroup alter column objid varchar(100) not null 
go 

alter table sys_usergroup_member add constraint fk_sys_usergroup_member_securitygroup_objid 
	foreign key (securitygroup_objid) REFERENCES sys_securitygroup (objid)
go 


alter table sys_session add terminalid varchar(50) null 
go 

alter table sys_session_log add terminalid varchar(50) null 
go 


create unique index uix_username on sys_user (username) 
go 


alter table sys_usergroup_permission alter column objid varchar(100) not null 
go 


CREATE INDEX [ix_code] ON [dbo].[account]
([code] ASC) 
go 

CREATE INDEX [uix_maingroupid_code] ON [dbo].[account]
([maingroupid] ASC, [code] ASC) 
GO

CREATE INDEX [ix_year] ON [dbo].[account_incometarget]
([year] ASC) 
GO


CREATE INDEX [ix_name] ON [dbo].[af_allocation]
([name] ASC) 
GO
CREATE INDEX [ix_respcenter_objid] ON [dbo].[af_allocation]
([respcenter_objid] ASC) 
GO
CREATE INDEX [ix_respcenter_name] ON [dbo].[af_allocation]
([respcenter_name] ASC) 
GO

CREATE INDEX [ix_state] ON [dbo].[af_control]
([state] ASC) 
GO
CREATE INDEX [ix_allocid] ON [dbo].[af_control]
([allocid] ASC) 
GO

CREATE INDEX [ix_dtapproved] ON [dbo].[afrequest]
([dtapproved] ASC) 
GO
CREATE INDEX [ix_approvedby_objid] ON [dbo].[afrequest]
([approvedby_objid] ASC) 
GO
CREATE INDEX [ix_approvedby_name] ON [dbo].[afrequest]
([approvedby_name] ASC) 
GO


CREATE INDEX [ix_jevid] ON [dbo].[bankaccount_ledger]
([jevid] ASC) 
GO
CREATE INDEX [ix_bankacctid] ON [dbo].[bankaccount_ledger]
([bankacctid] ASC) 
GO
CREATE INDEX [ix_itemacctid] ON [dbo].[bankaccount_ledger]
([itemacctid] ASC) 
GO


CREATE INDEX [ix_yearstate] ON [dbo].[business_application]
([appyear] ASC, [state] ASC) 
go 


ALTER TABLE [dbo].[business_application_task_lock] ADD PRIMARY KEY ([refid], [state])
GO
create index ix_refid on business_application_task_lock (refid)
go 


CREATE INDEX [ix_businessid] ON [dbo].[business_closure]
([businessid] ASC) 
GO
CREATE INDEX [ix_dtcreated] ON [dbo].[business_closure]
([dtcreated] ASC) 
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[business_closure]
([createdby_objid] ASC) 
GO
CREATE INDEX [ix_createdby_name] ON [dbo].[business_closure]
([createdby_name] ASC) 
GO
CREATE INDEX [ix_dtceased] ON [dbo].[business_closure]
([dtceased] ASC) 
GO
CREATE INDEX [ix_dtissued] ON [dbo].[business_closure]
([dtissued] ASC) 
GO

ALTER TABLE [dbo].[business_closure] ADD constraint pk_business_closure PRIMARY KEY ([objid])
GO


if object_id('dbo.ztmp_duplicate_business_recurringfee', 'U') IS NOT NULL 
  drop table dbo.ztmp_duplicate_business_recurringfee; 
go 
select r.objid 
into dbo.ztmp_duplicate_business_recurringfee 
from ( 
	select t1.*, 
		( 
			select top 1 objid from business_recurringfee 
			where businessid = t1.businessid and account_objid = t1.account_objid 
			order by amount desc 
		) as recfeeid  
	from ( 
		select businessid, account_objid, count(*) as icount  
		from business_recurringfee
		group by businessid, account_objid 
		having count(*) > 1
	)t1 
)t2, business_recurringfee r 
where r.businessid = t2.businessid 
	and r.account_objid = t2.account_objid 
	and r.objid <> t2.recfeeid 
go 
delete from business_recurringfee where objid in (
	select objid from dbo.ztmp_duplicate_business_recurringfee 
)
go 
drop table dbo.ztmp_duplicate_business_recurringfee
go 

CREATE UNIQUE INDEX [uix_businessid_acctid] ON [dbo].[business_recurringfee]
([businessid] ASC, [account_objid] ASC) 
GO



CREATE INDEX [ix_state] ON [dbo].[cashbook_revolving_fund]
([state] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[cashbook_revolving_fund]
([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[cashbook_revolving_fund]
([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[cashbook_revolving_fund]
([filedby_name] ASC) 
GO
CREATE INDEX [ix_issueto_objid] ON [dbo].[cashbook_revolving_fund]
([issueto_objid] ASC) 
GO
CREATE INDEX [ix_issueto_name] ON [dbo].[cashbook_revolving_fund]
([issueto_name] ASC) 
GO
CREATE INDEX [ix_controldate] ON [dbo].[cashbook_revolving_fund]
([controldate] ASC) 
GO
CREATE INDEX [ix_fund_objid] ON [dbo].[cashbook_revolving_fund]
([fund_objid] ASC) 
GO
CREATE INDEX [ix_fund_title] ON [dbo].[cashbook_revolving_fund]
([fund_title] ASC) 
GO

ALTER TABLE [dbo].[cashbook_revolving_fund] ADD constraint pk_cashbook_revolving_fund PRIMARY KEY ([objid])
GO


alter table cashreceipt add ukey varchar(50) not null default ''
go 
update cashreceipt set ukey = convert(varchar(50), HashBytes('MD5', objid), 2) 
go 
create index ix_ukey on cashreceipt (ukey)
go 
CREATE UNIQUE INDEX [uix_receiptno] ON [dbo].[cashreceipt]
(formno, receiptno, ukey) 
go 


CREATE UNIQUE INDEX [uix_receiptid] ON [dbo].[cashreceipt_cancelseries]
([receiptid] ASC) 
GO


CREATE INDEX [ix_receiptid] ON [dbo].[cashreceipt_changelog]
([receiptid] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[cashreceipt_changelog]
([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[cashreceipt_changelog]
([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[cashreceipt_changelog]
([filedby_name] ASC) 
GO
CREATE INDEX [ix_action] ON [dbo].[cashreceipt_changelog]
([action] ASC) 
GO

ALTER TABLE [dbo].[cashreceipt_changelog] ADD constraint pk_cashreceipt_changelog PRIMARY KEY ([objid])
GO


CREATE INDEX [ix_item_code] ON [dbo].[cashreceiptitem]
([item_code] ASC) 
GO


CREATE INDEX [ix_txnno] ON [dbo].[certification]
([txnno] ASC) 
GO
CREATE INDEX [ix_txndate] ON [dbo].[certification]
([txndate] ASC) 
GO
CREATE INDEX [ix_type] ON [dbo].[certification]
([type] ASC) 
GO
CREATE INDEX [ix_name] ON [dbo].[certification]
([name] ASC) 
GO
CREATE INDEX [ix_orno] ON [dbo].[certification]
([orno] ASC) 
GO
CREATE INDEX [ix_ordate] ON [dbo].[certification]
([ordate] ASC) 
GO
CREATE INDEX [ix_createdbyid] ON [dbo].[certification]
([createdbyid] ASC) 
GO
CREATE INDEX [ix_createdby] ON [dbo].[certification]
([createdby] ASC) 
GO


CREATE INDEX [ix_checkpaymentid] ON [dbo].[checkpayment_dishonored]
([checkpaymentid] ASC) 
GO
CREATE INDEX [ix_dtfiled] ON [dbo].[checkpayment_dishonored]
([dtfiled] ASC) 
GO
CREATE INDEX [ix_filedby_objid] ON [dbo].[checkpayment_dishonored]
([filedby_objid] ASC) 
GO
CREATE INDEX [ix_filedby_name] ON [dbo].[checkpayment_dishonored]
([filedby_name] ASC) 
GO

ALTER TABLE [dbo].[checkpayment_dishonored] ADD constraint pk_checkpayment_dishonored PRIMARY KEY ([objid])
GO


CREATE INDEX [ix_state] ON [dbo].[collectiongroup]
([state] ASC) 
GO


alter table collectiongroup_account drop constraint PK__collecti__BA8154AD0757E033
go 
alter table collectiongroup_account add constraint pk_collectiongroup_account primary key (objid)
go 


CREATE INDEX [ix_state] ON [dbo].[collectiontype]
([state] ASC) 
GO


alter table collectiontype_account drop constraint PK__collecti__56B943F9527A03A0
go 
ALTER TABLE [dbo].[collectiontype_account] ADD constraint pk_collectiontype_account PRIMARY KEY ([objid])
GO


CREATE INDEX [ix_controldate] ON [dbo].[collectionvoucher]
([controldate] ASC) 
GO


alter table collectionvoucher_fund add ukey varchar(50) not null default ''
go 
update collectionvoucher_fund set ukey = convert(varchar(50), HashBytes('MD5', objid), 2) 
go 
create index ix_ukey on collectionvoucher_fund (ukey)
go 
CREATE UNIQUE INDEX [uix_parentid_fund_objid] ON [dbo].[collectionvoucher_fund]
([parentid] ASC, [fund_objid] ASC, [ukey] asc) 
GO


CREATE INDEX [ix_controlno] ON [dbo].[collectionvoucher_fund]
([controlno] ASC) 
GO
CREATE INDEX [ix_fund_objid] ON [dbo].[collectionvoucher_fund]
([fund_objid] ASC) 
go 


CREATE INDEX [ix_createdby_name] ON [dbo].[depositslip]
([createdby_name] ASC) 
GO
CREATE INDEX [ix_validation_refno] ON [dbo].[depositslip]
([validation_refno] ASC) 
GO
CREATE INDEX [ix_validation_refdate] ON [dbo].[depositslip]
([validation_refdate] ASC) 
GO


CREATE UNIQUE INDEX [uix_controlno] ON [dbo].[depositvoucher]
([controlno] ASC) 
GO


CREATE UNIQUE INDEX [uix_parentid_fundid] ON [dbo].[depositvoucher_fund]
([parentid] ASC, [fundid] ASC) 
GO
CREATE INDEX [ix_state] ON [dbo].[depositvoucher_fund]
([state] ASC) 
GO

CREATE INDEX [ix_dtposted] ON [dbo].[depositvoucher_fund]
([dtposted] ASC) 
GO
CREATE INDEX [ix_postedby_objid] ON [dbo].[depositvoucher_fund]
([postedby_objid] ASC) 
GO
CREATE INDEX [ix_postedby_name] ON [dbo].[depositvoucher_fund]
([postedby_name] ASC) 
GO

CREATE INDEX [ix_state] ON [dbo].[eftpayment]
([state] ASC) 
go 
CREATE INDEX [ix_refdate] ON [dbo].[eftpayment]
([refdate] ASC) 
GO
CREATE INDEX [ix_createdby_objid] ON [dbo].[eftpayment]
([createdby_objid] ASC) 
GO
CREATE INDEX [ix_receiptid] ON [dbo].[eftpayment]
([receiptid] ASC) 
GO
CREATE INDEX [ix_payer_objid] ON [dbo].[eftpayment]
([payer_objid] ASC) 
GO
CREATE INDEX [ix_payer_address_objid] ON [dbo].[eftpayment]
([payer_address_objid] ASC) 
GO


update entity set entityname=substring(entityname, 1, 800) 
go 
drop index ix_entityname_state on entity 
go 
alter table entity alter column entityname varchar(800) not null 
go 
create index ix_entityname_state on entity (state, entityname)
go 
create index ix_entityname on entity (entityname)
go 


CREATE UNIQUE INDEX [uix_idtype_idno] ON [dbo].[entityid]
([idtype] ASC, [idno] ASC) 
GO


CREATE INDEX [ix_entityidcard] ON [dbo].[entityidcard]
([entityid] ASC) 
GO
ALTER TABLE [dbo].[entityidcard] ADD constraint pk_entityidcard PRIMARY KEY ([objid])
GO
ALTER TABLE [dbo].[entityidcard] ADD UNIQUE ([entityid] ASC, [idtype] ASC, [idno] ASC)
GO


ALTER TABLE [dbo].[holiday] ADD constraint pk_holiday PRIMARY KEY ([objid])
GO


CREATE INDEX [ix_orgid] ON [dbo].[income_summary]
([orgid] ASC) 
GO


if object_id('dbo.ztmp_duplicate_income_summary', 'U') IS NOT NULL 
  drop table dbo.ztmp_duplicate_income_summary; 
go 
select inc.remittanceid, inc.remittancedate, inc.acctid, inc.fundid  
into dbo.ztmp_duplicate_income_summary
from ( 
	select 
		remittanceid, acctid, fundid, 
		min(remittancedate) as minremdate, max(remittancedate) as maxremdate 
	from income_summary 
	group by remittanceid, acctid, fundid 
	having min(remittancedate) <> max(remittancedate)
)t1, income_summary inc 
where inc.remittanceid = t1.remittanceid 
	and inc.remittancedate = t1.maxremdate  
	and inc.acctid = t1.acctid 
	and inc.fundid = t1.fundid 
go 
delete aa 
from income_summary aa, ztmp_duplicate_income_summary z 
where aa.remittanceid = z.remittanceid 
	and aa.remittancedate = z.remittancedate 
	and aa.acctid = z.acctid 
	and aa.fundid = z.fundid 
go 
drop table dbo.ztmp_duplicate_income_summary
go 

ALTER TABLE [dbo].[income_summary] drop constraint pk_income_summary 
go 
ALTER TABLE [dbo].[income_summary] ADD constraint pk_income_summary 
	PRIMARY KEY ([refid], [refdate], [fundid], [acctid], [orgid], [remittanceid], [liquidationid])
GO


CREATE UNIQUE INDEX [uix_acctid_tag] ON [dbo].[itemaccount_tag]
([acctid] ASC, [tag] ASC) 
GO
CREATE INDEX [ix_acctid] ON [dbo].[itemaccount_tag]
([acctid] ASC) 
GO

alter table itemaccount_tag drop constraint pk_itemaccount_tag 
go 
ALTER TABLE [dbo].[itemaccount_tag] ADD constraint pk_itemaccount_tag 
	PRIMARY KEY ([objid])
GO


CREATE INDEX [ix_classification_objid] ON [dbo].[lob]
([classification_objid] ASC) 
go 

alter table lobclassification add constraint pk_lobclassification primary key (objid)
go 
create unique index uix_name on lobclassification (name)
go 

alter table lob add constraint fk_lob_classification_objid 
	foreign key (classification_objid) references lobclassification (objid)
go 


create unique index uix_name on lob (name)
go 


CREATE INDEX [ix_parentid] ON [dbo].[lob_report_category]
([parentid] ASC) 
GO
CREATE INDEX [ix_groupid] ON [dbo].[lob_report_category]
([groupid] ASC) 
GO
ALTER TABLE [dbo].[lob_report_category] ADD constraint pk_lob_report_category PRIMARY KEY ([objid])
GO


CREATE UNIQUE INDEX [uix_categoryid] ON [dbo].[lob_report_category_mapping]
([categoryid] ASC) 
GO
CREATE INDEX [ix_lobid] ON [dbo].[lob_report_category_mapping]
([lobid] ASC) 
GO
ALTER TABLE [dbo].[lob_report_category_mapping] ADD constraint pk_lob_report_category_mapping PRIMARY KEY ([objid])
GO


ALTER TABLE [dbo].[lob_report_group] ADD constraint pk_lob_report_group PRIMARY KEY ([objid])
GO


CREATE UNIQUE INDEX [uix_controlno] ON [dbo].[remittance]
([controlno] ASC) 
go 


CREATE UNIQUE INDEX [uix_remittanceid_fund_objid] ON [dbo].[remittance_fund]
([remittanceid] ASC, [fund_objid] ASC) 
GO


CREATE INDEX [ix_refid] ON [dbo].[txnlog]
([refid] ASC) 
GO


ALTER TABLE [dbo].[af_control] ADD constraint fk_af_control_afid 
	FOREIGN KEY ([afid]) REFERENCES [dbo].[af] ([objid]) 
GO

ALTER TABLE [dbo].[af_control_detail] ADD constraint fk_af_control_detail_aftxnitemid 
	FOREIGN KEY ([aftxnitemid]) REFERENCES [dbo].[aftxnitem] ([objid]) 
GO

ALTER TABLE [dbo].[afrequestitem] ADD constraint fk_afrequestitem_parentid 
	FOREIGN KEY ([parentid]) REFERENCES [dbo].[afrequest] ([objid]) 
GO

ALTER TABLE [dbo].[bankaccount] ADD constraint fk_bankaccount_acctid 
	FOREIGN KEY ([acctid]) REFERENCES [dbo].[itemaccount] ([objid]) 
GO


ALTER TABLE [dbo].[bankaccount_ledger] ADD constraint fk_bankaccount_ledger_jevid 
	FOREIGN KEY ([jevid]) REFERENCES [dbo].[jev] ([objid]) 
GO

ALTER TABLE [dbo].[batchcapture_collection_entry_item] ADD constraint fk_batchcapture_collection_entry_item_fund_objid 
	FOREIGN KEY ([fund_objid]) REFERENCES [dbo].[fund] ([objid]) 
GO

ALTER TABLE [dbo].[business_application_lob] ADD constraint fk_business_application_lob_businessid 
	FOREIGN KEY ([businessid]) REFERENCES [dbo].[business] ([objid]) 
GO

ALTER TABLE [dbo].[business_application_task_lock] ADD constraint fk_business_application_task_lock_refid 
	FOREIGN KEY ([refid]) REFERENCES [dbo].[business_application] ([objid]) 
GO

ALTER TABLE [dbo].[business_closure] ADD constraint fk_business_closure_businessid 
	FOREIGN KEY ([businessid]) REFERENCES [dbo].[business] ([objid]) 
GO

ALTER TABLE [dbo].[business_payment] ADD constraint fk_business_payment_businessid 
	FOREIGN KEY ([businessid]) REFERENCES [dbo].[business] ([objid]) 
GO


update aa set 
	aa.subcollector_remittanceid = null 
from cashreceipt aa, ( 
	select c.objid, c.subcollector_remittanceid 
	from cashreceipt c 
		left join subcollector_remittance r on r.objid = c.subcollector_remittanceid 
	where c.subcollector_remittanceid is not null 
)bb 
where aa.objid = bb.objid
go 

ALTER TABLE [dbo].[cashreceipt] ADD constraint fk_cashreceipt_subcollector_remittanceid
	FOREIGN KEY ([subcollector_remittanceid]) REFERENCES [dbo].[subcollector_remittance] ([objid]) 
GO


ALTER TABLE [dbo].[cashreceipt_changelog] ADD constraint fk_cashreceipt_changelog_receiptid 
	FOREIGN KEY ([receiptid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
GO


delete aa 
from cashreceipt_reprint_log aa, ( 
	select l.*   
	from cashreceipt_reprint_log l 
		left join cashreceipt c on c.objid = l.receiptid 
	where l.receiptid is not null 
		and c.objid is null 
)bb 
where aa.objid = bb.objid 
go 

ALTER TABLE [dbo].[cashreceipt_reprint_log] ADD constraint fk_cashreceipt_reprint_log
	FOREIGN KEY ([receiptid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
GO


ALTER TABLE [dbo].[cashreceipt_share] ADD constraint fk_cashreceipt_share_payableitem_objid 
	FOREIGN KEY ([payableitem_objid]) REFERENCES [dbo].[itemaccount] ([objid]) 
GO
ALTER TABLE [dbo].[cashreceipt_share] ADD constraint fk_cashreceipt_share_receiptid
	FOREIGN KEY ([receiptid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
GO
ALTER TABLE [dbo].[cashreceipt_share] ADD constraint fk_cashreceipt_share_refitem_objid
	FOREIGN KEY ([refitem_objid]) REFERENCES [dbo].[itemaccount] ([objid]) 
GO


delete aa 
from cashreceiptitem aa, ( 
	select ci.objid  
	from cashreceiptitem ci 
		left join cashreceipt c on c.objid = ci.receiptid 
	where ci.receiptid is not null 
		and c.objid is null 
)bb 
where aa.objid = bb.objid 
go 

ALTER TABLE [dbo].[cashreceiptitem] ADD constraint fk_cashreceiptitem_receiptid 
	FOREIGN KEY ([receiptid]) REFERENCES [dbo].[cashreceipt] ([objid]) 
GO


ALTER TABLE [dbo].[cashreceiptpayment_noncash] ADD constraint fk_cashreceiptpayment_noncash_fund_objid 
	FOREIGN KEY ([fund_objid]) REFERENCES [dbo].[fund] ([objid]) 
GO


ALTER TABLE [dbo].[checkpayment_dishonored] ADD constraint fk_checkpayment_dishonored_checkpaymentid 
	FOREIGN KEY ([checkpaymentid]) REFERENCES [dbo].[checkpayment] ([objid]) 
GO


ALTER TABLE [dbo].[collectiongroup_account] ADD constraint fk_collectiongroup_account_collectiongroupid 
	FOREIGN KEY ([collectiongroupid]) REFERENCES [dbo].[collectiongroup] ([objid]) 
GO


alter table collectiontype alter column fund_objid varchar(100) null 
go 
ALTER TABLE [dbo].[collectiontype] ADD constraint fk_collectiontype_fund_objid 
	FOREIGN KEY ([fund_objid]) REFERENCES [dbo].[fund] ([objid]) 
GO


ALTER TABLE [dbo].[collectiontype_account] ADD constraint fk_collectiontype_account_collectiontypeid
	FOREIGN KEY ([collectiontypeid]) REFERENCES [dbo].[collectiontype] ([objid]) 
GO
ALTER TABLE [dbo].[collectiontype_account] ADD constraint fk_collectiontype_account_account_objid
	FOREIGN KEY ([account_objid]) REFERENCES [dbo].[itemaccount] ([objid]) 
GO


ALTER TABLE [dbo].[creditmemotype] ADD constraint fk_creditmemotype_fund_objid 
	FOREIGN KEY ([fund_objid]) REFERENCES [dbo].[fund] ([objid]) 
GO


delete aa 
from entity_address aa, ( 
	select ea.objid 
	from entity_address ea 
		left join entity e on e.objid = ea.parentid 
	where ea.parentid is not null 
		and e.objid is null 
)bb 
where aa.objid = bb.objid 
go 

ALTER TABLE [dbo].[entity_address] ADD constraint fk_entity_address_parentid 
	FOREIGN KEY ([parentid]) REFERENCES [dbo].[entity] ([objid]) 
GO


ALTER TABLE [dbo].[entityid] ADD constraint fk_entityid_entityid 
	FOREIGN KEY ([entityid]) REFERENCES [dbo].[entity] ([objid]) 
GO


delete aa 
from entityindividual aa, ( 
	select ei.objid 
	from entityindividual ei 
		left join entity e on e.objid = ei.objid 
	where ei.objid is not null 
		and e.objid is null 
)bb 
where aa.objid = bb.objid 
go 

ALTER TABLE [dbo].[entityindividual] ADD constraint fk_entityindividual_objid 
	FOREIGN KEY ([objid]) REFERENCES [dbo].[entity] ([objid]) 
GO


delete aa 
from entityjuridical aa, ( 
	select ei.objid 
	from entityjuridical ei 
		left join entity e on e.objid = ei.objid 
	where ei.objid is not null 
		and e.objid is null 
)bb 
where aa.objid = bb.objid 
go 

ALTER TABLE [dbo].[entityjuridical] ADD constraint fk_entityjuridical_objid 
	FOREIGN KEY ([objid]) REFERENCES [dbo].[entity] ([objid]) 
GO


ALTER TABLE [dbo].[fund] ADD constraint fk_fund_groupid  
	FOREIGN KEY ([groupid]) REFERENCES [dbo].[fundgroup] ([objid]) 
GO


ALTER TABLE [dbo].[jevitem] ADD constraint fk_jevitem_jevid 
	FOREIGN KEY ([jevid]) REFERENCES [dbo].[jev] ([objid]) 
GO


ALTER TABLE [dbo].[lob_report_category] ADD constraint fk_lob_report_category_groupid 
	FOREIGN KEY ([groupid]) REFERENCES [dbo].[lob_report_group] ([objid]) 
GO


ALTER TABLE [dbo].[lob_report_category_mapping] ADD constraint fk_lob_report_category_mapping_categoryid 
	FOREIGN KEY ([categoryid]) REFERENCES [dbo].[lob_report_category] ([objid]) 
GO


ALTER TABLE [dbo].[remittance] ADD constraint fk_remittance_collectionvoucherid 
	FOREIGN KEY ([collectionvoucherid]) REFERENCES [dbo].[collectionvoucher] ([objid]) 
GO


delete aa 
from remittance_fund aa, ( 
	select rf.objid 
	from remittance_fund rf 
		left join fund on fund.objid = rf.fund_objid 
	where rf.fund_objid is not null 
		and fund.objid is null 
)bb 
where aa.objid = bb.objid 
go 


ALTER TABLE [dbo].[remittance_fund] ADD constraint fk_remittance_fund_fund_objid
	FOREIGN KEY ([fund_objid]) REFERENCES [dbo].[fund] ([objid]) 
GO
