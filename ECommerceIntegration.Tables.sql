Use ECommerceIntegration;

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'MaterialPrice') DROP TABLE [MaterialPrice];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'PriceList') DROP TABLE [PriceList];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Inventory') DROP TABLE [Inventory];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Division') DROP TABLE [Division];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Status') DROP TABLE [Status];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StorageLocation') DROP TABLE [StorageLocation];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Plant') DROP TABLE [Plant];
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Material') DROP TABLE [Material];

CREATE TABLE [dbo].[Material](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Material]  DEFAULT (newsequentialid()),
	[SKU] varchar(255) NOT NULL,
	[Description] varchar(255) NOT NULL,
	[ShortDescription] varchar(255) NOT NULL,
	[IsActive] int NOT NULL,
	[IsVisible] int NOT NULL,
	[Title] varchar(255) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Plant](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Plant]  DEFAULT (newsequentialid()),
	[PlantValue] varchar(20) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Plant] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[StorageLocation](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_StorageLocation]  DEFAULT (newsequentialid()),
	[PlantId] [UNIQUEIDENTIFIER] NOT NULL,
	[StorageLocationValue] varchar(50) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_StorageLocation] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_StorageLocation_Plant] FOREIGN KEY ([PlantId]) REFERENCES [dbo].[Plant] ([Id])
)
GO

CREATE TABLE [dbo].[Status](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Status]  DEFAULT (newsequentialid()),
	[StatusValue] int NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Division](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Division]  DEFAULT (newsequentialid()),
	[DivisionName] int NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Division] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
GO

CREATE TABLE [dbo].[Inventory](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Inventory]  DEFAULT (newsequentialid()),
	[MaterialId] [UNIQUEIDENTIFIER] NOT NULL,
	[PlantId] [UNIQUEIDENTIFIER] NOT NULL,
	[StorageLocationId] [UNIQUEIDENTIFIER] NOT NULL,
	[StatusId] [UNIQUEIDENTIFIER] NOT NULL,
	[DivisionId] [UNIQUEIDENTIFIER] NOT NULL,
	[InventoryLevel] int NOT NULL,
	[VolumeRebate] varchar(100) NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LastUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_Inventory] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_Inventory_Material] FOREIGN KEY ([MaterialId]) REFERENCES [dbo].[Material] ([Id])
	,CONSTRAINT [FK_Inventory_Plant] FOREIGN KEY ([PlantId]) REFERENCES [dbo].[Plant] ([Id])
	,CONSTRAINT [FK_Inventory_StorageLocation] FOREIGN KEY ([StorageLocationId]) REFERENCES [dbo].[StorageLocation] ([Id])
	,CONSTRAINT [FK_Inventory_Status] FOREIGN KEY ([StatusId]) REFERENCES [dbo].[Status] ([Id])
	,CONSTRAINT [FK_Inventory_Division] FOREIGN KEY ([DivisionId]) REFERENCES [dbo].[Division] ([Id])
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

CREATE TABLE [dbo].[MaterialPrice](
	[Id] [UNIQUEIDENTIFIER] NOT NULL ROWGUIDCOL CONSTRAINT [DF_MaterialPrice]  DEFAULT (newsequentialid()),
	[MaterialId] [UNIQUEIDENTIFIER] NOT NULL,
	[PriceListId] [UNIQUEIDENTIFIER] NOT NULL,
	[Price] [float] NOT NULL,
	[CreatedDate] [Datetime] NULL,
	[LasteUpdatedDate] [Datetime] NULL,
	[RowVersion] [ROWVERSION] NOT NULL,
	CONSTRAINT [PK_MaterialPrice] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	),CONSTRAINT [FK_MaterialPrice_Material] FOREIGN KEY ([MaterialId]) REFERENCES [dbo].[Material] ([Id])
	,CONSTRAINT [FK_MaterialPrice_PriceList] FOREIGN KEY ([PriceListId]) REFERENCES [dbo].[PriceList] ([Id])
)
GO


INSERT INTO [dbo].[Plant](PlantValue) VALUES ('RM01');
INSERT INTO [dbo].[Plant](PlantValue) VALUES ('RM02');

insert into dbo.Material ([SKU],[Description],[ShortDescription],[IsActive],[IsVisible],[Title]) VALUES ('WHR12345','Lavadora 20 kgs HE','Lavadora 20 kgs HE',1,1,'Lavadora 20 kgs HE');
insert into [dbo].[Status]([StatusValue]) values (20);
insert into [dbo].[Status]([StatusValue]) values (30);
insert into [dbo].[Status]([StatusValue]) values (40);
insert into [dbo].[Status]([StatusValue]) values (50);

insert into dbo.StorageLocation([PlantId],[StorageLocationValue]) values ((select top 1 Id from dbo.Plant),'0001')
insert into dbo.StorageLocation([PlantId],[StorageLocationValue]) values ((select top 1 Id from dbo.Plant),'0001')
insert into dbo.Division([DivisionName]) values ('0360')

insert into dbo.Inventory(MaterialId, PlantId, StorageLocationId, StatusId, DivisionId, InventoryLevel,VolumeRebate) values 
((select top 1 Id from dbo.Material),(select top 1 Id from Plant),(select top 1 Id from StorageLocation),(select top 1 Id from [Status]),
(select top 1 Id from Division),'134','M3')


insert into PriceList([PriceListValue]) VALUES ('TE');
insert into PriceList([PriceListValue]) VALUES ('X1');
insert into PriceList([PriceListValue]) VALUES ('X2');
insert into PriceList([PriceListValue]) VALUES ('X3');
insert into MaterialPrice([MaterialId],[PriceListId],[Price]) VALUES ((select top 1 Id from Material),(select top 1 Id from PriceList),3450.50)