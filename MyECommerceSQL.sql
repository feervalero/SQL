USE [ECommerce]
GO
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Neighborhood') DROP TABLE [Neighborhood];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ZIP') DROP TABLE [ZIP];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'City') DROP TABLE [City];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'State') DROP TABLE [State];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Payment') DROP TABLE [Payment];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PaymentType') DROP TABLE [PaymentType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Order') DROP TABLE [Order];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'OrderDetail') DROP TABLE [OrderDetail];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Guest') DROP TABLE [Guest];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PointType') DROP TABLE [PointType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Point') DROP TABLE [Point];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Address') DROP TABLE [Address];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'InvoiceInformation') DROP TABLE [InvoiceInformation];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Client') DROP TABLE [Client];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PriceListToCluster') DROP TABLE [PriceListToCluster];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Cluster') DROP TABLE [Cluster];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Comment') DROP TABLE [Comment];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FeatureToProduct') DROP TABLE [FeatureToProduct];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Banner') DROP TABLE [Banner];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Feature') DROP TABLE [Feature];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'FeatureType') DROP TABLE [FeatureType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PriceList') DROP TABLE [PriceList];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductToBundle') DROP TABLE [ProductToBundle];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Bundle') DROP TABLE [Bundle];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Clasification') DROP TABLE [Clasification];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ClientType') DROP TABLE [ClientType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Inventory') DROP TABLE [Inventory];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Location') DROP TABLE [Location];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Warehouse') DROP TABLE [Warehouse];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductStatus') DROP TABLE [ProductStatus];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RelatedProducts') DROP TABLE [RelatedProducts];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Image') DROP TABLE [Image];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ImageType') DROP TABLE [ImageType];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Brand') DROP TABLE [Brand];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Category') DROP TABLE [Category];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Product') DROP TABLE [Product];



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


CREATE TABLE [dbo].[Clasification](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Clasification]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Clasification] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO


CREATE TABLE [dbo].[Bundle](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Bundle]  DEFAULT (newsequentialid()),
	[ClasificationId] [UNIQUEIDENTIFIER] NOT NULL,
	[ImageId] [UNIQUEIDENTIFIER] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Bundle] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Bundle_Clasification] FOREIGN KEY([ClasificationId]) REFERENCES [dbo].[Clasification] ([Id])
	, CONSTRAINT [FK_Bundle_Image] FOREIGN KEY ([ImageId]) REFERENCES [dbo].[Image] ([Id])
)
GO


CREATE TABLE [dbo].[PriceList](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_PriceList]  DEFAULT (newsequentialid()),
	[PriceListValue] varchar(50) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_PriceList] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO


CREATE TABLE [dbo].[ProductToBundle](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [ProductToBundle]  DEFAULT (newsequentialid()),
	[BundleId] [UNIQUEIDENTIFIER] NOT NULL,
	[ProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[PriceListId] [UNIQUEIDENTIFIER] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[Level] [int] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [ProductToBundle] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_ProducToBundle_Bundle] FOREIGN KEY ([BundleId]) REFERENCES [dbo].[Bundle] ([Id])
	, CONSTRAINT [FK_ProductToBundle_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])
	CONSTRAINT [FK_ProductToBundle_PriceList] FOREIGN KEY ([PriceListId]) REFERENCES [dbo].[PriceList] ([Id])
)
GO


CREATE TABLE [dbo].[FeatureType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_FeatureType]  DEFAULT (newsequentialid()),
	[Value] [varchar](255) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_FeatureType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO


CREATE TABLE [dbo].[Feature](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Feature]  DEFAULT (newsequentialid()),
	[FeatureTypeId] [UNIQUEIDENTIFIER] NOT NULL,
	[Title] [varchar](255) NOT NULL,
	[Description] [varchar](255) NOT NULL,
	[URL] [varchar](255) NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Feature] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Feature_FeatureType] FOREIGN KEY ([FeatureTypeId]) REFERENCES [dbo].[FeatureType] ([Id])
)
GO




CREATE TABLE [dbo].[FeatureToProduct](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_FeatureToProduct]  DEFAULT (newsequentialid()),
	[ProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[FeatureId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_FeatureToProduct] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_FeatureToProduct_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])
	,CONSTRAINT [FK_FeatureToProduct_Feature] FOREIGN KEY ([FeatureId]) REFERENCES [dbo].[Feature] ([Id])
)
GO




CREATE TABLE [dbo].[Banner](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Banner]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[Url] [varchar](255) NOT NULL,
	[ImageId] [varchar] (255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Banner] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)CONSTRAINT [FK_Banner_Image] FOREIGN KEY ([ImageId]) REFERENCES [dbo].[Image] ([Id])
)
GO




