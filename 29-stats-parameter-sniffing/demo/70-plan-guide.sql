USE [WideWorldImporters]
GO

/****** Object:  PlanGuide PlanGuideRecompile_GetInvoiceMetricsByBillToCustomerID    Script Date: 10/22/2024 11:13:36 AM ******/
EXEC sp_create_plan_guide @name = N'[PlanGuideRecompile_GetInvoiceMetricsByBillToCustomerID]', @stmt = N'SELECT
		si.CustomerID,
		si.BillToCustomerID,
		si.InvoiceID,
		si.InvoiceDate,
		si.ConfirmedDeliveryTime,
		si.IsCreditNote
	FROM Sales.Invoices AS si
	WHERE si.BillToCustomerID = @BillToCustomerID;', @type = N'OBJECT', @module_or_batch = N'[Sales].[GetInvoiceMetricsByBillToCustomerID]', @hints = N'OPTION (RECOMPILE)'
GO


