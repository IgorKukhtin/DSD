-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam()

-- 1.1. �������� Goods
update Object set ValueData = '�������� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Goods() /*limit 100*/) AS tmp
where Object.Id = tmp.Id

-- 1.2. �������� GoodsGroup
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsGroup()) AS tmp
where Object.Id = tmp.Id

-- 1.3.1. �������� Unit - Group
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsUnit()) AS tmp
where Object.Id = tmp.Id

-- 1.3.2. �������� Unit - Unit
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsUnit()) AS tmp
where Object.Id = tmp.Id


select count(*) from Object where DescId = zc_Object_Goods()

