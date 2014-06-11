DO $$
   DECLARE vbAdmin integer;
BEGIN

delete from partner where kodbranch ='' and namebranch = ''  and juridicalname = '';
UPDATE partner SET PartnerId = null;


  vbAdmin :=  (SELECT 
         Object_User.Id
   FROM Object AS Object_User
   WHERE (Object_User.ValueData = 'Админ') AND (Object_User.DescId = zc_Object_User()));


PERFORM gpInsertUpdate_Object_StreetKind(0, 0, streettype, vbAdmin::TVarChar) 
  FROM   (
SELECT streettype
  FROM partner
GROUP BY streettype) AS streettype 
WHERE (streettype.streettype <> '') AND (NOT (streettype.streettype IN ( SELECT Name FROM gpSelect_Object_StreetKind('')))) ;

PERFORM gpInsertUpdate_Object_CityKind(0, 0, citytype, vbAdmin::TVarChar) 
  FROM   (
SELECT citytype
  FROM partner
GROUP BY citytype) AS citytype 
WHERE (citytype.citytype <> '') AND  (NOT (citytype.citytype IN ( SELECT Name FROM gpSelect_Object_CityKind(''))));

PERFORM gpInsertUpdate_Object_Region(0, 0, region, vbAdmin::TVarChar) 
  FROM   (
SELECT upper(trim(region)) as region
  FROM partner
GROUP BY  upper(trim(region)) ) AS region 
WHERE (upper(trim(region)) <> '') AND (NOT (region.region IN ( SELECT Name FROM gpSelect_Object_Region('')))) ;


PERFORM gpInsertUpdate_Object_City(0, 0, cityname, CityKind.Id, Region.Id, 0, vbAdmin::TVarChar)
 FROM 

(SELECT citytype, cityname, upper(trim(region)) AS Region


  FROM partner
 
WHERE cityname <> ''  
  
GROUP BY citytype, cityname, upper(trim(region))) AS partner

  
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Partner.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_Region('') AS Region ON Partner.Region = Region.Name
WHERE (cityname <> '') AND (NOT (cityname, CityKind.Id , Region.Id)  IN (
SELECT Name, CityKindId, RegionId FROM gpSelect_Object_City('') ORDER BY Name));

PERFORM gpInsertUpdate_Object_Street(0, 0, streetname, '', StreetKind.Id, City.Id, 0, vbAdmin::TVarChar) 
FROM (SELECT trim(citytype) AS citytype
     , trim(cityname) AS cityname
     , trim(regiontype) AS regiontype
     , upper(trim(region)) AS region
     , trim(streettype) AS streettype
     , trim(streetname) AS streetname
  FROM partner WHERE streetname <> ''
group BY trim(citytype)
       , trim(cityname)
       , trim(regiontype)
       , upper(trim(region))
       , trim(streettype)
       , trim(streetname)
ORDER BY streetname) AS Street

  LEFT JOIN gpSelect_Object_Region('') AS Region ON Street.Region = Region.Name
  LEFT JOIN gpSelect_Object_CityKind('') AS CityKind ON Street.citytype = CityKind.Name
  LEFT JOIN gpSelect_Object_City('') AS City ON Street.cityname = City.Name AND City.CityKindId = CityKind.Id
  LEFT JOIN gpSelect_Object_StreetKind('') AS StreetKind ON Street.StreetType = StreetKind.Name
  
WHERE (streetname <> '') AND (NOT (streetname, StreetKind.Id, City.Id)  IN (
SELECT Name, StreetKindId, CityId FROM gpSelect_Object_Street('') ORDER BY Name));

UPDATE partner SET PartnerId = Object_Partner.Id

       FROM Object AS Object_Partner1CLink
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
                                 ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()

            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Branch
                                 ON ObjectLink_Partner1CLink_Branch.ObjectId = Object_Partner1CLink.Id
                                AND ObjectLink_Partner1CLink_Branch.DescId = zc_ObjectLink_Partner1CLink_Branch()
             WHERE Object_Partner1CLink.DescId = zc_Object_Partner1CLink()  AND partner.codett1c <> ''
       AND partner.codett1c::integer = Object_Partner1CLink.ObjectCode
                             AND zfGetBranchFromBranchCode(kodbranch::integer) = ObjectLink_Partner1CLink_Branch.ChildObjectId;


PERFORM ObjectPartner.Name, ObjectRegion.name, ObjectCity.*, ObjectStreet.*, partner.*,  

gpInsertUpdate_Object_Partner(
 ObjectPartner.Id,    -- ключ объекта <Контрагент> 
    ObjectPartner.Code                ,    -- код объекта <Контрагент> 
    ObjectPartner.ShortName           ,    -- краткое наименование
    ObjectPartner.GLNCode             ,    -- Код GLN
    partner.House         ,    -- Номер дома
    ''::TVarChar          ,    -- Номер корпуса
    ''::TVarChar          ,    -- Номер квартиры
    ObjectStreet.Id            ,    -- Улица/проспект  
    ObjectPartner.PrepareDayCount     ,    -- За сколько дней принимается заказ
    ObjectPartner.DocumentDayCount    ,    -- Через сколько дней оформляется документально
    ObjectPartner.JuridicalId         ,    -- Юридическое лицо
    ObjectPartner.RouteId             ,    -- Маршрут
    ObjectPartner.RouteSortingId      ,    -- Сортировка маршрутов
    ObjectPartner.PersonalTakeId      ,    -- Сотрудник (экспедитор) 
    
    ObjectPartner.PriceListId         ,    -- Прайс-лист
    ObjectPartner.PriceListPromoId    ,    -- Прайс-лист(Акционный)
    ObjectPartner.StartPromo          ,    -- Дата начала акции
    ObjectPartner.EndPromo            ,    -- Дата окончания акции     
    
    vbAdmin::TVarChar
)


FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
HAVING COUNT(*) = 1

UNION
SELECT Count(*), ObjectPartner.Id
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) > 1

) AS dd 
JOIN partner ON dd.Id = partner.partnerId
JOIN gpSelect_Object_Partner(0, '') AS ObjectPartner ON ObjectPartner.id = partner.partnerId
JOIN gpSelect_Object_Region('') AS ObjectRegion ON ObjectRegion.name = upper(Partner.Region)
JOIN gpSelect_Object_City('') AS ObjectCity ON ObjectCity.Name = Partner.cityname AND ObjectCity.RegionId = ObjectRegion.Id 
JOIN gpSelect_Object_Street('') AS ObjectStreet ON ObjectStreet.Name = Partner.StreetName AND ObjectStreet.CityName = partner.CityName
                                AND ObjectStreet.StreetKindName = Partner.StreetType
;


-- Нужно добавить данные таким образом, что бы взять существующие данные из нашего Партнера
-- Остальные же из текущих значений загруженных

UPDATE partner SET partnerId = dd.PartnerId

FROM  

(select right(left(PartnerId::TEXT,7),6)::integer as PartnerId, codett1C from (SELECT gpInsertUpdate_Object_Partner(
 0,    -- ключ объекта <Контрагент> 
    0                ,    -- код объекта <Контрагент> 
    ObjectPartner.ShortName           ,    -- краткое наименование
    ObjectPartner.GLNCode             ,    -- Код GLN
    partner.House         ,    -- Номер дома
    ''::TVarChar          ,    -- Номер корпуса
    ''::TVarChar          ,    -- Номер квартиры
    ObjectStreet.Id            ,    -- Улица/проспект  
    ObjectPartner.PrepareDayCount     ,    -- За сколько дней принимается заказ
    ObjectPartner.DocumentDayCount    ,    -- Через сколько дней оформляется документально
    ObjectPartner.JuridicalId         ,    -- Юридическое лицо
    ObjectPartner.RouteId             ,    -- Маршрут
    ObjectPartner.RouteSortingId      ,    -- Сортировка маршрутов
    ObjectPartner.PersonalTakeId      ,    -- Сотрудник (экспедитор) 
    
    ObjectPartner.PriceListId         ,    -- Прайс-лист
    ObjectPartner.PriceListPromoId    ,    -- Прайс-лист(Акционный)
    ObjectPartner.StartPromo          ,    -- Дата начала акции
    ObjectPartner.EndPromo            ,    -- Дата окончания акции     
    
    vbAdmin::TVarChar
) AS PartnerId, partner.codett1C, 
  -- Так же убрать связи с 1С у текущего
     lpUpdate_Object_Partner1CLink_Null(partner.codett1C::integer, ObjectPartner.Id, zfGetBranchFromBranchCode(kodbranch::integer))
 FROM 
(SELECT Count(*), ObjectPartner.Id, partner.codett1C,  partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName--, partner.StreetKindType, partner.*
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.codett1C,  partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) = 1
) dd 
JOIN partner ON dd.codett1C = partner.codett1C
JOIN gpSelect_Object_Partner(0, '') AS ObjectPartner ON ObjectPartner.id = partner.partnerId
JOIN gpSelect_Object_Region('') AS ObjectRegion ON ObjectRegion.name = upper(Partner.Region)
JOIN gpSelect_Object_City('') AS ObjectCity ON ObjectCity.Name = Partner.cityname AND ObjectCity.RegionId = ObjectRegion.Id 
JOIN gpSelect_Object_Street('') AS ObjectStreet ON ObjectStreet.Name = Partner.StreetName AND ObjectStreet.CityName = partner.CityName
                                AND ObjectStreet.StreetKindName = Partner.StreetType

ORDER BY 2) AS dd) AS dd  

WHERE partner.codett1C = dd.codett1C; 

-- и установить связи у добавленных
SELECT  gpInsertUpdate_Object_Partner1CLink(
    Partner1CLink.Id,    -- ключ объекта
    Partner.codett1c::INTEGER,    -- Код объекта
    Partner.ttin1C,   -- Название объекта
    Partner.PartnerId              ,    -- 
    zfGetBranchFromBranchCode(kodbranch::integer),    -- 
    0,    -- 
    0,    -- 
    false,    -- 
    vbAdmin::TVarChar       -- сессия пользователя
)
FROM Partner
LEFT JOIN gpSelect_Object_Partner1CLink('') AS Partner1CLink ON Partner1CLink.PartnerId = Partner.PartnerId
     AND Partner1CLink.Code = Partner.codett1c::INTEGER
     AND Partner1CLink.BranchId = zfGetBranchFromBranchCode(kodbranch::integer);



/*



ВОТ ЭТИ ДОБАВЛЯЕМ!!!

SELECT Count(*), ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName--, partner.StreetKindType, partner.*
 from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId

WHERE ObjectPartner.Id in

(SELECT Id FROM 
(SELECT COUNT(*) AS PointCount, ObjectPartner.Id from partner 
JOIN OBJECT AS ObjectPartner ON ObjectPartner.Id = partner.partnerId
GROUP BY ObjectPartner.Id
ORDER BY 2) AS dd 
WHERE PointCount > 1)
GROUP BY ObjectPartner.Id, partner.CityName, partner.Region, partner.StreetType, House, 
       partner.StreetName
HAVING COUNT(*) = 1

  */


END $$;


--SELECT  codett1c, ttin1c, Object_Partner.Id, Object_Partner.valuedata
--  FROM partner
--            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = partner.PartnerId;/