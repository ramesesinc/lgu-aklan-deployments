use etracs255_aklan
go 

alter table account_incometarget drop constraint fk_account_incometarget_itemid
go 
alter table account_incometarget add constraint fk_account_incometarget_itemid
	foreign key (itemid) references account (objid) 
go 

insert into account_incometarget (
	objid, itemid, year, target 
)
select t1.* 
from (  
	select 
		(''+ convert(varchar, a.year) +'|'+ a.objid) as objid, 
		a.objid as itemid, a.year, a.target 
	from sreaccount_incometarget a
	where a.target is not null 
)t1 
	inner join account a on a.objid = t1.itemid 
	left join account_incometarget ai on (ai.itemid = t1.itemid and ai.year = t1.year)
where ai.objid is null 
order by t1.year, t1.objid 
;


if object_id('dbo.vw_account_incometarget', 'V') IS NOT NULL 
  drop view dbo.vw_account_incometarget; 
go 
create view vw_account_incometarget as 
select t.*, a.maingroupid, 
	a.objid as item_objid, a.code as item_code, a.title as item_title, 
	a.[level] as item_level, a.leftindex as item_leftindex, 
	g.objid as group_objid, g.code as group_code, g.title as group_title, 
	g.[level] as group_level, g.leftindex as group_leftindex 
from account_incometarget t 
	inner join account a on a.objid = t.itemid 
	inner join account g on g.objid = a.groupid 
go 