CREATE TABLE [dbo].[Cluster](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Cluster]  DEFAULT (newsequentialid()),
	[ClientTypeId] [UNIQUEIDENTIFIER] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[RFC] [varchar](20) NULL,
	[PriceList1Id] [UNIQUEIDENTIFIER] NULL,
	[PriceList2Id] [UNIQUEIDENTIFIER] NULL,
	[PriceList3Id] [UNIQUEIDENTIFIER] NULL,
	[PriceList4Id] [UNIQUEIDENTIFIER] NULL,
	[InvitationId] [varchar](255) NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Cluster] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Cluster_ClientType] FOREIGN KEY ([ClientTypeId]) REFERENCES [dbo].[ClientType] ([Id])
	, CONSTRAINT [FK_Cluster_PriceList1] FOREIGN KEY ([PriceList1Id]) REFERENCES [dbo].[PriceList] ([Id])
	, CONSTRAINT [FK_Cluster_PriceList2] FOREIGN KEY ([PriceList2Id]) REFERENCES [dbo].[PriceList] ([Id])
	, CONSTRAINT [FK_Cluster_PriceList3] FOREIGN KEY ([PriceList3Id]) REFERENCES [dbo].[PriceList] ([Id])
	, CONSTRAINT [FK_Cluster_PriceList4] FOREIGN KEY ([PriceList4Id]) REFERENCES [dbo].[PriceList] ([Id])

)
GO




CREATE TABLE [dbo].[PriceListToCluster](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_PricelistToCluster]  DEFAULT (newsequentialid()),
	[ClusterId] [UNIQUEIDENTIFIER] NOT NULL,
	[PriceListId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_PricelistToCluster] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_PriceListToCluster_Cluster] FOREIGN KEY ([ClusterId]) REFERENCES [dbo].[Cluster] ([Id])
	, CONSTRAINT [FK_PriceListToCluster_PriceList] FOREIGN KEY ([PriceListId]) REFERENCES [dbo].[PriceList] ([Id])
)
GO




CREATE TABLE [dbo].[Client](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Client]  DEFAULT (newsequentialid()),
	[ClientTypeId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[Name] [varchar] (255) NOT NULL,
	[LastName] [varchar] (255) NOT NULL,
	[LastSecondName] [varchar] (255) NOT NULL,
	[Email] [varchar] (255) NOT NULL,
	[EmployeeNumber] [varchar] (255) NOT NULL,
	[Active] [int]  NOT NULL,
	[ClusterId] [varchar] (255) NOT NULL,
	[LasteUpdatedDa
	te] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Client_ClientType] FOREIGN KEY ([ClientTypeId]) REFERENCES [dbo].[ClientType] ([Id]),
	CONSTRAINT [FK_Client_Cluster] FOREIGN KEY ([ClusterId]) REFERENCES [dbo].[Cluster] ([Id])

)
GO





CREATE TABLE [dbo].[Comment](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Comment]  DEFAULT (newsequentialid()),
	[ClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[ClusterId] [UNIQUEIDENTIFIER] NOT NULL,
	[ProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[Comment] [varchar](255) NOT NULL,
	[Rate] [int] NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Comment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Comment_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id])
	,CONSTRAINT [FK_Comment_Cluster] FOREIGN KEY ([ClusterId]) REFERENCES [dbo].[Cluster] ([Id])
	,CONSTRAINT [FK_Comment_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id])

)
GO




CREATE TABLE [dbo].[InvoiceInformation](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_InvoiceInformation]  DEFAULT (newsequentialid()),
	[ClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[PersonalEntity] [int] NOT NULL,
	[Street] [varchar](255) NULL,
	[Number] [varchar](255) NULL,
	[Neighborhood] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[State] [varchar](255) NULL,
	[ZIP] [varchar](255) NULL,
	[Phone] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[RFC] [varchar](255) NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_InvoiceInformation] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_InvoiceInformation_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id])
)
GO

CREATE TABLE [dbo].[Address](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Address]  DEFAULT (newsequentialid()),
	[ClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[Street] [varchar](255) NULL,
	[Number] [varchar](255) NULL,
	[Neighborhood] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[State] [varchar](255) NULL,
	[ZIP] [varchar](255) NULL,
	[Phone] [varchar](255) NULL,
	[References] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Address_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id])
)
GO





CREATE TABLE [dbo].[PointType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_PointType]  DEFAULT (newsequentialid()),
	[Value] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_PointType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO




CREATE TABLE [dbo].[Guest](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Guest]  DEFAULT (newsequentialid()),
	[ParentClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[ChildClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[ExpirationDate] [Datetime] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Guest] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Guest_ParentClient] FOREIGN KEY ([ParentClientId]) REFERENCES [dbo].[Client] ([Id]),
	CONSTRAINT [FK_Guest_ChildClient] FOREIGN KEY ([ChildClientId]) REFERENCES [dbo].[Client] ([Id])
)
GO




