use etracs255_aklan
go

-- create index ix_assignee_objid on af_control (assignee_objid)
-- go 
-- create index ix_fund_objid on af_control (fund_objid)
-- go 
-- create index ix_owner_objid on af_control (owner_objid)
-- go 
-- create index ix_owner_name on af_control (owner_name)
-- go 
-- create index ix_afid on af_control (afid)
-- go 

-- create index ix_capturedby_objid on batchcapture_collection (capturedby_objid)
-- go 
-- create index ix_collectiontype_objid on batchcapture_collection (collectiontype_objid)
-- go 
-- create index ix_controlid on batchcapture_collection (controlid)
-- go 
create index ix_defaultreceiptdate on batchcapture_collection (defaultreceiptdate)
go 
-- create index ix_formno on batchcapture_collection (formno)
-- go 
-- create index ix_org_objid on batchcapture_collection (org_objid)
-- go 
-- create index ix_postedby_objid on batchcapture_collection (postedby_objid)
-- go 
-- create index ix_state on batchcapture_collection (state)
-- go 

-- create index ix_currentpermitid on business (currentpermitid)
-- go 
-- create index ix_owner_address_objid on business (owner_address_objid)
-- go 
-- create index ix_owner_name on business (owner_name)
-- go 
-- create index ix_owner_objid on business (owner_objid)
-- go 
-- create index ix_tradename on business (tradename)
-- go 
-- create index ix_yearstarted on business (yearstarted)
-- go 

-- create index ix_attribute_name on business_active_info (attribute_name)
-- go 
-- create index ix_attribute_objid on business_active_info (attribute_objid)
-- go 
-- create index ix_lob_name on business_active_info (lob_name)
-- go 
-- create index ix_lob_objid on business_active_info (lob_objid)
-- go 


-- alter table business_active_info add CONSTRAINT fk_business_active_info_lob_objid 
--   FOREIGN KEY (lob_objid) REFERENCES lob (objid)
-- go

-- create index ix_lobid on business_active_lob (lobid)
-- go 
-- create index ix_name on business_active_lob (name)
-- go 

-- alter table business_active_lob add CONSTRAINT fk_business_active_lob_lobid 
--   FOREIGN KEY (lobid) REFERENCES lob (objid)
-- go

-- create index ix_barangay_objid on business_address (barangay_objid)
-- go 
-- create index ix_businessid on business_address (businessid)
-- go 
-- create index ix_lessor_address_objid on business_address (lessor_address_objid)
-- go 
-- create index ix_lessor_objid on business_address (lessor_objid)
-- go 

-- create index ix_approver_objid on business_application (approver_objid)
-- go 
-- create index ix_appyear on business_application (appyear)
-- go 
-- create index ix_assessor_objid on business_application (assessor_objid)
-- go 
-- create index ix_businessaddress on business_application (businessaddress)
-- go 
-- create index ix_createdby_objid on business_application (createdby_objid)
-- go 
-- create index ix_dtfiled on business_application (dtfiled)
-- go 
-- create index ix_dtreleased on business_application (dtreleased)
-- go 
-- create index ix_nextbilldate on business_application (nextbilldate)
-- go 
-- create index ix_owneraddress on business_application (owneraddress)
-- go 
-- create index ix_ownername on business_application (ownername)
-- go 
-- create index ix_permit_objid on business_application (permit_objid)
-- go 
-- create index ix_state on business_application (state)
-- go 
-- create index ix_tradename on business_application (tradename)
-- go 
-- create index ix_txndate on business_application (txndate)
-- go 

-- create index ix_activeyear on business_application_info (activeyear)
-- go 
-- create index ix_attribute_objid on business_application_info (attribute_objid)
-- go 
-- create index ix_lob_objid on business_application_info (lob_objid)
-- go 

-- alter table business_application_info add CONSTRAINT fk_business_info_business_lob_objid 
--   FOREIGN KEY (lob_objid) REFERENCES lob (objid)
-- go

-- create index ix_activeyear on business_application_lob (activeyear)
-- go 
-- create index ix_name on business_application_lob (name)
-- go 
-- alter table business_application_lob add CONSTRAINT fk_business_application_lob_lobid 
--   FOREIGN KEY (lobid) REFERENCES lob (objid)
-- go

-- create index ix_actor_objid on business_application_task (actor_objid)
-- go 
-- create index ix_assignee_objid on business_application_task (assignee_objid)
-- go 
-- create index ix_enddate on business_application_task (enddate)
-- go 
-- create index ix_parentprocessid on business_application_task (parentprocessid)
-- go 
-- create index ix_startdate on business_application_task (startdate)
-- go 

