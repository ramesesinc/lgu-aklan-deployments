CREATE TABLE cashreceipt_rpt_share_forposting (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  txndate datetime NOT NULL,
  error int NOT NULL,
  msg text NULL, 
  constraint pk_cashreceipt_rpt_share_forposting primary key (objid)
) 
go 
create UNIQUE index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting (receiptid,rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_rptledger on cashreceipt_rpt_share_forposting (rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_cashreceipt on cashreceipt_rpt_share_forposting (receiptid)
go 
alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposting_receiptid 
  FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 
alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposting_rptledgerid 
  FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 
