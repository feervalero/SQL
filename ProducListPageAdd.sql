USE [MXBrands]
GO

/****** Object:  StoredProcedure [dbo].[Add_ProductListPageDetail]    Script Date: 02/04/2019 05:37:27 p.m. ******/
IF EXISTS (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_NAME = 'Add_ProductListPageDetail') DROP PROCEDURE [dbo].[Add_ProductListPageDetail]
GO

/****** Object:  StoredProcedure [dbo].[Add_ProductListPageDetail]    Script Date: 02/04/2019 05:37:27 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Fernando Valero
-- Create date: 2019
-- Description:	Add ProductListPageDetail
-- =============================================
CREATE PROCEDURE [dbo].[Add_ProductListPageDetail]
	-- Add the parameters for the stored procedure here
	@Url varchar(255),
	@Sku varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ProductListPageId UNIQUEIDENTIFIER = (SELECT [Id] FROM [dbo].[ProductListPage] WHERE [Url] = @Url);
	DECLARE @ProductId UNIQUEIDENTIFIER = (SELECT [Id] FROM [dbo].[Productos] WHERE [SKU] = @Sku);
	
	IF(@ProductId IS NULL)
		INSERT INTO [dbo].[Productos](SKU) VALUES(@Sku);
		SET @ProductId = (SELECT [Id] FROM [dbo].[Productos] WHERE [SKU] = @Sku)

	IF (@ProductListPageId IS NOT NULL) 
		INSERT INTO [dbo].[ProductListPageDetail]([ProductListPageId],[ProductId]) VALUES (@ProductListPageId,@ProductId);
	
	

	SET NOCOUNT OFF;
END



GO


