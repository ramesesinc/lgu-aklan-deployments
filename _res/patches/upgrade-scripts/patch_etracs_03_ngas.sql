use etracs255_aklan
go 

-- 
-- Insert data into account_maingroup 
-- 
insert into account_maingroup (
	objid, title, version, reporttype, role, domain, system 
)
select * 
from ( 
	select  
		'NGAS-V254' as objid, 'NGAS-V254' as title, 0 as version, 
		'NGAS' as reporttype, NULL as role, NULL as domain, 0 as system 
)t1
where t1.objid not in (select objid from account_maingroup where objid = t1.objid)
;


alter table account drop constraint pk_account_groupid
go 

-- 
-- Insert data into account 
-- 
insert into account ( 
	objid, maingroupid, code, title, groupid, 
	type, leftindex, rightindex, [level] 
) 
select * 
from ( 
	select 
		objid, 'NGAS-V254' as maingroupid, code, title, parentid as groupid, 
		'root' as type, null as leftindex, null as rightindex, null as [level] 
	from ngasaccount where parentid is null
	union all 
	select 
		a.objid, 'NGAS-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
		'group' as type, null as leftindex, null as rightindex, null as [level] 
	from ngasaccount a, ngasaccount p  
	where a.parentid is not null 
		and a.parentid = p.objid 
		and a.type = 'group' 
	union all 
	select 
		a.objid, 'NGAS-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
		'item' as type, null as leftindex, null as rightindex, null as [level] 
	from ngasaccount a, ngasaccount p  
	where a.parentid is not null 
		and a.parentid = p.objid 
		and a.type = 'detail' 
	union all 
	select 
		a.objid, 'NGAS-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
		'detail' as type, null as leftindex, null as rightindex, null as [level] 
	from ngasaccount a, ngasaccount p  
	where a.parentid is not null 
		and a.parentid = p.objid 
		and a.type = 'subaccount'  
)t1 
where t1.objid not in (select objid from account where objid = t1.objid) 
;

if object_id('dbo.z201910_invalid_account', 'U') IS NOT NULL 
  drop table dbo.z201910_invalid_account; 
go 
select a.* 
into z201910_invalid_account 
from account a 
	left join account p on p.objid = a.groupid 
where a.groupid is not null 
	and p.objid is null 
go 

delete from account where objid in (
	select objid from z201910_invalid_account 
	where objid = z201910_invalid_account.objid 
)
go 
drop table z201910_invalid_account
go 

alter table account add constraint fk_account_groupid 
	foreign key (groupid) references account (objid)
go 

-- 
-- Insert data into account_item_mapping 
-- 
insert into account_item_mapping ( 
	objid, maingroupid, acctid, itemid 
) 
select 
	rm.objid, a.maingroupid, 
	rm.acctid, rm.revenueitemid as itemid 
from ngas_revenue_mapping rm 
	inner join account a on a.objid = rm.acctid 
	inner join itemaccount ia on ia.objid = rm.revenueitemid 
where rm.objid not in (select objid from account_item_mapping where objid = rm.objid)
;

