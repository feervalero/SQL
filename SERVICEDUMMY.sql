USE [ECommerce]
GO
/* // SOLO SE DEBE EJECUTAR UNA VEZ
	insert into [StatusType]([Value],[Active]) VALUES('30','1')
	insert into [StatusType]([Value],[Active]) VALUES('40','1')
	insert into [StatusType]([Value],[Active]) VALUES('50','1')
	insert into [StatusType]([Value],[Active]) VALUES('60','1')
	insert into [PriceType]([Value],[Active]) VALUES ('TE','1')
	insert into [Price]([MSRP],[Discount],[Taxes],[PriceTypeId],[Active]) VALUES (
		'10000.00',
		'0',
		'16',
		(select top 1 [Id] from [PriceType]),
		'1'
	)
	
	insert into [Module](Name,[Description],Active) VALUES('uncategorized','uncategorized','1')
	INSERT INTO [Warehouse]([Description],[Value]) VALUES ('Big Box','1005')
	INSERT INTO [Location]([Description],[Value]) VALUES ('Dock 123','10')
*/

DECLARE @ModelNumber NVARCHAR(10)='KAD12345'
DECLARE @Name NVARCHAR(10)='Batidora artisan'
DECLARE @SUMA INT = (Select count(*) from [Product] where ModelNumber = @ModelNumber)

	IF NOT EXISTS(Select * from [Product] where ModelNumber = @ModelNumber)
		insert into [Product](PriceId,ProductFeatureId,ModuleId,ModelNumber,Variant,[Description],Active) VALUES (
			(select top 1 [Id] from [Price]),
			null,
			(select top 1 [Id] from [Module] where Name = 'uncategorized'),
			@ModelNumber,
			'KAD',
			@Name,
			'1'
		)
	IF(@SUMA < 1 )
		insert into [Inventory]([ProductId],[StatusTypeId],[QuantityOnReserve],QuantityAvailable,MinimumQuantityAvailable,[WarehouseId],[LocationId],Active) VALUES (
			(select top 1 [Id] from [Product] where ModelNumber = @ModelNumber),
			(select top 1 [Id] from [StatusType] where Value = '30'),
			'0',
			'100',
			'25',
			(select top 1 [Id] from [Warehouse] where Value = '1005'),
			(select top 1 [Id] from [Location] where Value = '10'),
			'1'
		)
	
		select * from [Inventory]
		select * from [Product]
	
	--delete from [Inventory] where Id = '601AA68C-4310-E911-9539-B4D5BDE08F16'

	
	