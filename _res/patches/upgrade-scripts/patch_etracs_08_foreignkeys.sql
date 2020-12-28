use etracs255_aklan
go 

alter table af_control add constraint fk_af_control_afid 
  foreign key (afid) references af (objid) 
go

alter table collectiontype add constraint fk_collectiontype_fund_objid 
  foreign key (fund_objid) references fund (objid)
go 

alter table collectiontype_account 
  alter column collectiontypeid nvarchar(50) not null 
go
alter table collectiontype_account add constraint fk_collectiontype_account_parentid 
  foreign key (collectiontypeid) references collectiontype (objid) 
go 

alter table collectiontype_account 
  alter column account_objid nvarchar(50) not null 
go
alter table collectiontype_account add constraint fk_collectiontype_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
go 

-- create index ix_parentid on entity_address (parentid)
-- go
create index ix_address_objid on entity (address_objid)
go 
update a set 
  a.parentid = e.objid 
from entity e, entity_address a 
where e.address_objid = a.objid 
go 
delete from entity_address where parentid not in (select objid from entity where objid = entity_address.parentid) 
go
drop index ix_parentid on entity_address
go 
alter table entity_address alter column parentid nvarchar(50) null 
go
create index ix_parentid on entity_address (parentid)
go 
alter table entity_address add constraint fk_entity_address_parentid 
  foreign key (parentid) references entity (objid) 
go 

drop index uix_entityid_fingertype on entity_fingerprint
go 
alter table entity_fingerprint alter column entityid nvarchar(50) not null 
go 
create index ix_entityid on entity_fingerprint (entityid)
go
create unique index uix_entityid_fingertype on entity_fingerprint (entityid, fingertype) 
go 
alter table entity_fingerprint add constraint fk_entity_fingerprint_entityid 
  foreign key (entityid) references entity (objid) 
go 

select e.* 
into z20181120_entityindividual_no_entity 
from entityindividual e 
where e.objid not in (select objid from entity where objid = e.objid) 
go
create index ix_objid on z20181120_entityindividual_no_entity (objid)
go
delete from entityindividual where objid in (select objid from z20181120_entityindividual_no_entity where objid = entityindividual.objid) 
go 
alter table entityindividual add constraint fk_entityindividual_objid 
  foreign key (objid) references entity (objid) 
go 

select e.* 
into z20181120_entityjuridical_no_entity 
from entityjuridical e 
where e.objid not in (select objid from entity where objid = e.objid) 
go
create index ix_objid on z20181120_entityjuridical_no_entity (objid)
go
delete from entityjuridical where objid in (select objid from z20181120_entityjuridical_no_entity where objid = entityjuridical.objid) 
go 
alter table entityjuridical add constraint fk_entityjuridical_objid 
  foreign key (objid) references entity (objid) 
go 

alter table fund add constraint fk_fund_groupid 
  foreign key (groupid) references fundgroup (objid)
go


-- alter table sys_report add CONSTRAINT fk_sys_report_datasetid 
--   FOREIGN KEY (datasetid) REFERENCES sys_dataset (objid)
-- go 
