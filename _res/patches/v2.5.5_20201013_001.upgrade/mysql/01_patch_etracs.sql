alter table rptpayment drop foreign key fk_rptpayment_cashreceipt
;


CREATE TABLE `rptledger_redflag` (
  `objid` varchar(50) NOT NULL,
  `parent_objid` varchar(50) character set latin1 NOT NULL,
  `state` varchar(25) NOT NULL,
  `caseno` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `type` varchar(25) NOT NULL,
  `finding` text,
  `remarks` text,
  `blockaction` varchar(25) NULL,
  `filedby_objid` varchar(50) character set latin1 NULL,
  `filedby_name` varchar(255) NULL,
  `filedby_title` varchar(50) NULL,
  `resolvedby_objid` varchar(50) character set latin1 NULL,
  `resolvedby_name` varchar(255) NULL,
  `resolvedby_title` varchar(50) NULL,
  `dtresolved` datetime NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ux_caseno` (`caseno`),
  KEY `ix_parent_objid` (`parent_objid`),
  KEY `ix_state` (`state`),
  KEY `ix_type` (`type`),
  KEY `ix_filedby_objid` (`filedby_objid`),
  KEY `ix_resolvedby_objid` (`resolvedby_objid`),
  CONSTRAINT `fk_rptledger_redflag_filedby` FOREIGN KEY (`filedby_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_rptledger_redflag_resolvedby` FOREIGN KEY (`resolvedby_objid`) REFERENCES `sys_user` (`objid`),
  CONSTRAINT `fk_rptledger_redflag_rptledger` FOREIGN KEY (`parent_objid`) REFERENCES `rptledger` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

update cashreceipt_plugin set `connection` = objid 
; 
