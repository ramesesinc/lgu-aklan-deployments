

insert into eor_paymentorder_cancelled (
	objid, txndate, txntype, txntypename, payer_objid, payer_name, paidby, paidbyaddress, particulars, 
	amount, expirydate, refid, refno, info, origin, controlno, locationid, items, state, email, mobileno
)
select 
	objid, txndate, txntype, txntypename, payer_objid, payer_name, paidby, paidbyaddress, particulars, 
	amount, expirydate, refid, refno, info, origin, controlno, locationid, items, state, email, mobileno
from eor_paymentorder
where txndate < '2020-12-01' 
order by txndate 
;

delete from eor_paymentorder where objid in (
	select objid from eor_paymentorder_cancelled 
	where objid = eor_paymentorder.objid 
)
;