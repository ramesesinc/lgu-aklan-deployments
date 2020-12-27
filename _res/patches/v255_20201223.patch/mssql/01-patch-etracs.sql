alter table business_recurringfee add txntype_objid varchar(50) null 
go 

create index ix_txntype_objid on business_recurringfee  (txntype_objid)
go 

alter table business_recurringfee add constraint fk_business_recurringfee_txntype_objid 
  foreign key (txntype_objid) references business_billitem_txntype (objid)
go 
