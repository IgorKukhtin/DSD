-- update Object set valuedata = 'http://farmacy-dev2.neboley.dp.ua' where Id = zc_Enum_GlobalConst_ConnectParam()
-- update Object set valuedata = '' where Id = zc_Enum_GlobalConst_ConnectReportParam()

-- 
-- Goods + GoodsGroup
-- 
-- 1.1. �������� Goods -- select count(*) from Object where DescId = zc_Object_Goods();
update Object set ValueData = '�������� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Goods() /*limit 100*/) AS tmp
where Object.Id = tmp.Id;

-- 1.2. �������� GoodsGroup
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_GoodsGroup()) AS tmp
where Object.Id = tmp.Id;


-- 
-- Unit + Retail + Area + ProvinceCity
-- 
-- 1.3.1. �������� Unit - Group
update Object set ValueData = '������ ����� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND (Id IN (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
          OR Id IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
            )
     ) AS tmp
where Object.Id = tmp.Id;

-- 1.3.2. �������� Unit - Unit
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND Id NOT IN (SELECT COALESCE (ChildObjectId, 0) FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
        AND Id NOT IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.3. �������� zc_ObjectString_Unit_Address
update ObjectString set ValueData = '����� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Unit()
        AND Id NOT IN (SELECT COALESCE (ChildObjectId, 0) FROM ObjectLink WHERE DescId = zc_ObjectLink_Unit_Parent())
        AND Id NOT IN (SELECT ObjectId FROM ObjectLink WHERE ChildObjectId IS NULL AND DescId = zc_ObjectLink_Unit_Parent())
 ) AS tmp
where ObjectString.ValueData <> ''
  AND ObjectString.ObjectId = tmp.Id
  AND ObjectString.DescId = zc_ObjectString_Unit_Address();
-- 1.3.3. �������� zc_ObjectString_Unit_Phone
update ObjectString set ValueData = ''  where ObjectString.DescId = zc_ObjectString_Unit_Phone();
-- 1.3.4.1. �������� zc_Object_Area
update Object set ValueData = '������ _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Area()
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.4.2. �������� zc_Object_ProvinceCity
update Object set ValueData = ' ����� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_ProvinceCity()
 ) AS tmp
where Object.Id = tmp.Id;
-- 1.3.5. �������� zc_Object_Retail
update Object set ValueData = ' �������� ���� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Retail()
 ) AS tmp
where Object.Id = tmp.Id;


  
-- 
-- Juridical
-- 
-- 1.4.1. �������� Juridical - main
update Object set ValueData = '���� �� ���� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.4.2. �������� Juridical - NO main
update Object set ValueData = '�� ���� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Juridical()
        AND Id NOT IN (SELECT ObjectId FROM ObjectBoolean WHERE DescId = zc_ObjectBoolean_Juridical_isCorporate() AND ValueData = TRUE)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.4.3. �������� Contract
update Object set ValueData = addstr || '������� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select Object.*, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
              , case when Object.ValueData ilike '%��������%' then '�������� '
                     when Object.ValueData ilike '%����%' then '���� '
                     else ''
                end as addstr
              , Object_Jur.ValueData AS JurName
      from Object
           inner join ObjectLink on ObjectLink.ObjectId = Object.Id and ObjectLink.DescId = zc_ObjectLink_Contract_Juridical()
           join Object As Object_Jur on Object_Jur.Id = ObjectLink.ChildObjectId
      where DescId = zc_Object_Contract()
     ) AS tmp
where Object.Id = tmp.Id;


-- 
-- Member + Personal + User
-- 
-- 1.5.1. �������� Member
update Object set ValueData = '��� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_Member()
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.5.2. �������� Personal
update Object set ValueData = Object_Member.ValueData
from ObjectLink 
     LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink.ChildObjectId
where Object.Id = ObjectLink.ObjectId
  AND ObjectLink.DescId = zc_ObjectLinkPersonal_Member();
-- 1.5.3. �������� User
update Object set ValueData = '������������ ��� _ ' || ((cast (tmp.Ord as Integer)) :: TVarChar)
from (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord
      from Object
      where DescId = zc_Object_User()
      and ObjectCode not in (0, -10)
     ) AS tmp
where Object.Id = tmp.Id;
-- 1.5.4. �������� zc_ObjectString_User_
update ObjectString set ValueData = ''  where ObjectString.DescId = zc_ObjectString_Unit_Phone();
