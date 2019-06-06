select * from Productos
select * from ProductListPage
select * from ProductListPageDetail

select * from ProductDetailPage
select * from Productos
select * from ProductDetail

select p.SKU from ProductDetail pd
join ProductDetailPage pdp on pdp.Id = pd.ProductDetailPageId
join Productos p on p.Id = pdp.ProductoId

select s.ModelNumber from SKU s
left join Productos p on p.SKU = s.ModelNumber
left join ProductDetailPage pdp on pdp.ProductoId = p.Id
left join ProductDetail pd on pd.ProductDetailPageId = pdp.Id
where pdp.Id is null




--Count de Detalles en ProductDetail
select dt.DetailDescription,count(dt.Id) as 'Count of results' from ProductDetail pd 
join DetailType dt on dt.Id = pd.DetailTypeId
group by dt.DetailDescription

--De los productos que me compartieron cuantos estan en PLPs
select count(distinct s.ModelNumber) as 'Productos Compartidos', count(distinct plpd.Id) as 'En PLP'
from SKU s
left join Productos p on p.SKU = s.ModelNumber
left join ProductListPageDetail plpd on plpd.ProductId = p.Id

--Cuales de los productos compartidos no estan en un PLP ? 
select s.ModelNumber
from SKU s
left join Productos p on p.SKU = s.ModelNumber
left join ProductListPageDetail plpd on plpd.ProductId = p.Id
where plpd.Id is null


/*
How many products...
...have hero images in the site?
...have thumbnail images in the site? (How many images by Product)
...have features in the PDP? and how many for each product?

**/

--...are browsable in the site?
select p.SKU
from ProductListPageDetail plpd
join Productos p on plpd.ProductId = p.Id

--...are searchable in the site?
--...are able to see their detail (PDP)? (TO DO: Save product url)
select p.SKU,pdp.URL
from ProductDetailPage pdp
join Productos p on pdp.ProductoId = p.Id


--...have description in the PDP ?
--Cuantos Productos Tienen Title
select count(distinct p.SKU) as 'productos', count(dt.Id) as 'Con title', count(distinct pdp.Id) as 'de analizados' from Productos p
left join ProductDetailPage pdp on pdp.ProductoId = p.Id
left join ProductDetail pd on pdp.Id = pd.ProductDetailPageId
left join DetailType dt on pd.DetailTypeId = dt.Id and DetailDescription = 'Title'

--...have features in the PDP? and how many for each product?
select p.SKU,dt.DetailDescription,pd.Value
from Productos p
left join ProductDetailPage pdp on pdp.ProductoId = p.Id
left join ProductDetail pd on pdp.Id = pd.ProductDetailPageId
join DetailType dt on pd.DetailTypeId = dt.Id and DetailDescription like '%Feature%'




--...have documents attached in the PDP? and how many for each product?
select p.SKU,dt.DetailDescription,pd.Value
from Productos p
left join ProductDetailPage pdp on pdp.ProductoId = p.Id
left join ProductDetail pd on pdp.Id = pd.ProductDetailPageId
join DetailType dt on pd.DetailTypeId = dt.Id and DetailDescription like '%Manual%'




select * from ProductDetail where [Date] = '230419'

exec GetPendingManuals

select * from SKU