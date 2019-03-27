-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam()

-- 1.1. «¿Ã≈Õ»À» Goods -- select count(*) from Object where DescId = zc_Object_Goods();
update Object set ValueData = 'œÂÔ‡‡Ú _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Goods() /*limit 100*/) AS tmp
where Object.Id = tmp.Id;

-- 1.2. «¿Ã≈Õ»À» GoodsGroup
update Object set ValueData = '√ÛÔÔ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsGroup()) AS tmp
where Object.Id = tmp.Id;

-- 1.3.1. «¿Ã≈Õ»À» Unit - Group
update Object set ValueData = '√ÛÔÔ‡ ‡ÔÚÂÍ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND (Id IN (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
          OR Id IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
            )
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.3.2. «¿Ã≈Õ»À» Unit - Unit
update Object set ValueData = '¿ÔÚÂÍ‡ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND Id NOT IN (SELECT COALESCE (ChildObjectId, 0) FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
        AND Id NOT IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
 ) AS tmp
where Object.Id = tmp.Id;


-- 1.4.1. «¿Ã≈Õ»À» Juridical - main
update Object set ValueData = 'Õ‡¯Â ﬁ ÎËˆÓ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.4.2. «¿Ã≈Õ»À» Juridical - NO main
update Object set ValueData = 'ﬁ ÎËˆÓ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id NOT IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;