-- create index ix_actor_objid on business_application_workitem (actor_objid)
-- go 
-- create index ix_assignee_objid on business_application_workitem (assignee_objid)
-- go 
-- create index ix_enddate on business_application_workitem (enddate)
-- go 
-- create index ix_refid on business_application_workitem (refid)
-- go 
-- create index ix_startdate on business_application_workitem (startdate)
-- go 
-- create index ix_workitemid on business_application_workitem (workitemid)
-- go 

-- create index ix_barangay_objid on business_lessor (barangay_objid)
-- go 
-- create index ix_bldgname on business_lessor (bldgname)
-- go 
-- create index ix_bldgno on business_lessor (bldgno)
-- go 
-- create index ix_lessor_address_objid on business_lessor (lessor_address_objid)
-- go 
-- create index ix_lessor_objid on business_lessor (lessor_objid)
-- go 

-- create index ix_appyear on business_payment (appyear)
-- go 
-- create index ix_refdate on business_payment (refdate)
-- go 
-- create index ix_refno on business_payment (refno)
-- go 
-- drop index ix_applicationid on business_payment
-- go 
-- alter table business_payment 
--   alter column applicationid varchar(50) not null
-- go 
-- create index ix_applicationid on business_payment (applicationid) 
-- go 

-- drop index businessid on business_payment
-- go 
-- alter table business_payment 
--   alter column businessid varchar(50) not null
-- go 
-- create index ix_businessid on business_payment (businessid) 
-- go 


-- select p.objid 
-- into ztmp_duplicate_business_payment
-- from business_payment p 
-- 	left join business_application a on a.objid = p.applicationid 
-- where a.objid is null 
-- go
-- delete from business_payment_item where parentid in ( 
-- 	select objid from ztmp_duplicate_business_payment
-- )
-- go
-- delete from business_payment where objid in ( 
-- 	select objid from ztmp_duplicate_business_payment
-- )
-- go
-- if object_id('dbo.ztmp_duplicate_business_payment', 'U') IS NOT NULL 
--   drop table dbo.ztmp_duplicate_business_payment; 
-- go 


-- alter table business_payment add CONSTRAINT fk_business_payment_application 
--   FOREIGN KEY (applicationid) REFERENCES business_application (objid) 
-- go
-- alter table business_payment add CONSTRAINT fk_business_payment_business 
--   FOREIGN KEY (businessid) REFERENCES business (objid) 
-- go


-- create index ix_account_objid on business_payment_item (account_objid)
-- go 
-- create index ix_lob_objid on business_payment_item (lob_objid)
-- go 

-- select b.objid 
-- into ztmp_invalid_business_payment_item
-- from business_payment_item b 
--   left join business_payment p on p.objid = b.parentid 
-- where p.objid is null 
-- go 
-- delete from business_payment_item where objid in ( 
--   select objid from ztmp_invalid_business_payment_item 
-- )
-- go
-- if object_id('dbo.ztmp_invalid_business_payment_item', 'U') IS NOT NULL 
--   drop table dbo.ztmp_invalid_business_payment_item; 
-- go 

-- alter table business_payment_item add CONSTRAINT fk_business_payment_item_parent 
--   FOREIGN KEY (parentid) REFERENCES business_payment (objid)
-- go

-- EXEC sp_rename N'[dbo].[business_payment_item].[PARTIAL]', N'partial', 'COLUMN'
-- go 


-- drop index uix_applicationid on business_permit 
-- go 
-- create index ix_activeyear on business_permit (activeyear)
-- go 
-- create index ix_applicationid on business_permit (applicationid)
-- go 
-- create index ix_businessid on business_permit (businessid)
-- go 
-- create index ix_dtissued on business_permit (dtissued)
-- go 
-- create index ix_expirydate on business_permit (expirydate)
-- go 
-- create index ix_issuedby_objid on business_permit (issuedby_objid)
-- go 
-- create index ix_plateno on business_permit (plateno)
-- go 

-- select p.* 
-- into ztmp_invalid_business_permit 
-- from business_permit p 
--   left join business_application a on a.objid = p.applicationid 
-- where a.objid is null 
-- go 
-- select pp.* 
-- from ztmp_invalid_business_permit z 
--   inner join business_permit_lob pp on pp.parentid = z.objid 
-- go 
-- delete from business_permit where objid in (
--   select objid from ztmp_invalid_business_permit 
-- )
-- go 

