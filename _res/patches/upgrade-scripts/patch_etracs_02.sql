use etracs255_aklan
go 


-- EXEC sp_rename N'[dbo].[af_inventory_return]', N'z20181120_af_inventory_return' ; 
EXEC sp_rename N'[dbo].[af_inventory_detail_cancelseries]', N'z20181120_af_inventory_detail_cancelseries' ; 
EXEC sp_rename N'[dbo].[af_inventory_detail]', N'z20181120_af_inventory_detail' ; 
EXEC sp_rename N'[dbo].[af_inventory]', N'z20181120_af_inventory' ; 


EXEC sp_rename N'[dbo].[ap_detail]', N'z20181120_ap_detail' ; 
EXEC sp_rename N'[dbo].[ap]', N'z20181120_ap' ; 
EXEC sp_rename N'[dbo].[ar_detail]', N'z20181120_ar_detail' ; 
EXEC sp_rename N'[dbo].[ar]', N'z20181120_ar' ; 


EXEC sp_rename N'[dbo].[bankaccount_entry]', N'z20181120_bankaccount_entry' ; 
EXEC sp_rename N'[dbo].[bankaccount_account]', N'z20181120_bankaccount_account' ; 


EXEC sp_rename N'[dbo].[bankdeposit_liquidation]', N'z20181120_bankdeposit_liquidation' ; 
EXEC sp_rename N'[dbo].[bankdeposit_entry_check]', N'z20181120_bankdeposit_entry_check' ; 
EXEC sp_rename N'[dbo].[bankdeposit_entry]', N'z20181120_bankdeposit_entry' ; 
EXEC sp_rename N'[dbo].[bankdeposit]', N'z20181120_bankdeposit' ; 


EXEC sp_rename N'[dbo].[cashbook_entry]', N'z20181120_cashbook_entry' ; 
EXEC sp_rename N'[dbo].[cashbook]', N'z20181120_cashbook' ; 


EXEC sp_rename N'[dbo].[directcash_collection_item]', N'z20181120_directcash_collection_item' ; 
EXEC sp_rename N'[dbo].[directcash_collection]', N'z20181120_directcash_collection' ; 


EXEC sp_rename N'[dbo].[liquidation_remittance]', N'z20181120_liquidation_remittance' ; 
EXEC sp_rename N'[dbo].[liquidation_noncashpayment]', N'z20181120_liquidation_noncashpayment' ; 
EXEC sp_rename N'[dbo].[liquidation_creditmemopayment]', N'z20181120_liquidation_creditmemopayment' ; 
EXEC sp_rename N'[dbo].[liquidation_cashier_fund]', N'z20181120_liquidation_cashier_fund' ; 
EXEC sp_rename N'[dbo].[liquidation]', N'z20181120_liquidation' ; 


EXEC sp_rename N'[dbo].[ngas_revenue_deposit]', N'z20181120_ngas_revenue_deposit' ; 
EXEC sp_rename N'[dbo].[ngas_revenue_remittance]', N'z20181120_ngas_revenue_remittance' ; 
EXEC sp_rename N'[dbo].[ngas_revenueitem]', N'z20181120_ngas_revenueitem' ; 
EXEC sp_rename N'[dbo].[ngas_revenue]', N'z20181120_ngas_revenue' ; 


EXEC sp_rename N'[dbo].[remittance_noncashpayment]', N'z20181120_remittance_noncashpayment' ; 
EXEC sp_rename N'[dbo].[remittance_creditmemopayment]', N'z20181120_remittance_creditmemopayment' ; 
EXEC sp_rename N'[dbo].[remittance_cashreceipt]', N'z20181120_remittance_cashreceipt' ; 


EXEC sp_rename N'[dbo].[stockissueitem]', N'z20181120_stockissueitem' ; 
EXEC sp_rename N'[dbo].[stockissue]', N'z20181120_stockissue' ; 

EXEC sp_rename N'[dbo].[stockreceiptitem]', N'z20181120_stockreceiptitem' ; 
EXEC sp_rename N'[dbo].[stockreceipt]', N'z20181120_stockreceipt' ; 

EXEC sp_rename N'[dbo].[stocksaleitem]', N'z20181120_stocksaleitem' ; 
EXEC sp_rename N'[dbo].[stocksale]', N'z20181120_stocksale' ; 

EXEC sp_rename N'[dbo].[stockrequestitem]', N'z20181120_stockrequestitem' ; 
EXEC sp_rename N'[dbo].[stockrequest]', N'z20181120_stockrequest' ; 

-- EXEC sp_rename N'[dbo].[stockreturn]', N'z20181120_stockreturn' ; 

EXEC sp_rename N'[dbo].[stockitem_unit]', N'z20181120_stockitem_unit' ; 
EXEC sp_rename N'[dbo].[stockitem]', N'z20181120_stockitem' ; 

-- EXEC sp_rename N'[dbo].[eor_paymentorder]', N'z20181120_eor_paymentorder';
-- EXEC sp_rename N'[dbo].[payment_partner]', N'z20181120_payment_partner'; 


if object_id('dbo.draft_remittance_cashreceipt', 'U') IS NOT NULL 
	drop table draft_remittance_cashreceipt; 
go 
if object_id('dbo.draft_remittance', 'U') IS NOT NULL 
	drop table draft_remittance; 
go 


-- EXEC sp_rename N'[dbo].[cashreceiptpayment_eor]', N'z20181120_cashreceiptpayment_eor';

EXEC sp_rename N'[dbo].[account]', N'z20181120_account';
EXEC sp_rename N'[dbo].[account_incometarget]', N'z20181120_account_incometarget';

go 
