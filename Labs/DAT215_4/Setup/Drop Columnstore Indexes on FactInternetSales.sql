/************************************************************************
 * Step 2 - Drop existing columnstore indexes							*
 *																		*
 * Indexes and keys need to be removed to enable a memory optimized     *																*
 * table.																*
 *																		*
 ************************************************************************/

-- All indexes need to be removed before creating a memory-optimized table
SET STATISTICS TIME OFF
GO
USE [AdventureWorksDW]
GO

/****** Columnstore index needs to be dropped, also can only have 8 on the in-memory table ******/
DROP INDEX [CCI_FactInternetSales] ON [dbo].[FactInternetSales] WITH ( ONLINE = OFF )
DROP INDEX [PK_FactInternetSales_SalesOrderNumber_SalesOrderLineNumber] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_DueDateKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_OrderDateKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactIneternetSales_ShipDateKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_CurrencyKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_CustomerKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_ProductKey] ON [dbo].[FactInternetSales]
DROP INDEX [IX_FactInternetSales_PromotionKey] ON [dbo].[FactInternetSales]


GO

/****** All foreign keys need to be removed ******/
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCustomer];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimCurrency];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate1];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimDate2];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimProduct];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimPromotion];
ALTER TABLE [dbo].[FactInternetSales] DROP CONSTRAINT [FK_FactInternetSales_DimSalesTerritory];
GO