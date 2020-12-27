create table ztmp_fix_business_billitem_txntype 
select 'BPLS' as domain, 'OBO' as role, t1.*, 
	(select title from itemaccount where objid = t1.acctid) as title, 
	(
		select r.taxfeetype 
		from business_receivable r, business_application a 
		where r.account_objid = t1.acctid 
			and a.objid = r.applicationid 
		order by a.txndate desc limit 1 
	) as feetype 
from ( select distinct account_objid as acctid from business_recurringfee )t1 
where t1.acctid not in ( 
	select acctid from business_billitem_txntype where acctid = t1.acctid 
) 
;

insert into business_billitem_txntype (
	objid, title, acctid, feetype, domain, role
) 
select 
	acctid, title, acctid, feetype, domain, role
from ztmp_fix_business_billitem_txntype
;

update business_recurringfee aa set 
	aa.txntype_objid = (
		select objid from business_billitem_txntype 
		where acctid = aa.account_objid 
		limit 1
	) 
where aa.txntype_objid is null 
; 

drop table if exists ztmp_fix_business_billitem_txntype
;



alter table online_business_application add partnername varchar(50) not null 
;
