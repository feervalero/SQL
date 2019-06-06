use MXBrands

IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductListPageDetail') DROP TABLE [dbo].[ProductListPageDetail];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductListPage') DROP TABLE [dbo].[ProductListPage];

IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductDetail') DROP TABLE [dbo].[ProductDetail];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductDetailPage') DROP TABLE [dbo].[ProductDetailPage];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Productos') DROP TABLE [dbo].[Productos];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DetailType') DROP TABLE [dbo].[DetailType];


CREATE TABLE [dbo].[DetailType](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_DetailType_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[DetailDescription] nvarchar(255) NOT NULL,
	[RowVersion] [ROWVERSION] NOT NULL
	CONSTRAINT [PK_DetailType] PRIMARY KEY CLUSTERED ([Id] ASC)
);

GO
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('MainFeatureDescription');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('AdditionalFeatureDescription');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('MainFeatureTitle');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('AdditionalFeatureTitle');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('ImageHero');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('ImageThumbnail');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Title');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Url');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Price');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Manual');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('PDNo-P');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('No-Documents');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('No-Searchable');



CREATE TABLE [dbo].[Productos](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_Productos_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[SKU] [varchar](50) NOT NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	[Version] [int] NULL,
	CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO




CREATE TABLE [dbo].[ProductDetailPage](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_ProductDetailPage_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[ProductoId] UNIQUEIDENTIFIER NOT NULL,
	[URL] nvarchar(255) NULL,
	[Date] nvarchar(10) NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ProductDetailPage] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_ProductDetailPage_Producto] FOREIGN KEY ([ProductoId]) REFERENCES [dbo].[Productos] ([Id])
);
GO

CREATE TABLE [dbo].[ProductDetail](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_ProductDetail_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[DetailTypeId] UNIQUEIDENTIFIER NOT NULL,
	[ProductDetailPageId] UNIQUEIDENTIFIER NOT NULL,
	[Value] nvarchar(255) NOT NULL,
	[Date] nvarchar(10) NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ProductDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_ProductDetail_DetailType] FOREIGN KEY ([DetailTypeId]) REFERENCES [dbo].[DetailType] ([Id]),
	CONSTRAINT [FK_ProductDetail_ProductDetailPage] FOREIGN KEY ([ProductDetailPageId]) REFERENCES [dbo].[ProductDetailPage] ([Id])
);
GO



