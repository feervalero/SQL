USE [MXBrands]
GO
IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AllProducts') DROP TABLE [dbo].[TempProducts]

/****** Object:  Table [dbo].[Products]    Script Date: 21/02/2019 06:11:45 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TempProducts](
	[ID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
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
	[RowVersion] [ROWVERSION] NOT NULL,
	[UpdatedDateTime] [datetime] NULL DEFAULT (GETDATE()),
	[CreatedDateTime] [datetime] NULL DEFAULT (GETDATE()),
	[Version] [int] NULL,
	[StableVersion] [int] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO




GO

IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'AllProducts') DROP TABLE [dbo].[AllProducts];

/****** Object:  Table [dbo].[Products]    Script Date: 21/02/2019 06:11:45 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AllProducts](
	[ID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
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
	[RowVersion] [ROWVERSION] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NULL,
	[Version] [int] NULL,
	[StableVersion] [int] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



IF EXISTS (Select * from INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Product') DROP TABLE [dbo].[AllProducts];

/****** Object:  Table [dbo].[Products]    Script Date: 21/02/2019 06:11:45 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AllProducts](
	[ID] [uniqueidentifier] NOT NULL DEFAULT (newid()),
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
	[RowVersion] [ROWVERSION] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NULL,
	[Version] [int] NULL,
	[StableVersion] [int] NOT NULL
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