-- alter table business_permit add CONSTRAINT fk_business_permit_applicationid  
--   FOREIGN KEY (applicationid) REFERENCES business_application (objid) 
-- go
-- alter table business_permit add CONSTRAINT fk_business_permit_business 
--   FOREIGN KEY (businessid) REFERENCES business (objid) 
-- go


-- -- create index ix_account_objid on business_receivable (account_objid)
-- -- go 
-- alter table business_receivable drop constraint FK__business___appli__6F556E19
-- go 
-- drop index FK_business_receivable_business_application on business_receivable 
-- go 
-- alter table business_receivable alter column applicationid varchar(50) not null 
-- go
-- create index ix_applicationid on business_receivable (applicationid) 
-- go 
-- alter table business_receivable add constraint fk_business_receivable_applicatonid 
--   foreign key (applicationid) references business_application (objid)
-- go 

-- drop index FK_business_receivable_business on business_receivable 
-- go 
-- alter table business_receivable alter column businessid varchar(50) not null 
-- go
-- create index ix_businessid on business_receivable (businessid) 
-- go 

-- update aa set 
--   aa.businessid = bb.business_objid 
-- from business_receivable aa, ( 
--     select br.objid, ba.business_objid 
--     from business_receivable br 
--       inner join business_application ba on ba.objid = br.applicationid 
--       left join business b on b.objid = br.businessid 
--     where b.objid is null 
--   )bb 
-- where aa.objid = bb.objid 
-- go 
-- alter table business_receivable with nocheck 
--   add constraint fk_business_receivable_businessid 
--   foreign key (businessid) references business (objid)
-- go 


-- select r.objid 
-- into ztmp_invalid_business_receivable 
-- from business_receivable r 
--   left join business_application a on a.objid = r.applicationid 
-- where a.objid is null 
-- go 
-- delete from business_receivable where objid in ( 
--   select objid from ztmp_invalid_business_receivable
-- )
-- go
-- if object_id('dbo.ztmp_invalid_business_receivable', 'U') IS NOT NULL 
--   drop table dbo.ztmp_invalid_business_receivable; 
-- go 


-- -- create index ix_account_objid on business_recurringfee (account_objid)
-- -- go 

-- drop index ix_businessid on business_redflag
-- go 
-- alter table business_redflag alter column businessid varchar(50) not null
-- go
-- create index ix_businessid on business_redflag (businessid) 
-- go 

-- select r.* 
-- into ztmp_invalid_business_redflag 
-- from business_redflag r 
--   left join business b on b.objid = r.businessid 
-- where b.objid is null 
-- go 
-- delete from business_redflag where objid in (
--   select objid from ztmp_invalid_business_redflag 
-- )
-- go 
-- drop table ztmp_invalid_business_redflag
-- go 
-- alter table business_redflag add CONSTRAINT fk_business_redflag_business 
--   FOREIGN KEY (businessid) REFERENCES business (objid)
-- go 


-- -- create index ix_completedby_objid on business_requirement (completedby_objid)
-- -- go 
-- -- create index ix_dtcompleted on business_requirement (dtcompleted)
-- -- go 
-- create index ix_dtissued on business_requirement (dtissued)
-- go 
-- -- create index ix_refid on business_requirement (refid)
-- -- go 
-- -- create index ix_refno on business_requirement (refno)
-- -- go 


-- select r.objid 
-- into ztmp_invalid_business_requirement 
-- from business_requirement r 
--   left join business_application a on a.objid = r.applicationid 
-- where a.objid is null 
-- go 
-- delete from business_requirement where objid in ( 
--   select objid from ztmp_invalid_business_requirement
-- )
-- go
-- drop table ztmp_invalid_business_requirement
-- go 

-- alter table business_requirement add CONSTRAINT fk_business_requirement_applicationid 
--   FOREIGN KEY (applicationid) REFERENCES business_application (objid)
-- go 

-- alter table business_requirement with nocheck 
--   add CONSTRAINT fk_business_requirement_businessid  
--   FOREIGN KEY (businessid) REFERENCES business (objid)
-- go 


-- create UNIQUE index uix_code on businessrequirementtype (code) 
-- go 
-- create UNIQUE index uix_title on businessrequirementtype (title) 
-- go 


-- create UNIQUE index uix_name on businessvariable (name)
-- go 


-- alter table cashreceipt add ukey varchar(50) not null default ''
-- go 
-- create index ix_ukey on cashreceipt (ukey)
-- go 
-- update cashreceipt set ukey = objid 
-- go
-- create UNIQUE index uix_receiptno on cashreceipt (receiptno,ukey)
-- go 


