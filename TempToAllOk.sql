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
IF EXISTS (SELECT * FROM MXBrands.sys.procedures where name = 'TempToAllOk') DROP PROCEDURE TempToAllOk;

GO
CREATE PROCEDURE TempToAllOk 
	-- Add the parameters for the stored procedure here
	@newId UNIQUEIDENTIFIER = NEWID
	
AS
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @LastStableVersionOr int = (SELECT top 1 [Version] FROM dbo.AllProducts ORDER BY [Version] DESC)

	DECLARE @time datetime = GETDATE();

	INSERT INTO [dbo].[AllProducts] (SKU,MaterialFeature,[Description],Price,BrandCode,Segmento,Category,Feature,FeatureDescription,FeatureType,[Version],StableVersion,UpdatedDateTime,CreatedDateTime)
		SELECT T.SKU,T.MaterialFeature,T.[Description],T.Price,T.BrandCode,T.Segmento,T.Category,T.Feature,T.FeatureDescription,T.FeatureType,@LastStableVersionOr+1,1,@time,@time
		FROM [dbo].[TempProducts] T

	Truncate Table [dbo].[TempProducts]
	
	
	SET NOCOUNT OFF;

END
GO