CREATE TABLE [dbo].[PaymentType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_PaymentType]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO



CREATE TABLE [dbo].[Payment](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Payment]  DEFAULT (newsequentialid()),
	[PaymentTypeId] [UNIQUEIDENTIFIER] NOT NULL,
	[Amount] [decimal] NOT NULL,
	[Detail] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Payment_PaymentType] FOREIGN KEY ([PaymentTypeId]) REFERENCES [dbo].[PaymentType] ([Id])
)
GO



CREATE TABLE [dbo].[Order](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Order]  DEFAULT (newsequentialid()),
	[ClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[AddressId] [UNIQUEIDENTIFIER] NOT NULL,
	[InvoiceInformationId] [UNIQUEIDENTIFIER] NULL,
	[PaymentId] [UNIQUEIDENTIFIER] NOT NULL,
	[DisplayNumber] [bigint] NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Order_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id]),
	CONSTRAINT [FK_Order_Address] FOREIGN KEY ([AddressId]) REFERENCES [dbo].[Address] ([Id]),
	CONSTRAINT [FK_Order_InvoiceInformation] FOREIGN KEY ([InvoiceInformationId]) REFERENCES [dbo].[InvoiceInformation] ([Id])
	,CONSTRAINT [FK_Order_Payment] FOREIGN KEY ([PaymentId]) REFERENCES [dbo].[Payment] ([Id])
)
GO


CREATE TABLE [dbo].[Point](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Point]  DEFAULT (newsequentialid()),
	[ClientId] [UNIQUEIDENTIFIER] NOT NULL,
	[PointTypeId] [UNIQUEIDENTIFIER] NOT NULL,
	[OrderId] [UNIQUEIDENTIFIER] NOT NULL,
	[Amount] [bigint] NOT NULL,
	[Active] [int] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Point] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_Point_Client] FOREIGN KEY ([ClientId]) REFERENCES [dbo].[Client] ([Id]),
	CONSTRAINT [FK_Point_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id]),
	CONSTRAINT [FK_Point_PointType] FOREIGN KEY ([PointTypeId]) REFERENCES [dbo].[PointType] ([Id])
)
GO




CREATE TABLE [dbo].[OrderDetail](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_OrderDetail]  DEFAULT (newsequentialid()),
	[OrderId] [UNIQUEIDENTIFIER] NOT NULL,
	[ProductId] [UNIQUEIDENTIFIER] NOT NULL,
	[BrandId] [UNIQUEIDENTIFIER] NOT NULL,
	[PriceListId] [UNIQUEIDENTIFIER] NOT NULL,
	[Quantity] [varchar] (255) NOT NULL,
	[Name] [varchar] (255) NOT NULL,
	[UnitCost] [varchar] (255) NOT NULL,
	[Freight] [varchar] (255) NOT NULL,
	[Subtotal] [varchar] (255) NOT NULL,
	[EstimatedDeliveryDate] [varchar] (255) NOT NULL,
	[Warehouse] [varchar] (255) NOT NULL,
	[StorageLocation] [varchar] (255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_OrderDetail_Order] FOREIGN KEY ([OrderId]) REFERENCES [dbo].[Order] ([Id]),
	CONSTRAINT [FK_OrderDetail_Product] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([Id]),
	CONSTRAINT [FK_OrderDetail_Brand] FOREIGN KEY ([BrandId]) REFERENCES [dbo].[Brand] ([Id]),
	CONSTRAINT [FK_OrderDetail_PriceList] FOREIGN KEY ([PriceListId]) REFERENCES [dbo].[PriceList] ([Id])
)
GO



CREATE TABLE [dbo].[State](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_State]  DEFAULT (newsequentialid()),
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO



CREATE TABLE [dbo].[City](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_City]  DEFAULT (newsequentialid()),
	[StateId] [UNIQUEIDENTIFIER] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	), CONSTRAINT [FK_City_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([Id])
)
GO



CREATE TABLE [dbo].[ZIP](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_ZIP]  DEFAULT (newsequentialid()),
	[StateId] [UNIQUEIDENTIFIER] NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_ZIP] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_ZIP_State] FOREIGN KEY ([StateId]) REFERENCES [dbo].[State] ([Id])
)
GO




CREATE TABLE [dbo].[Neighborhood](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Neighborhood]  DEFAULT (newsequentialid()),
	[ZIPId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Neighborhood] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Neighborhood_ZIP] FOREIGN KEY ([ZIPId]) REFERENCES [dbo].[ZIP] ([Id])
)
GO
