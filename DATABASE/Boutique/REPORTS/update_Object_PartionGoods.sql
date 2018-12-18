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

*/