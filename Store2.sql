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
IF EXISTS (SELECT * FROM MXBrands.sys.procedures where name = 'CompareProductsStep1') DROP PROCEDURE CompareProductsStep1;

GO
CREATE PROCEDURE CompareProductsStep1 
	-- Add the parameters for the stored procedure here
	@newId UNIQUEIDENTIFIER = NEWID
	
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	DECLARE @LastStableVersionOr int = (SELECT top 1 [Version] FROM dbo.AllProducts ORDER BY [Version] DESC)
	
	SELECT * INTO #MyAllProducts
		FROM dbo.AllProducts where [Version] = @LastStableVersionOr
	
	SELECT * INTO #MyTempProducts
		FROM dbo.TempProducts 

	DECLARE @DIFF int = (
		SELECT count(*) FROM [#MyTempProducts] a
			LEFT JOIN [#MyAllProducts] t ON (a.MaterialFeature = t.MaterialFeature)
		WHERE 
			a.[Description] != COALESCE(t.[Description],'')
			OR a.[Feature] != COALESCE(t.[Feature],'')
			OR a.[FeatureDescription] != COALESCE(t.[FeatureDescription],'')
	);

	if( @DIFF > 0 ) --Hay differencias
		--INSERT INTO dbo.AllProducts (ID,SKU,MaterialFeature,[Description],Price,BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,[Version],StableVersion)
		SELECT a.SKU, 
			CASE
				WHEN a.[Description] != COALESCE(t.[Description],'') THEN ''+t.[Description]+'-||-'+a.[Description] ELSE 'NO'
			END AS 'IsDescDifferent'
			,
			CASE 
				WHEN a.[Feature] != COALESCE(t.[Feature],'') THEN ''+t.[Feature]+'-||-'+a.[Feature] ELSE 'NO'
			END AS 'IsFeatDif',
			CASE
				WHEN a.[FeatureDescription] != COALESCE(t.[FeatureDescription],'') THEN ''+t.[FeatureDescription]+'-||-'+a.[FeatureDescription] ELSE 'NO'
			END AS 'IsFeatDescDif'
			--'er',a.ID,a.SKU,a.MaterialFeature,a.[Description],a.Price,a.BrandCode,a.Segmento,a.Category,a.Feature,a.FeatureDescription,a.FeatureType,a.[Version],a.StableVersion
			FROM [#MyTempProducts] a
				LEFT JOIN [#MyAllProducts] t ON (a.MaterialFeature = t.MaterialFeature)
		WHERE 
			COALESCE(a.[Description],'') != COALESCE(t.[Description],'')
			OR COALESCE(a.[Feature],'') != COALESCE(t.[Feature],'')
			OR COALESCE(a.[FeatureDescription],'') != COALESCE(t.[FeatureDescription],'')
		ORDER BY a.MaterialFeature
	ELSE
		INSERT INTO dbo.AllProducts (ID,SKU,MaterialFeature,[Description],Price,BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,[Version],StableVersion)
			SELECT a.ID,a.SKU,a.MaterialFeature,a.[Description],a.Price,a.BrandCode,a.Segmento,a.Category,a.Feature,a.FeatureDescription,a.FeatureType,a.[Version],a.StableVersion
				FROM [#MyTempProducts] a
					LEFT JOIN [#MyAllProducts] t ON (a.MaterialFeature = t.MaterialFeature)
			WHERE 
				a.[Description] != COALESCE(t.[Description],'')
				OR a.[Feature] != COALESCE(t.[Feature],'')
				OR a.[FeatureDescription] != COALESCE(t.[FeatureDescription],'')
		--SELECT 'ok',* FROM AllProducts Where StableVersion = 1 and [Version] = @LastStableVersionOr

	Drop table #MyAllProducts
	Drop table #MyTempProducts
	
	SET NOCOUNT OFF;

END
GO
