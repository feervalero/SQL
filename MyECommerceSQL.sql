USE [ECommerce]
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Inventory') DROP TABLE [Inventory];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Location') DROP TABLE [Location];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Warehouse') DROP TABLE [Warehouse];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductStatus') DROP TABLE [ProductStatus];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RelatedProducts') DROP TABLE [RelatedProducts];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Image') DROP TABLE [Image];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ImageType') DROP TABLE [ImageType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Product') DROP TABLE [Product];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Brand') DROP TABLE [Brand];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Category') DROP TABLE [Category];

CREATE TABLE [dbo].[Category](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Category]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[Level] [varchar](255) NULL,
	[ParentCategoryId] [uniqueidentifier] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),
	CONSTRAINT [FK_Category_Category] FOREIGN KEY([ParentCategoryId]) REFERENCES [dbo].[Category] ([Id])
)
GO

CREATE TABLE [dbo].[Brand](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Brand]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Brand] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Product](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Product]  DEFAULT (newsequentialid()),
	[CategoryId] [UNIQUEIDENTIFIER] NOT NULL,
	[BrandId] [UNIQUEIDENTIFIER] NOT NULL,
	[Title] [varchar](255) NULL,
	[SKU] [varchar](255) NULL,
	[Color] [varchar](255) NULL,
	[Description] [varchar](500) NULL,
	[LongDescription] [varchar](500) NULL,
	[FacebookURL] [varchar](255) NULL,
	[YouTubeID] [varchar](255) NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),
	CONSTRAINT [FK_Product_Category] FOREIGN KEY([CategoryId]) REFERENCES [dbo].[Category] ([Id]),
	CONSTRAINT [FK_Product_Brand] FOREIGN KEY([BrandId]) REFERENCES [dbo].[Brand] ([Id])
)
GO

CREATE TABLE [dbo].[ImageType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ImageType]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ImageType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Image](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Image]  DEFAULT (newsequentialid()),
	[Name][varchar](255) NOT NULL,
	[ImageTypeId] [UNIQUEIDENTIFIER] NULL,
	[ProductId] [UNIQUEIDENTIFIER] NULL,
	[URL] [varchar] NULL,
	[Base64] [varchar] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Image] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),
	CONSTRAINT [FK_Image_ImageType] FOREIGN KEY([ImageTypeId]) REFERENCES [dbo].[ImageType] ([Id]),
	CONSTRAINT [FK_Image_Product] FOREIGN KEY([ProductId]) REFERENCES [dbo].[Product] ([Id])
)
GO

CREATE TABLE [dbo].[RelatedProducts](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [RelatedProducts]  DEFAULT (newsequentialid()),
	[ParentProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[ChildProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [RelatedProducts] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),
	CONSTRAINT [FK_RelatedProductParent_Product] FOREIGN KEY([ParentProductId]) REFERENCES [dbo].[Product] ([Id]),
	CONSTRAINT [FK_RelatedProductChild_Product] FOREIGN KEY([ChildProductId]) REFERENCES [dbo].[Product] ([Id])
)
GO

CREATE TABLE [dbo].[ProductStatus](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ProductStatus]  DEFAULT (newsequentialid()),
	[Value] [varchar](255) NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ProductStatus] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Warehouse](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Warehouse]  DEFAULT (newsequentialid()),
	[Value] [varchar](255) NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Warehouse] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Location](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [Location]  DEFAULT (newsequentialid()),
	[WarehouseId] [UNIQUEIDENTIFIER] NOT NULL,
	[Value] [varchar](255) NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [Location] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Location_Warehouse] FOREIGN KEY([WarehouseId]) REFERENCES [dbo].[Warehouse] ([Id])
)
GO

CREATE TABLE [dbo].[Inventory](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Inventory]  DEFAULT (newsequentialid()),
	[LocationId] [UNIQUEIDENTIFIER] NOT NULL,
	[ProductStatusId] [UNIQUEIDENTIFIER] NOT NULL,
	[MinimumInventoryLevel] [int] NULL,
	[OnHandInventoryLevel] [int] NULL,
	[AvailableInventoryLevel] [int] NULL,
	[OnReserveInventoryLevel] [int] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Inventory_Location] FOREIGN KEY([LocationId]) REFERENCES [dbo].[Location] ([Id])
	,CONSTRAINT [FK_Inventory_ProductStatus] FOREIGN KEY([ProductStatusId]) REFERENCES [dbo].[ProductStatus] ([Id])
)
GO


IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ClientType') DROP TABLE [ClientType];

CREATE TABLE [dbo].[ClientType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ClientType]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[Active] [int] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ClientType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO
