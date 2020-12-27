

alter table checkpayment add constraint fk_checkpayment_bankid 
  foreign key (bankid) references bank (objid) 
; 

