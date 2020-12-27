drop table if exists eor_payment_error
;
CREATE TABLE `eor_payment_error` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `paymentrefid` varchar(50) NOT NULL,
  `errmsg` text NOT NULL,
  `errdetail` longtext,
  `errcode` int(1) DEFAULT NULL,
  `laststate` int(1) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_txndate` (`txndate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `eor_manual_post` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `paymentorderno` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `paymentpartnerid` varchar(50) DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracedate` datetime DEFAULT NULL,
  `reason` tinytext,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_eor_manual_post_paymentorderno` (`paymentorderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  `jevdate` date DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `verifiedby_objid` varchar(50) DEFAULT NULL,
  `verifiedby_name` varchar(255) DEFAULT NULL,
  `dtverified` datetime DEFAULT NULL,
  `batchid` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_batchid` (`batchid`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_dtverified` (`dtverified`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_verifiedby_objid` (`verifiedby_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 

CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) DEFAULT NULL,
  `accttype` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `acctcode` varchar(32) DEFAULT NULL,
  `acctname` varchar(255) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  `itemrefid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevid` (`jevid`),
  KEY `ix_ledgertype` (`accttype`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_acctcode` (`acctcode`),
  KEY `ix_acctname` (`acctname`),
  KEY `ix_itemrefid` (`itemrefid`),
  CONSTRAINT `fk_jevitem_jevid` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table eor_payment_error modify errmsg longtext not null
;


create table sys_email_template (
  `objid` varchar(50) not null, 
  `subject` varchar(255) not null, 
  `message` longtext not null, 
  constraint pk_sys_email_template primary key (objid) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 
