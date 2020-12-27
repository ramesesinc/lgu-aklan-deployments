CREATE TABLE sys_email_queue (
  objid varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  state int NOT NULL,
  reportid varchar(50) NULL,
  dtsent datetime NOT NULL,
  [to] varchar(255) NOT NULL,
  subject varchar(255) NOT NULL,
  message text NOT NULL,
  errmsg varchar(MAX) NULL,
  connection varchar(50) NULL,
  constraint pk_sys_email_queue PRIMARY KEY (objid)
) 
go 
create index ix_refid on sys_email_queue (refid)
go
create index ix_state on sys_email_queue (state)
go
create index ix_reportid on sys_email_queue (reportid)
go
create index ix_dtsent on sys_email_queue (dtsent)
go