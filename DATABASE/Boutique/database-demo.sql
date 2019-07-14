-- 1.2.
select count(*)
from MovementItemFloat, Object_PartionGoods 
where MovementItemFloat.MovementItemId = Object_PartionGoods.MovementItemId
  AND MovementItemFloat.DescId = zc_MIFloat_OperPrice()
  and ValueData <> OperPrice;

-- 1.3.
select count(*)
from MovementItemFloat, MovementItem inner join Object_PartionGoods ON PartionId = Object_PartionGoods.MovementItemId
where MovementItemFloat.MovementItemId = MovementItem.Id
  AND MovementItemFloat.DescId = zc_MIFloat_OperPrice()
  and ValueData <> OperPrice;

-- 3.2.
select count(*)
from Object, (with tmpBrand AS (select * from Object where DescId = zc_Object_Brand())
      select ObjectLink.ObjectId
           ,   COALESCE (tmpBrand_new.ValueData, '')
     || '-' || COALESCE (O_Period.ValueData, '')
     || '-' || COALESCE ((ObjectFloat_Partner_PeriodYear.ValueData :: Integer) :: TVarChar, '')
             AS ValueData_new
      from ObjectLink
           left join tmpBrand as tmpBrand_new ON tmpBrand_new.Id = ObjectLink.ChildObjectId
           left join ObjectFloat as ObjectFloat_Partner_PeriodYear ON ObjectFloat_Partner_PeriodYear.ObjectId = ObjectLink.ObjectId AND ObjectFloat_Partner_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
           left join ObjectLink as OL_Period ON OL_Period.ObjectId = ObjectLink.ObjectId AND OL_Period.DescId = zc_ObjectLink_Partner_Period()
           left join Object as O_Period ON O_Period.Id = OL_Period.ChildObjectId
      where ObjectLink.DescId = zc_ObjectLink_Partner_Brand()
     ) as tmp
where tmp.ObjectId = Object.Id and ValueData <> ValueData_new;

/*
-- 1.1. заменили цены
update Object_PartionGoods set OperPrice = case when PeriodYear <= 2000 then cast (OperPrice * 1.2345 as numeric (16, 2))
                                                when PeriodYear <= 2010 then cast (OperPrice * ((PeriodYear - 2000)/100.0 + 1.2) as numeric (16, 2))
                                                else cast (OperPrice * ((PeriodYear - 2000)/100.0 + 1.0) as numeric (16, 2))
                                           end;
-- 1.2. заменили цены - в приходе
update MovementItemFloat set ValueData = OperPrice
from Object_PartionGoods
where MovementItemFloat.MovementItemId = Object_PartionGoods.MovementItemId
  AND MovementItemFloat.DescId = zc_MIFloat_OperPrice();
  
-- 1.3. заменили цены - в документах
update MovementItemFloat  set ValueData = OperPrice
from MovementItem inner join Object_PartionGoods ON PartionId = Object_PartionGoods.MovementItemId
where MovementItemFloat.MovementItemId = MovementItem.Id
  AND MovementItemFloat.DescId = zc_MIFloat_OperPrice();
  
  
-- 2.1 заменили Покупателя
update Object set ValueData = 'Покупатель ' || (Ord :: TVarChar)
from (with tmpClient AS (select * from Object where DescId = zc_Object_Client())
      select tmpClient.*, ROW_NUMBER() OVER (ORDER BY tmpClient.Id ASC) AS Ord
      from  tmpClient
     ) as tmp
where tmp.Id = Object.Id;

-- 2.2 убрали инфу у Покупателя
update ObjectString set ValueData = ''
where DescId IN (zc_ObjectString_Client_Address(), zc_ObjectString_Client_PhoneMobile(), zc_ObjectString_Client_Phone(), zc_ObjectString_Client_Mail(), zc_ObjectString_Client_Comment(), zc_ObjectString_Client_DiscountCard());

  
-- 3.1. ЗАМЕНИЛИ МАРКИ
update Object set ValueData = ValueData_new
from (with tmpBrand AS (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_Brand())
         , tmpBrand_max AS (select max (Ord) as Ord_max from tmpBrand)
      select tmpBrand.*
           , coalesce (tmpBrand_new.ValueData, tmpBrand_new2.ValueData) AS ValueData_new
      from tmpBrand
           left join tmpBrand as tmpBrand_new ON tmpBrand_new.Ord + 3 = tmpBrand.Ord
           left join tmpBrand as tmpBrand_new2 ON tmpBrand_new2.Ord = (select Ord_max from tmpBrand_max) - tmpBrand.Ord  + 1
                                              and tmpBrand_new.Ord is null
     ) as tmp
where tmp.Id = Object.Id;

-- 3.2. ЗАМЕНИЛИ МАРКИ
update Object set ValueData = ValueData_new
from (with tmpBrand AS (select * from Object where DescId = zc_Object_Brand())
      select ObjectLink.ObjectId
           ,   COALESCE (tmpBrand_new.ValueData, '')
     || '-' || COALESCE (O_Period.ValueData, '')
     || '-' || COALESCE ((ObjectFloat_Partner_PeriodYear.ValueData :: Integer) :: TVarChar, '')
             AS ValueData_new
      from ObjectLink
           left join tmpBrand as tmpBrand_new ON tmpBrand_new.Id = ObjectLink.ChildObjectId
           left join ObjectFloat as ObjectFloat_Partner_PeriodYear ON ObjectFloat_Partner_PeriodYear.ObjectId = ObjectLink.ObjectId AND ObjectFloat_Partner_PeriodYear.DescId = zc_ObjectFloat_Partner_PeriodYear()
           left join ObjectLink as OL_Period ON OL_Period.ObjectId = ObjectLink.ObjectId AND OL_Period.DescId = zc_ObjectLink_Partner_Period()
           left join Object as O_Period ON O_Period.Id = OL_Period.ChildObjectId
      where ObjectLink.DescId = zc_ObjectLink_Partner_Brand()
     ) as tmp
where tmp.ObjectId = Object.Id;

-- 3.3. ЗАМЕНИЛИ LineFabrica
update Object set ValueData = ValueData_new
from (with tmpLineFabrica AS (select *, ROW_NUMBER() OVER (ORDER BY Id ASC) AS Ord from Object where DescId = zc_Object_LineFabrica())
         , tmpLineFabrica_max AS (select max (Ord) as Ord_max from tmpLineFabrica)
      select tmpLineFabrica.*
           , coalesce (tmpLineFabrica_new.ValueData, tmpLineFabrica_new2.ValueData) AS ValueData_new
      from tmpLineFabrica
           left join tmpLineFabrica as tmpLineFabrica_new ON tmpLineFabrica_new.Ord + 3 = tmpLineFabrica.Ord
           left join tmpLineFabrica as tmpLineFabrica_new2 ON tmpLineFabrica_new2.Ord = (select Ord_max from tmpLineFabrica_max) - tmpLineFabrica.Ord  + 1
                                              and tmpLineFabrica_new.Ord is null
     ) as tmp
where tmp.Id = Object.Id;


-- 4 убрали протокол
truncate table MovementItemProtocol;
truncate table MovementProtocol;
truncate table ObjectProtocol;
truncate table UserProtocol;


select * from Object where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'муж'
update Object set ValueData = 'Man' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'муж'
update Object set ValueData = 'Lady' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'жен'
update Object set ValueData = 'Children' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Детское'
update Object set ValueData = 'Linen' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Белье'
update Object set ValueData = 'Other' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Прочие'
update Object set ValueData = 'Knit' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Трикотаж'
update Object set ValueData = 'Headgear' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Головные уборы'
update Object set ValueData = 'Headgear JR' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Головные уборы JR'
update Object set ValueData = 'Headgear B' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Головные уборы B'
update Object set ValueData = 'Outerwear' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Верхняя'
update Object set ValueData = 'Jersey' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Джерси'
update Object set ValueData = 'Girls' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'дев'
update Object set ValueData = 'new Girls' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'нов дев'
update Object set ValueData = 'Boys' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'мальч'
update Object set ValueData = 'new Boys' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'нов мальч'
update Object set ValueData = 'Beach' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'пляж'
update Object set ValueData = 'jeans' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'джинс'
update Object set ValueData = 'leather' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'кожа'
update Object set ValueData = 'leather' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Кожгалантерея'
update Object set ValueData = 'socks' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Чулочно-носочные'
update Object set ValueData = 'Toys' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Игрушки'
update Object set ValueData = 'Bijouterie' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Бижутерия'
update Object set ValueData = 'Newborn' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Новорожд'
update Object set ValueData = 'New year' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Елочное'
update Object set ValueData = 'Bags' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Сумки'
update Object set ValueData = 'Fur' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'мех'
update Object set ValueData = 'Fuzz' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'пух'
update Object set ValueData = 'mini' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'мини'
update Object set ValueData = 'Shorts' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Шорты'
update Object set ValueData = 'Sport' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'спорт'
update Object set ValueData = 'Perfumes' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'Парфюмы'
update Object set ValueData = 'medium' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'средн'
update Object set ValueData = 'travel' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'дорожная'
update Object set ValueData = 'figurine' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'статуэтка'
update Object set ValueData = 'trousers' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'брюч'
update Object set ValueData = 'long' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'длинн'
update Object set ValueData = 'long/short' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'д/к'
update Object set ValueData = 'low/short' where DescId = zc_Object_GoodsGroup() and Valuedata ilike 'н/к'


update Object set ValueData = 'UnComplete' where Id = zc_Enum_Status_UnComplete()
update Object set ValueData = 'Complete' where Id = zc_Enum_Status_Complete()
update Object set ValueData = 'Erased' where Id = zc_Enum_Status_Erased()

update Object set ValueData = 'not' where Id = zc_Enum_DiscountKind_Not()
update Object set ValueData = 'const' where Id = zc_Enum_DiscountKind_Const()
update Object set ValueData = 'summ' where Id = zc_Enum_DiscountKind_Var()


select lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ObjectLink.ObjectId, vbGroupNameFull)
from 
(select lfGet_Object_TreeNameFull (ChildObjectId , zc_ObjectLink_GoodsGroup_Parent()) as vbGroupNameFull
      , ChildObjectId 
 from
 (select distinct ChildObjectId from ObjectLink where DescId = zc_ObjectLink_Goods_GoodsGroup() ) as a1
) as a2
join ObjectLink on ObjectLink.DescId = zc_ObjectLink_Goods_GoodsGroup() and ObjectLink.ChildObjectId = a2.ChildObjectId 

*/