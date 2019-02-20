-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam()

-- 1.1. «¿Ã≈Õ»À» Goods
update Object set ValueData = 'œÂÔ‡‡Ú _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Goods() /*limit 100*/) AS tmp
where Object.Id = tmp.Id

-- 1.2. «¿Ã≈Õ»À» GoodsGroup
update Object set ValueData = '√ÛÔÔ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsGroup()) AS tmp
where Object.Id = tmp.Id

-- 1.3.1. «¿Ã≈Õ»À» Unit - Group
update Object set ValueData = '¿ÔÚÂÍ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsUnit()) AS tmp
where Object.Id = tmp.Id

-- 1.3.2. «¿Ã≈Õ»À» Unit - Unit
update Object set ValueData = '¿ÔÚÂÍ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsUnit()) AS tmp
where Object.Id = tmp.Id


select count(*) from Object where DescId = zc_Object_Goods()

