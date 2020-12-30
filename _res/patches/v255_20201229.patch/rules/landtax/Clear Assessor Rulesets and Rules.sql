declare @ruleset varchar(100)

select @ruleset = 'rptledger' 

delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
)
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
)
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule where ruleset=@ruleset 

delete from sys_ruleset_fact where ruleset=@ruleset

delete from sys_ruleset_actiondef where ruleset=@ruleset

delete from sys_rulegroup where ruleset=@ruleset 

delete from sys_ruleset where name=@ruleset 





select @ruleset = 'rptbilling' 


delete from sys_rule_action_param where parentid in ( 
  select ra.objid 
  from sys_rule r, sys_rule_action ra 
  where r.ruleset=@ruleset and ra.parentid=r.objid 
)

delete from sys_rule_actiondef_param where parentid in ( 
  select ra.objid from sys_ruleset_actiondef rsa 
    inner join sys_rule_actiondef ra on ra.objid=rsa.actiondef 
  where rsa.ruleset=@ruleset
)
delete from sys_rule_actiondef where objid in ( 
  select actiondef from sys_ruleset_actiondef where ruleset=@ruleset 
)
delete from sys_rule_action where parentid in ( 
  select objid from sys_rule 
  where ruleset=@ruleset 
)

delete from sys_rule_condition_constraint where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition_var where parentid in ( 
  select rc.objid 
  from sys_rule r, sys_rule_condition rc 
  where r.ruleset=@ruleset and rc.parentid=r.objid 
)

delete from sys_rule_condition where parentid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule_deployed where objid in ( 
  select objid from sys_rule where ruleset=@ruleset 
)

delete from sys_rule where ruleset=@ruleset 

delete from sys_ruleset_fact where ruleset=@ruleset

delete from sys_ruleset_actiondef where ruleset=@ruleset

delete from sys_rulegroup where ruleset=@ruleset 

delete from sys_ruleset where name=@ruleset 




