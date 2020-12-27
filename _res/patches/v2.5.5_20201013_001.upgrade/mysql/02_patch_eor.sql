update paymentpartner set code='101', indexno='101' where objid='DBP';
update paymentpartner set code='102', indexno='102' where objid='LBP';


CREATE TABLE `epayment_plugin` (
  `objid` varchar(50) NOT NULL,
  `connection` varchar(50) NULL,
  `servicename` varchar(255) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('bpls', 'bpls', 'OnlineBusinessBillingService');
INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('rptcol', 'rpt', 'OnlineLandTaxBillingService');
INSERT INTO `epayment_plugin` (`objid`, `connection`, `servicename`) VALUES ('rpttaxclearance', 'landtax', 'OnlineRealtyTaxClearanceService');


CREATE TABLE `eor_for_email` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `email` varchar(255) NULL,
  `mobileno` varchar(50) NULL,
  `state` int NULL,
  `dtsent` datetime NULL,
  `errmsg` varchar(255) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


drop table if exists ztmp_fix_eor
;
create table ztmp_fix_eor
select eor.objid from eor 
  left join eor_remittance r on r.objid = eor.remittanceid 
where r.objid is null 
;
update eor set remittanceid = null where objid in ( 
  select objid from ztmp_fix_eor 
)
;
drop table if exists ztmp_fix_eor
;


alter table eor add constraint fk_eor_remittanceid 
  foreign key (remittanceid) references eor_remittance (objid) 
; 


