use etracs255_aklan
go 

insert into itemaccount ( 
	objid, state, code, title, type, fund_objid, fund_code, fund_title, 
	defaultvalue, valuetype, generic, sortorder, hidefromlookup 
) 
select 
	t2.acctid as objid, 'ACTIVE' as state, '-' as code, 
	('CASH IN BANK ('+ t2.fund_title +')') as title, t2.accttype as type, 
	t2.fund_objid, t2.fund_code, t2.fund_title, 0.0 as defaultvalue, 'ANY' as valuetype, 
	0 as generic, 0 as sortorder, 0 as hidefromlookup 
from ( 
	select 
		fund.objid as fund_objid, fund.code as fund_code, fund.title as fund_title, 
		('CIB'+ fund.objid) as acctid, 'CASH_IN_BANK' as accttype 
	from ( 
		select distinct depositoryfundid 
		from fund 
		where state = 'ACTIVE' 
	)t1, fund 
	where fund.objid = t1.depositoryfundid 
)t2 
	left join itemaccount ia on ia.objid = t2.acctid 
where ia.objid is null 
;

update aa set 
	aa.acctid = bb.acctid 
from bankaccount aa, ( 
	select 
		ba.objid, ba.fund_objid, 
		('CIB'+ ba.fund_objid) as acctid 
	from bankaccount ba 
		left join itemaccount ia on ia.objid = ba.acctid 
	where ia.objid is null 
)bb 
where aa.objid = bb.objid 
; 


-- 
-- build jev records
-- 
delete from cash_treasury_ledger;
delete from bankaccount_ledger;
delete from income_ledger;
delete from payable_ledger;
delete from jevitem;
delete from jev; 


insert into jev (
	objid, jevdate, refid, refno, refdate, reftype, txntype, 
	dtposted, postedby_objid, postedby_name, fundid, amount, state 
) 
select 
	objid, refdate as jevdate, refid, refno, refdate, reftype, txntype, 
	dtposted, postedby_objid, postedby_name, fundid, 
	sum(amount) as amount, 'OPEN' as state 
from ( 
	select 
		('JEV-'+ convert(varchar(50), HashBytes('MD5', (cv.objid +'|'+ cvf.fund_objid)), 2)) as objid, 
		cv.objid as refid, cv.controlno as refno, cv.controldate as refdate, 
		'collectionvoucher' as reftype, 'COLLECTION' as txntype, cv.dtposted, 
		cv.liquidatingofficer_objid as postedby_objid, 
		cv.liquidatingofficer_name as postedby_name, 
		cv.liquidatingofficer_title as postedby_title, 
		cvf.fund_objid as fundid, cvf.amount  
	from collectionvoucher cv 
		inner join collectionvoucher_fund cvf on cvf.parentid = cv.objid 
	where cv.state = 'POSTED' 
		and cv.controldate >= '2018-01-01' 
)t1 
group by 
	objid, refid, refno, refdate, reftype, txntype, dtposted, 
	postedby_objid, postedby_name, postedby_title, fundid 
;


insert into cash_treasury_ledger ( 
	objid, jevid, itemacctid, dr, cr 
) 
select 
	jevid as objid, jevid, 'CASH_IN_TREASURY' as itemacctid, dr, cr 
from ( 
	select jev.objid as jevid, sum(cvf.totalcash + cvf.totalcheck) as dr, 0.0 as cr 
	from jev 
		inner join collectionvoucher_fund cvf on (cvf.parentid = jev.refid and cvf.fund_objid = jev.fundid) 
		inner join collectionvoucher cv on cv.objid = cvf.parentid 
	group by jev.objid 
)t1 
;


insert into bankaccount_ledger ( 
	objid, jevid, bankacctid, itemacctid, dr, cr 
) 
select NEWID() as objid, jevid, bankacctid, itemacctid, dr, cr 
from ( 
	select 
		jev.objid as jevid, ba.objid AS bankacctid, ba.acctid AS itemacctid, sum(nc.amount) as dr, 0.0 AS cr   
	from jev 
		inner join collectionvoucher_fund cvf on (cvf.parentid = jev.refid and cvf.fund_objid = jev.fundid) 
		inner join collectionvoucher cv on cv.objid = cvf.parentid 
		inner join remittance r on r.collectionvoucherid = cv.objid 
		inner join cashreceipt c on c.remittanceid = r.objid 
		inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
		inner join eftpayment eft ON eft.objid = nc.refid
		inner join bankaccount ba ON (ba.objid = eft.bankacctid and ba.fund_objid = cvf.fund_objid) 
		inner join itemaccount ia on ia.objid = ba.acctid 
		left join cashreceipt_void v ON v.receiptid = c.objid 
	where cv.state = 'POSTED' 
		and v.objid is null 
	group by jev.objid, ba.objid, ba.acctid
)t2 
;