-- create index ix_formno on cashreceipt (formno)
-- go 
-- create index ix_org_objid on cashreceipt (org_objid)
-- go 
-- create index ix_payer_objid on cashreceipt (payer_objid)
-- go 
-- create index ix_receiptdate on cashreceipt (receiptdate)
-- go 
-- create index ix_user_objid on cashreceipt (user_objid)
-- go 

-- alter table cashreceipt add CONSTRAINT fk_cashreceipt_collector_objid 
--   FOREIGN KEY (collector_objid) REFERENCES sys_user (objid)
-- go

alter table cashreceipt drop constraint UQ_cashreceipt_receiptno 
go 
drop index ix_controlid on cashreceipt 
go 
alter table cashreceipt alter column controlid varchar(50) not null 
go
create index ix_controlid on cashreceipt (controlid) 
go 
create unique index uix_controlid_receiptno on cashreceipt (controlid, receiptno) 
go 
alter table cashreceipt with nocheck 
  add CONSTRAINT fk_cashreceipt_controlid 
  FOREIGN KEY (controlid) REFERENCES af_control (objid)
go


-- create index ix_controlid on cashreceipt_cancelseries (controlid)
-- go 
-- create index ix_postedby_objid on cashreceipt_cancelseries (postedby_objid)
-- go 
-- create index ix_txndate on cashreceipt_cancelseries (txndate)
-- go 


-- alter table cashreceipt_rpt drop constraint cashreceipt_rpt_ibfk_1
-- go


create index ix_acctid on cashreceipt_slaughter (acctid)
go 
create index ix_acctno on cashreceipt_slaughter (acctno)
go 


-- create index ix_postedby_objid on cashreceipt_void (postedby_objid)
-- go 
-- create index ix_txndate on cashreceipt_void (txndate)
-- go 


-- create index ix_account_fund_objid on cashreceiptpayment_noncash (account_fund_objid)
-- go 
-- create index ix_account_objid on cashreceiptpayment_noncash (account_objid)
-- go 
-- create index ix_refdate on cashreceiptpayment_noncash (refdate)
-- go 
-- create index ix_refno on cashreceiptpayment_noncash (refno)
-- go 


-- create index ix_formno on collectiontype (formno)
-- go 
create index ix_handler on collectiontype (handler)
go 


alter table creditmemo add 
  payer_name varchar(255) NULL,
  payer_address_objid varchar(50) NULL,
  payer_address_text varchar(50) NULL
go 
-- create index ix_bankaccount_objid on creditmemo (bankaccount_objid)
-- go 
-- create index ix_controlno on creditmemo (controlno)
-- go 
-- create index ix_dtissued on creditmemo (dtissued)
-- go 
-- create index ix_issuedby_objid on creditmemo (issuedby_objid)
-- go 
-- create index ix_payer_objid on creditmemo (payer_objid)
-- go 
-- create index ix_receiptid on creditmemo (receiptid)
-- go 
-- create index ix_receiptno on creditmemo (receiptno)
-- go 
-- create index ix_refdate on creditmemo (refdate)
-- go 
-- create index ix_refno on creditmemo (refno)
-- go 
-- create index ix_type_objid on creditmemo (type_objid)
-- go 
create index ix_state on creditmemo (state)
go 


alter table creditmemoitem add constraint fk_creditmemoitem_parentid 
  FOREIGN KEY (parentid) REFERENCES creditmemo (objid)
go
alter table creditmemoitem add constraint fk_creditmemoitem_item_objid 
  FOREIGN KEY (item_objid) REFERENCES itemaccount (objid)
go


-- create index ix_account_objid on creditmemotype_account (account_objid)
-- go 


-- alter table entity_address drop foreign key entity_address_ibfk_1
-- go 
-- create index ix_barangay_objid on entity_address (barangay_objid)
-- go


-- create index ix_entityid on entityid (entityid)
-- go 
-- create index ix_idno on entityid (idno)
-- go 


-- alter table entityindividual alter column lastname varchar(50) not null
-- go
-- alter table entityindividual alter column firstname varchar(50) not null
-- go
-- alter table entityindividual alter column middlename varchar(50) null
-- go
alter table entityindividual alter column birthdate date null
go
-- create index ix_lastname on entityindividual (lastname)
-- go 


-- alter table entityjuridical drop constraint entityjuridical_ibfk_1
-- go 


create index ix_member_name on entitymember (member_name)
go


create index ix_code on fund (code)
go 
create index ix_title on fund (title)
go 
create index ix_parentid on fund (parentid)
go 

drop index ix_depositoryfundid on fund
go 
alter table fund alter column depositoryfundid nvarchar(50) null 
go 
create index ix_depositoryfundid on fund (depositoryfundid) 
go 
alter table fund add constraint fk_fund_depositoryfundid 
  foreign key (depositoryfundid) references fund (objid) 
