use MXBrands


SELECT a.SKU,a.[Attribute],b.[Attribute]
FROM
	(select p.SKU,
		CASE 
			WHEN plpd.ProductListPageId is not null THEN 'Broswable'
		END AS 'Attribute'
	from Productos p 
	left join ProductListPageDetail plpd on plpd.ProductId = p.Id
	where p.SKU in (select ModelNumber from SKU)
	) 
a 
JOIN (
	select p.SKU,
	CASE 
			WHEN pdpd.Id is not null THEN 'Searchable'
		END AS 'Attribute'
	from Productos p 
	left join ProductDetailPage pdpd on pdpd.ProductoId = p.Id
	where p.SKU in (select ModelNumber from SKU)
	) b 
on (a.SKU = b.SKU)

