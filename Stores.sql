-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Fernando Valero
-- Create date: 
-- Description:	This procedure is to populate the TempProducts table from the information in Products
-- =============================================
IF EXISTS (SELECT * FROM MXBrands.sys.procedures where name = 'PopulateTempProducts') DROP PROCEDURE PopulateTempProducts;

GO
CREATE PROCEDURE PopulateTempProducts 
	-- Add the parameters for the stored procedure here
	@newId UNIQUEIDENTIFIER = NEWID
	
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DELETE FROM [dbo].[TempProducts]
	
	DECLARE @tempTable AS TABLE(
		[ID] [uniqueidentifier] NOT NULL,
		[SKU] [varchar](50) NULL,
		[MaterialFeature] [nvarchar](255) NULL,
		[Description] [nvarchar](100) NULL,
		[Price] [nvarchar](50) NULL,
		[BrandCode] [nvarchar](3) NULL,
		[Segmento] [nvarchar](100) NULL,
		[Category] [nvarchar](100) NULL,
		[Feature] [nvarchar](100) NULL,
		[FeatureDescription] [nvarchar](500) NULL,
		[FeatureType] [nvarchar](100) NULL,
		[Version] [int] NULL,
		[StableVersion] [int] NOT NULL
	)

	DECLARE @StableVersion int = 0;
	DECLARE @VersionOr int = (Select top 1 [Version] from TempProducts Order By [Version] desc);
	DECLARE @Version int = COALESCE(@VersionOr, 0);
	
    -- Insert statements for procedure here
	INSERT INTO @tempTable(ID,SKU,MaterialFeature,[Description], [Price], BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,[Version],StableVersion)
		SELECT ID,SKU,MaterialFeature,[Description], [Price], BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,
			@Version+1,0
			FROM [dbo].[Products]
	
	INSERT INTO [dbo].[TempProducts] (ID,SKU,MaterialFeature,[Description], [Price], BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,[Version],StableVersion)
		SELECT * FROM @tempTable


END
GO
