
drop index ix_bankid on checkpayment
go 
alter table checkpayment alter column bankid nvarchar(50) not null 
go 
create index ix_bankid on checkpayment (bankid) 
go 
alter table checkpayment add constraint fk_checkpayment_bankid 
  foreign key (bankid) references bank (objid) 
go 
