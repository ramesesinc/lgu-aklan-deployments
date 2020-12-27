drop view if exists vw_rptcertification_item
;

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
;

/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
;

update faas_previous pf, faas f, rpu r
set pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
where pf.prevfaasid = f.objid
  and f.rpuid = r.objid 
  and pf.prevtaxability is null 
;



CREATE TABLE rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  type varchar(25) NOT NULL,
  txnno varchar(25) NULL,
  txndate datetime NULL,
  reftype varchar(25) NULL,
  refid varchar(50) NULL,
  refno varchar(25) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtapplied decimal(16,2) NOT NULL,
  rptledger_objid varchar(50) NOT NULL,
  srcledger_objid varchar(50) NULL,
  remarks varchar(255) NULL,
  approvedby_objid varchar(50) NULL,
  approvedby_name varchar(150) NULL,
  approvedby_title varchar(75) NULL,
  constraint pk_rpttaxcredit PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_state on rpttaxcredit(state)
;
create index ix_type on rpttaxcredit(type)
;
create unique index ux_txnno on rpttaxcredit(txnno)
;
create index ix_reftype on rpttaxcredit(reftype)
;
create index ix_refid on rpttaxcredit(refid)
;
create index ix_refno on rpttaxcredit(refno)
;
create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
;
create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
;

alter table rpttaxcredit modify rptledger_objid varchar(50) character set latin1 NOT NULL
;
alter table rpttaxcredit add constraint fk_rpttaxcredit_rptledger 
  foreign key (rptledger_objid) references rptledger (objid)
;

alter table rpttaxcredit modify srcledger_objid varchar(50) character set latin1 NULL
;
alter table rpttaxcredit add constraint fk_rpttaxcredit_srcledger 
  foreign key (srcledger_objid) references rptledger (objid)
;

alter table rpttaxcredit modify approvedby_objid varchar(50) character set latin1 NULL
;
alter table rpttaxcredit add constraint fk_rpttaxcredit_sys_user 
  foreign key (approvedby_objid) references sys_user(objid)
;



CREATE TABLE batch_rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  txndate date NOT NULL,
  txnno varchar(25) NOT NULL,
  rate decimal(10,2) NOT NULL,
  paymentfrom date NULL,
  paymentto varchar(255) NULL,
  creditedyear int NOT NULL,
  reason varchar(255) NOT NULL,
  validity date NULL,
  constraint pk_batch_rpttaxcredit PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_state on batch_rpttaxcredit(state)
;
create index ix_txnno on batch_rpttaxcredit(txnno)
;

CREATE TABLE batch_rpttaxcredit_ledger (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  error varchar(255) NULL,
  barangayid varchar(50) not null, 
  constraint pk_batch_rpttaxcredit_ledger PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parentid on batch_rpttaxcredit_ledger (parentid)
;
create index ix_state on batch_rpttaxcredit_ledger (state)
;
create index ix_barangayid on batch_rpttaxcredit_ledger (barangayid)
;

alter table batch_rpttaxcredit_ledger add constraint fk_rpttaxcredit_rptledger_parent 
  foreign key(parentid) references batch_rpttaxcredit(objid)
;

alter table batch_rpttaxcredit_ledger modify objid varchar(50) character set latin1 NOT NULL 
;
alter table batch_rpttaxcredit_ledger add constraint fk_rpttaxcredit_rptledger_rptledger 
  foreign key(objid) references rptledger(objid)
;



CREATE TABLE batch_rpttaxcredit_ledger_posted (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  barangayid varchar(50) NOT NULL,
  constraint pk_batch_rpttaxcredit_ledger_posted PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

create index ix_parentid on batch_rpttaxcredit_ledger_posted(parentid)
;
create index ix_barangayid on batch_rpttaxcredit_ledger_posted(barangayid)
;

alter table batch_rpttaxcredit_ledger_posted add constraint fk_rpttaxcredit_rptledger_posted_parent 
  foreign key(parentid) references batch_rpttaxcredit (objid)
;

alter table batch_rpttaxcredit_ledger_posted modify objid varchar(50) character set latin1 NOT NULL
;
alter table batch_rpttaxcredit_ledger_posted add constraint fk_rpttaxcredit_rptledger_posted_rptledger 
  foreign key(objid) references rptledger (objid)
;

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
;

alter table rpttaxcredit add info text
;


alter table rpttaxcredit add discapplied decimal(16,2) not null
;

update rpttaxcredit set discapplied = 0 where discapplied is null 
;


/* 255-03023 */

alter table rptledger_item add fromqtr int
;
alter table rptledger_item add toqtr int
;


/* 255-03016 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/
alter table rptpayment_share add iscommon int
;

alter table rptpayment_share add year int
;

update rptpayment_share set iscommon = 0 where iscommon is null 
;


/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date
;

alter table batchgr_item add subsuffix int NULL
;


CREATE TABLE machine_smv (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  machine_objid varchar(50) NOT NULL,
  expr varchar(255) NOT NULL,
  previd varchar(50) NULL,
  constraint pk_machine_smv PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index ux_parent_machine on machine_smv (parent_objid,machine_objid)
;
create index ix_parent_objid on machine_smv (parent_objid)
;
create index ix_machine_objid on machine_smv (machine_objid)
;
create index ix_previd on machine_smv (previd)
;

alter table machine_smv modify machine_objid varchar(50) character set latin1 NOT NULL
;
alter table machine_smv add CONSTRAINT fk_machinesmv_machine 
  FOREIGN KEY (machine_objid) REFERENCES machine (objid) 
;

alter table machine_smv add CONSTRAINT fk_machinesmv_machinesmv 
  FOREIGN KEY (previd) REFERENCES machine_smv (objid) 
;

alter table machine_smv modify parent_objid varchar(50) character set latin1 NOT NULL
;
alter table machine_smv add CONSTRAINT fk_machinesmv_machrysetting 
  FOREIGN KEY (parent_objid) REFERENCES machrysetting (objid) 
;



alter table machdetail add smvid varchar (50)
;
alter table machdetail add params text
;

update machdetail set params = '[]' where params is null
;

create index ix_smvid on machdetail(smvid)
;


alter table machdetail modify smvid varchar (50) character set utf8 NULL 
;
alter table machdetail add constraint fk_machdetail_machine_smv 
  foreign key(smvid) references machine_smv (objid)
;