insert into income_ledger (
	objid, jevid, itemacctid, dr, cr 
) 
select NEWID() as objid, jevid, itemacctid, dr, cr 
from (
	select jevid, itemacctid, sum(dr) as dr, sum(cr) as cr  
	from ( 
		select 
			jev.objid as jevid, v.acctid as itemacctid, 0.0 as dr, sum(v.amount) as cr 
		from jev 
			inner join collectionvoucher_fund cvf on (cvf.parentid = jev.refid and cvf.fund_objid = jev.fundid) 
			inner join collectionvoucher cv on cv.objid = cvf.parentid 
			inner join vw_remittance_cashreceiptitem v on (v.collectionvoucherid = cv.objid and v.fundid = cvf.fund_objid) 
		where cv.state = 'POSTED' 
			and v.voided = 0 
		group by jev.objid, v.acctid

		union all 

		select 
			jev.objid as jevid, v.refacctid as itemacctid, sum(v.amount) as dr, 0.0 as cr  
		from jev 
			inner join collectionvoucher_fund cvf on (cvf.parentid = jev.refid and cvf.fund_objid = jev.fundid) 
			inner join collectionvoucher cv on cv.objid = cvf.parentid 
			inner join vw_remittance_cashreceiptshare v on (v.collectionvoucherid = cv.objid and v.fundid = cvf.fund_objid)
		where cv.state = 'POSTED' 
			and v.voided = 0 
		group by jev.objid, v.refacctid 
	)t1 
	group by jevid, itemacctid 
)t2 
;


insert into payable_ledger (
	objid, jevid, refitemacctid, itemacctid, dr, cr 
) 
select 
	NEWID() as objid, jevid, refitemacctid, itemacctid, dr, cr 
from ( 
	select 
		jev.objid as jevid, v.refacctid as refitemacctid, v.acctid as itemacctid, 
		0.0 as dr, sum(v.amount) as cr 
	from jev 
		inner join collectionvoucher_fund cvf on (cvf.parentid = jev.refid and cvf.fund_objid = jev.fundid) 
		inner join collectionvoucher cv on cv.objid = cvf.parentid 
		inner join vw_remittance_cashreceiptshare v on (v.collectionvoucherid = cv.objid and v.fundid = cvf.fund_objid)
	where cv.state = 'POSTED' 
		and v.voided = 0 
	group by 
		jev.objid, v.refacctid, v.acctid 
)t1 
;



insert into jevitem ( 
	objid, jevid, acctid, dr, cr, acctcode, acctname  
) 
select 
	NEWID() as objid, jevid, acctid, dr, cr, acctcode, acctname 
from ( 
	select 
		jevid, acctid, acctcode, acctname, 
		sum(dr) as dr, sum(cr) as cr 	
	from ( 
		select 
			l.jevid, l.itemacctid as acctid, l.dr, l.cr,
			ia.code as acctcode, ia.title as acctname 
		from jev, cash_treasury_ledger l, itemaccount ia  
		where l.jevid = jev.objid 
			and ia.objid = l.itemacctid 

		union all 

		select 
			l.jevid, l.itemacctid as acctid, l.dr, l.cr,
			ia.code as acctcode, ia.title as acctname 
		from jev, bankaccount_ledger l, itemaccount ia  
		where l.jevid = jev.objid 
			and ia.objid = l.itemacctid 

		union all 

		select 
			l.jevid, l.itemacctid as acctid, l.dr, l.cr,
			ia.code as acctcode, ia.title as acctname 
		from jev, income_ledger l, itemaccount ia  
		where l.jevid = jev.objid 
			and ia.objid = l.itemacctid 

		union all 

		select 
			l.jevid, l.itemacctid as acctid, l.dr, l.cr,
			ia.code as acctcode, ia.title as acctname 
		from jev, payable_ledger l, itemaccount ia  
		where l.jevid = jev.objid 
			and ia.objid = l.itemacctid 
	)t1 
	group by 
		jevid, acctid, acctcode, acctname 
)t2 
;