go


create index ix_code on itemaccount (code)
go 
create index ix_title on itemaccount (title)
go 
-- create index ix_parentid on itemaccount (parentid)
-- go 
-- alter table itemaccount drop constraint itemaccount_ibfk_1
-- go 


-- alter table lob add ukey varchar(50) not null default ''
-- go
-- create index ix_ukey on lob (ukey)
-- go 
-- update lob set ukey = objid 
-- go 
-- create UNIQUE index uix_name on lob (name, ukey)
-- go 
-- create index ix_name on lob (name)
-- go 
-- create index ix_psic on lob (psic)
-- go 


-- create unique index uix_name on lobclassification (name)
-- go 

-- create unique index uix_name on lobattribute (name)
-- go


if object_id('dbo.paymentorder', 'U') IS NOT NULL 
  drop table dbo.paymentorder; 
go 
CREATE TABLE paymentorder (
  txnid varchar(50) NOT NULL,
  txndate datetime NULL,
  payer_objid varchar(50) NULL,
  payer_name varchar(800) NULL,
  paidby varchar(800) NULL,
  paidbyaddress varchar(255) NULL,
  particulars varchar(255) NULL,
  amount decimal(16,2) NULL,
  txntypeid varchar(50) NULL,
  expirydate date NULL,
  refid varchar(50) NULL,
  refno varchar(50) NULL,
  info varchar(MAX) NULL,
  constraint pk_paymentorder PRIMARY KEY (txnid)
) 
go 
create index ix_txndate on paymentorder (txndate) 
go 
create index ix_payer_objid on paymentorder (payer_objid) 
go 
create index ix_payer_name on paymentorder (payer_name) 
go 
create index ix_paidby on paymentorder (paidby) 
go 
create index ix_txntypeid on paymentorder (txntypeid) 
go 
create index ix_expirydate on paymentorder (expirydate) 
go 
create index ix_refid on paymentorder (refid) 
go 
create index ix_refno on paymentorder (refno) 
go 


drop index ix_controldate on remittance 
go 
alter table remittance alter column controldate date not null 
go 
create index ix_controldate on remittance (controldate) 
go 


-- create index ix_dtposted on remittance (dtposted)
-- go 


-- alter table report_bpdelinquency alter column totalcount int null
-- go
-- alter table report_bpdelinquency alter column processedcount int null
-- go


if object_id('dbo.sms_inbox_pending', 'U') IS NOT NULL 
  drop table dbo.sms_inbox_pending; 
go 
if object_id('dbo.sms_inbox', 'U') IS NOT NULL 
  drop table dbo.sms_inbox; 
go 
if object_id('dbo.sms_outbox_pending', 'U') IS NOT NULL 
  drop table dbo.sms_outbox_pending; 
go 
if object_id('dbo.sms_outbox', 'U') IS NOT NULL 
  drop table dbo.sms_outbox; 
go 


create index ix_txnno on subcollector_remittance (txnno)
go 
create index ix_state on subcollector_remittance (state)
go 
create index ix_dtposted on subcollector_remittance (dtposted)
go 
create index ix_collector_objid on subcollector_remittance (collector_objid)
go 
create index ix_subcollector_objid on subcollector_remittance (subcollector_objid)
go 


if object_id('dbo.sys_notification_user', 'U') IS NOT NULL 
  drop table dbo.sys_notification_user; 
go 
if object_id('dbo.sys_notification_group', 'U') IS NOT NULL 
  drop table dbo.sys_notification_group; 
go 
if object_id('dbo.sys_notification', 'U') IS NOT NULL 
  drop table dbo.sys_notification; 
go 


-- alter table sys_report drop constraint sys_report_ibfk_1
-- go 


alter table sys_rule add _ukey varchar(50) not null default ''
go 
update sys_rule set _ukey = objid 
go 
create UNIQUE index uix_ruleset_name on sys_rule (ruleset,name,_ukey)
go 

create index ix_actiondef_objid on sys_rule_action (actiondef_objid)
go 


update remittance_fund set cashbreakdown='[]' where cashbreakdown is null
go


update aa set 
  aa.controlno = bb.controlno  
from remittance_fund aa, ( 
    select rf.objid, (r.controlno +'-'+ fund.code) as controlno 
    from remittance_fund rf, remittance r, fund 
    where rf.remittanceid = r.objid 
      and rf.fund_objid = fund.objid 
  )bb 
where aa.objid = bb.objid
go 
