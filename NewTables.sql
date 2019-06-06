use DBWHR
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductListPageDetail') DROP TABLE [dbo].[ProductListPageDetail];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductListPage') DROP TABLE [dbo].[ProductListPage];



IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductDetail') DROP TABLE [dbo].[ProductDetail];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductDetailPage') DROP TABLE [dbo].[ProductDetailPage];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Productos') DROP TABLE [dbo].[Productos];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DetailType') DROP TABLE [dbo].[DetailType];
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'SKU') DROP TABLE [dbo].[SKU];

CREATE TABLE [dbo].[SKU] (
    [ModelNumber] NVARCHAR (50) NULL,
    [BrandCode]   NVARCHAR (50) NULL
);
GO

CREATE TABLE [dbo].[DetailType](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_DetailType_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[DetailDescription] nvarchar(255) NOT NULL,
	[RowVersion] [ROWVERSION] NOT NULL
	CONSTRAINT [PK_DetailType] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Feature');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('ImageHero');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('ImageThumbnail');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Title');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Url');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Price');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('Manual');
INSERT INTO [dbo].[DetailType](DetailDescription) VALUES ('No-PDP');

CREATE TABLE [dbo].[Productos](
	[Id] UNIQUEIDENTIFIER CONSTRAINT [DF_Productos_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
	[SKU] [varchar](50) NOT NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	[Version] [int] NULL,
	CONSTRAINT [PK_Productos] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

CREATE TABLE [dbo].[ProductDetailPage] (
    [Id]         UNIQUEIDENTIFIER CONSTRAINT [DF_ProductDetailPage_Id] DEFAULT (newsequentialid()) ROWGUIDCOL NOT NULL,
    [ProductoId] UNIQUEIDENTIFIER NOT NULL,
    [URL]        NVARCHAR (255)   NULL,
    [Date]       NVARCHAR (10)    NULL,
    [RowVersion] ROWVERSION       NOT NULL,
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


GO

/****** Object:  StoredProcedure [dbo].[Add_ProductListPage]    Script Date: 27/04/2019 01:58:12 p.m. ******/
DROP PROCEDURE [dbo].[Add_ProductListPage]
GO

/****** Object:  StoredProcedure [dbo].[Add_ProductListPage]    Script Date: 27/04/2019 01:58:12 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Fernando Valero
-- Create date: 2019
-- Description:	Add ProductListPage
-- =============================================
CREATE PROCEDURE [dbo].[Add_ProductListPage]
	-- Add the parameters for the stored procedure here
	@URL varchar(255),
	@Name varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @count INT = (SELECT count(*) FROM [dbo].[ProductListPage] WHERE [URL] = @URL)
	
	IF(@count=0)
		INSERT INTO [dbo].[ProductListPage](URL,Name) VALUES (@URL,@Name);
	
	SET NOCOUNT OFF;
END




GO

USE [MXBrands]
GO

/****** Object:  StoredProcedure [dbo].[AddPDP]    Script Date: 27/04/2019 01:59:59 p.m. ******/
DROP PROCEDURE [dbo].[AddPDP]
GO

/****** Object:  StoredProcedure [dbo].[AddPDP]    Script Date: 27/04/2019 01:59:59 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
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

	
	DECLARE @exist int = (select count(*) from dbo.ProductDetailPage pdp join dbo.Productos p on p.Id = pdp.ProductoId where p.SKU = @SKU and [Date] = @Date)
	
	IF(@exist<=0) 
		INSERT INTO [dbo].[ProductDetailPage](ProductoId,URL,[Date]) 
		VALUES (
			(SELECT top 1 [Id] FROM [dbo].[Productos] WHERE SKU = @SKU),
			@URL,
			@Date
		)
	
	select pdp.Id from dbo.ProductDetailPage pdp join dbo.Productos p on p.Id = pdp.ProductoId where p.SKU = @SKU and [Date] = @Date

	SET NOCOUNT OFF;
END


GO

