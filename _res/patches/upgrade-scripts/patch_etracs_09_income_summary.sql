use etracs255_aklan
go 

-- 
-- Rebuild Income Summary By Month 
-- Revision: v04
-- 
delete from income_summary;

-- insert records for the specified date 
insert into income_summary ( 
	amount, fundid, acctid, orgid, collectorid, 
	refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, 
	liquidationid, liquidationdate, liquidationyear, liquidationmonth, liquidationqtr 
)
select 
	sum(amount) as amount, fundid, acctid, orgid, collectorid, 
	refid, refdate, refno, reftype, year(refdate) as refyear, month(refdate) as refmonth, 
	case 
		when month(refdate) between 1 and 3 then 1 
		when month(refdate) between 4 and 6 then 2 
		when month(refdate) between 7 and 9 then 3  
		when month(refdate) between 10 and 12 then 4 
	end as refqtr,  
	remittanceid, remittancedate, 
	year(remittancedate) as remittanceyear, month(remittancedate) as remittancemonth, 
	case 
		when month(remittancedate) between 1 and 3 then 1 
		when month(remittancedate) between 4 and 6 then 2 
		when month(remittancedate) between 7 and 9 then 3  
		when month(remittancedate) between 10 and 12 then 4 
	end as remittanceqtr, 
	refid as liquidationid, refdate as liquidationdate, 
	year(refdate) as liquidationyear, month(refdate) as liquidationmonth, 
	case 
		when month(refdate) between 1 and 3 then 1 
		when month(refdate) between 4 and 6 then 2 
		when month(refdate) between 7 and 9 then 3  
		when month(refdate) between 10 and 12 then 4 
	end as liquidationqtr 
from ( 
	select 
		sum(ci.amount) as amount, ci.item_fund_objid as fundid, ci.item_objid as acctid, 
		c.org_objid as orgid, c.collector_objid as collectorid, cv.objid as refid, 
		cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptitem ci on ci.receiptid = c.objid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and cv.controldate >= '2020-01-01' 
		and v.objid is null 
	group by 
		ci.item_fund_objid, ci.item_objid, c.org_objid, c.collector_objid, 
		cv.objid, cv.controldate, cv.controlno, c.remittanceid, r.controldate  

	union all 

	select 
		-sum(amount) as amount, fundid, acctid, orgid, collectorid, 
		refid, refdate, refno, reftype, remittanceid, remittancedate 
	from ( 
		select 
			cv.objid as refid, cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
			(select top 1 item_fund_objid from cashreceiptitem where receiptid = c.objid and item_objid = cs.refitem_objid) as fundid,  
			cs.refitem_objid as acctid, cs.amount, c.org_objid as orgid, c.collector_objid as collectorid, 
			c.remittanceid, r.controldate as remittancedate 
		from collectionvoucher cv 
			inner join remittance r on r.collectionvoucherid = cv.objid 
			inner join cashreceipt c on c.remittanceid = r.objid 
			inner join cashreceipt_share cs on cs.receiptid = c.objid 
			left join cashreceipt_void v on v.receiptid = c.objid 
		where cv.state = 'POSTED' 
			and cv.controldate >= '2020-01-01' 
			and v.objid is null 
	)t1  
	group by 
		fundid, acctid, orgid, collectorid, 
		refid, refdate, refno, reftype, remittanceid, remittancedate 

	union all 

	select 
		sum(cs.amount) as amount, ia.fund_objid as fundid, cs.payableitem_objid as acctid, 
		c.org_objid as orgid, c.collector_objid as collectorid, cv.objid as refid, 
		cv.controldate as refdate, cv.controlno as refno, 'liquidation' as reftype, 
		c.remittanceid, r.controldate as remittancedate 
	from collectionvoucher cv 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceipt_share cs on cs.receiptid = c.objid 
		inner join itemaccount ia on ia.objid = cs.payableitem_objid 
		left join cashreceipt_void v on v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and v.objid is null 
		and cv.controldate >= '2020-01-01' 
	group by 
		ia.fund_objid, cs.payableitem_objid, c.org_objid, c.collector_objid, 
		cv.objid, cv.controldate, cv.controlno, c.remittanceid, r.controldate 
)aa 
group by 
	fundid, acctid, orgid, collectorid, 
	refid, refdate, refno, reftype, remittanceid, remittancedate 
;


-- insert credit memo records 
insert into income_summary ( 
	amount, fundid, acctid, orgid, refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
	remittanceid, remittancedate, remittanceyear, remittancemonth, remittanceqtr, liquidationid 
)
select * 
from ( 
	select 
		amount, fundid, acctid, orgid, refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
		refid as remittanceid, refdate as remittancedate, refyear as remittanceyear, 
		refmonth as remittancemonth, refqtr as remittanceqtr, refid as liquidationid 
	from ( 
		select 
			sum(cmi.amount) as amount, ia.fund_objid as fundid, 
			ia.objid as acctid, o.objid as orgid, cm.objid as refid, 
			cm.refdate, cm.refno, cm.type_objid as reftype, 
			year(cm.refdate) as refyear, month(cm.refdate) as refmonth, 
			case 
				when month(cm.refdate) between 1 and 3 then 1 
				when month(cm.refdate) between 4 and 6 then 2 
				when month(cm.refdate) between 7 and 9 then 3 
				when month(cm.refdate) between 10 and 12 then 4 
			end as refqtr 
		from creditmemo cm 
			inner join creditmemotype cmt on cmt.objid = cm.type_objid 
			inner join creditmemoitem cmi on cmi.parentid = cm.objid 
			inner join itemaccount ia on ia.objid = cmi.item_objid 
			inner join sys_org o on (o.root = 1)
		where isnull(cmt.issuereceipt,0) = 0 
			and cm.state = 'POSTED' 
			and cm.refdate >= '2020-01-01' 
		group by 
			ia.fund_objid, ia.objid, o.objid, cm.objid, cm.refdate, cm.refno, cm.type_objid 
	)t1  

	union all 

	select 
		amount, fundid, acctid, orgid, refid, refdate, refno, reftype, refyear, refmonth, refqtr, 
		refid as remittanceid, refdate as remittancedate, refyear as remittanceyear, 
		refmonth as remittancemonth, refqtr as remittanceqtr, refid as liquidationid 
	from ( 
		select 
			sum(cmi.amount) as amount, ia.fund_objid as fundid, 
			ia.objid as acctid, o.objid as orgid, cm.objid as refid, 
			cm.refdate, cm.refno, cmt.name as reftype, 
			year(cm.refdate) as refyear, month(cm.refdate) as refmonth, 
			case 
				when month(cm.refdate) between 1 and 3 then 1 
				when month(cm.refdate) between 4 and 6 then 2 
				when month(cm.refdate) between 7 and 9 then 3 
				when month(cm.refdate) between 10 and 12 then 4 
			end as refqtr 
		from creditmemo cm 
			inner join collectiontype cmt on cmt.objid = cm.type_objid 
			inner join creditmemoitem cmi on cmi.parentid = cm.objid 
			inner join itemaccount ia on ia.objid = cmi.item_objid 
			inner join sys_org o on (o.root = 1)
		where cm.state = 'POSTED' 
			and cm.refdate >= '2020-01-01' 
			and cm.receiptid is null 
		group by 
			ia.fund_objid, ia.objid, o.objid, cm.objid, cm.refdate, cm.refno, cmt.name 
	)t1  
)aa 
;