CREATE TABLE [dbo].[ProductListPage](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_ProductListPage_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[URL] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	[Version] [int] NULL,
	CONSTRAINT [PK_ProductListPage] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO
CREATE TABLE [dbo].[ProductListPageDetail](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_ProductListPageDetail_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[ProductListPageId] UNIQUEIDENTIFIER NOT NULL,
	[ProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	[Version] [int] NULL,
	CONSTRAINT [PK_ProductListPageDetail] PRIMARY KEY CLUSTERED ([Id] ASC),
	CONSTRAINT [FK_ProductListPageDetail_Productos] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Productos] ([Id]),
	CONSTRAINT [FK_ProductListPageDetail_ProductListPage] FOREIGN KEY ([ProductListPageId]) REFERENCES [dbo].[ProductListPage] ([Id])
);
GO

/*
*
*                           CREATE STORE PROCEDURES
*
*
*
*
exec GetPendingManuals
exec [GetDetailTypeId] 'No-PDP'
*
*/



/****** Object:  StoredProcedure [dbo].[Add_Image]    Script Date: 03/04/2019 05:17:35 p.m. ******/
DROP PROCEDURE [dbo].[GetPendingManuals]
GO


CREATE PROCEDURE [dbo].[GetPendingManuals]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
	DECLARE @TODAY VARCHAR(6) = REPLACE((CONVERT(VARCHAR(20), GETDATE(), 5)),'-','')
	select distinct s.ModelNumber
	from SKU s
	left join Productos p on p.SKU = s.ModelNumber
	left join ProductDetailPage pdp on pdp.ProductoId = p.Id
	left join ProductDetail pd on pd.ProductDetailPageId = pdp.Id and COALESCE(pd.[Date],'0') = @TODAY
	where pd.Id is null
	
	SET NOCOUNT OFF;
END

GO




/****** Object:  StoredProcedure [dbo].[GetDetailTypeId]    Script Date: 03/04/2019 05:17:35 p.m. ******/
DROP PROCEDURE [dbo].[GetDetailTypeId]
GO


CREATE PROCEDURE [dbo].[GetDetailTypeId]
	-- Add the parameters for the stored procedure here
	@DetailDescription nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT [Id] FROM [DetailType] WHERE DetailDescription like @DetailDescription
	
	SET NOCOUNT OFF;
END

GO


DROP PROCEDURE [dbo].[AddItem]
GO


CREATE PROCEDURE [dbo].[AddItem]
	-- Add the parameters for the stored procedure here
	@SKU nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @exist int = (SELECT count(*) FROM [dbo].[Productos] WHERE SKU = @SKU)

	IF(@exist<=0) 
		INSERT INTO [dbo].[Productos](SKU) VALUES (@SKU)
	
	SELECT [Id] FROM [dbo].[Productos] WHERE SKU = @SKU

	SET NOCOUNT OFF;
END

GO

--------------------------------------------------------------------------------------------------
DROP PROCEDURE [dbo].[AddPDP]
GO


CREATE PROCEDURE [dbo].[AddPDP]
	-- Add the parameters for the stored procedure here
	@SKU nvarchar(255),
	@URL nvarchar(255),
	@Date nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @exist int = (select count(*) from dbo.ProductDetailPage pdp join Productos p on p.Id = pdp.ProductoId where p.SKU = @SKU)
	
	IF(@exist<=0) 
		INSERT INTO [dbo].[ProductDetailPage](ProductoId,URL,[Date]) 
		VALUES (
			(SELECT top 1 [Id] FROM [dbo].[Productos] WHERE SKU = @SKU),
			@URL,
			@Date
		)
	
	select pdp.Id from dbo.ProductDetailPage pdp join Productos p on p.Id = pdp.ProductoId where p.SKU = @SKU

	SET NOCOUNT OFF;
END

GO


--------------------------------------------------------------------------------------------------
DROP PROCEDURE [dbo].[AddPLP]
GO


CREATE PROCEDURE [dbo].[AddPLP]
	-- Add the parameters for the stored procedure here
	@URL nvarchar(255),
	@Name nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @exist int = (select count(*) from dbo.ProductListPage plp WHERE plp.URL = @URL)
	
	IF(@exist<=0) 
		INSERT INTO [dbo].[ProductListPage](URL,Name) 
		VALUES (@URL,@Name)
	
	select plp.Id from dbo.ProductListPage plp where plp.URL = @URL

	SET NOCOUNT OFF;
END

GO


--------------------------------------------------------------------------------------------------------------

USE [MXBrands]
GO

/****** Object:  StoredProcedure [dbo].[Add_ProductListPageDetail]    Script Date: 09/04/2019 02:09:44 p.m. ******/
DROP PROCEDURE [dbo].[Add_ProductListPageDetail]
GO


CREATE PROCEDURE [dbo].[Add_ProductListPageDetail]
	-- Add the parameters for the stored procedure here
	@URL varchar(255),
	@Sku varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ProductListPageId UNIQUEIDENTIFIER = (SELECT [Id] FROM [dbo].[ProductListPage] WHERE [URL] = @URL);
	DECLARE @ProductId UNIQUEIDENTIFIER = (SELECT [Id] FROM [dbo].[Productos] WHERE [SKU] = @Sku);
	
	IF(@ProductId IS NULL)
		INSERT INTO [dbo].[Productos](SKU) VALUES(@Sku);
		SET @ProductId = (SELECT [Id] FROM [dbo].[Productos] WHERE [SKU] = @Sku)

	IF (@ProductListPageId IS NOT NULL) 
		INSERT INTO [dbo].[ProductListPageDetail]([ProductListPageId],[ProductId]) VALUES (@ProductListPageId,@ProductId);
	
	

	SET NOCOUNT OFF;
END
GO
--------------------------------------------------------------------------------------------------------------


DROP PROCEDURE [dbo].[AddProductDetail]
GO


CREATE PROCEDURE [dbo].[AddProductDetail]
	-- Add the parameters for the stored procedure here
	@DetailTypeId UNIQUEIDENTIFIER,
	@ProductDetailPageId UNIQUEIDENTIFIER,
	@Value nvarchar(255),
	@Date nvarchar(255)
	
AS
BEGIN

    -- Insert statements for procedure here
	DECLARE @exist int = (select count(*) from dbo.ProductDetail pd WHERE ProductDetailPageId = @ProductDetailPageId and [Date] = @Date and DetailTypeId = @DetailTypeId)
	
	IF(@exist<=0) 
		INSERT INTO [dbo].[ProductDetail](DetailTypeId,ProductDetailPageId,Value,[Date]) 
		VALUES (
			@DetailTypeId,
			@ProductDetailPageId,
			@Value,
			@Date
		)
	
	select pd.Id from dbo.ProductDetail pd WHERE ProductDetailPageId = @ProductDetailPageId and [Date] = @Date and DetailTypeId = @DetailTypeId
	
END
GO

