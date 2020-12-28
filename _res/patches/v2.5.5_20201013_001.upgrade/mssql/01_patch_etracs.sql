
-- CREATE TABLE cashreceipt_plugin ( 
--    objid varchar(50) NOT NULL, 
--    connection varchar(150) NOT NULL, 
--    servicename varchar(255) NOT NULL,
--    CONSTRAINT pk_cashreceipt_plugin PRIMARY KEY (objid)
-- ) 
-- go 

update cashreceipt_plugin set connection = objid where connection is null 
go 
