-- Function: lpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Address(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inShortName           TVarChar  ,    -- Условное обозначение
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
   OUT outPartnerName        TVarChar  ,    -- 
   OUT outAddress            TVarChar  ,    -- 
    IN inRegionName          TVarChar  ,    -- наименование области
    IN inProvinceName        TVarChar  ,    -- наименование район
    IN inCityName            TVarChar  ,    -- наименование населенный пункт
    IN inCityKindId          Integer   ,    -- Вид населенного пункта
    IN inProvinceCityName    TVarChar  ,    -- наименование района населенного пункта
    IN inPostalCode          TVarChar  ,    -- индекс
    IN inStreetName          TVarChar  ,    -- наименование улица
    IN inStreetKindId        Integer   ,    -- Вид улицы
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inIsCheckUnique       Boolean   ,    -- 
    IN inSession             TVarChar  ,    -- сессия пользователя
    IN inUserId              Integer        -- Пользователь
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbRegionId Integer;
   DECLARE vbProvinceId Integer;
   DECLARE vbCityId Integer;
   DECLARE vbProvinceCityId Integer;
   DECLARE vbStreetId Integer;
BEGIN

   -- сохранили
   SELECT tmp.outPartnerName, tmp.outAddress
         INTO outPartnerName, outAddress
       FROM lpUpdate_Object_Partner_Params( inId                := inId
                                          , inJuridicalId       := inJuridicalId
                                          , inShortName         := inShortName
                                          , inCode              := inCode
                                          , inRegionName        := inRegionName
                                          , inProvinceName      := inProvinceName
                                          , inCityName          := inCityName
                                          , inCityKindId        := inCityKindId
                                          , inProvinceCityName  := inProvinceCityName  
                                          , inPostalCode        := inPostalCode
                                          , inStreetName        := inStreetName
                                          , inStreetKindId      := inStreetKindId
                                          , inHouseNumber       := inHouseNumber
                                          , inCaseNumber        := inCaseNumber  
                                          , inRoomNumber        := inRoomNumber
                                          , inIsCheckUnique     := inIsCheckUnique
                                          , inUserId            := inUserId
                                           ) AS tmp;


    -- сохранили свойство <Условное обозначение>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_ShortName(), inId, inShortName);

    -- сохранили свойство <дом>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_HouseNumber(), inId, inHouseNumber);
    -- сохранили свойство <корпус>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_CaseNumber(), inId, inCaseNumber);
    -- сохранили свойство <квартира>
    PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_RoomNumber(), inId, inRoomNumber);

    -- в этом случае "обработка" адреса
    IF inCityName <> '' OR inStreetName <> '' OR inHouseNumber <> '' OR inCaseNumber <> ''
       OR COALESCE (inShortName, '') = ''
    THEN

    -- область
    IF inRegionName <> ''
    THEN
         -- поиск
         vbRegionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Region() AND Object.ValueData = inRegionName);
         -- создание
         IF COALESCE (vbRegionId, 0) = 0
         THEN
             vbRegionId:= gpInsertUpdate_Object_Region (vbRegionId, 0, inRegionName, inSession);
         END IF;
    END IF;
     
    -- район
    IF inProvinceName <> ''
    THEN
         -- проверка
         IF COALESCE (vbRegionId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Область>.'; END IF;
         -- поиск
         vbProvinceId:= (SELECT Object.Id 
                         FROM Object 
                             JOIN ObjectLink AS ObjectLink_Province_Region ON ObjectLink_Province_Region.ObjectId = Object.Id
                                                                          AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
                                                                          AND ObjectLink_Province_Region.ChildObjectId = vbRegionId
                         WHERE Object.DescId = zc_Object_Province() AND Object.ValueData = inProvinceName);
         -- создание
         IF COALESCE (vbProvinceId, 0) = 0
         THEN
             vbProvinceId := gpInsertUpdate_Object_Province (vbProvinceId, 0, inProvinceName, vbRegionId, inSession);
         END IF;
    END IF;


    -- город
         -- проверка
          IF COALESCE (inCityName, '') = '' THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Населенный пункт>.'; END IF;
          -- проверка
          IF COALESCE (inCityKindId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Вид населенного пункта>.'; END IF;

      -- поиск
      vbCityId:= (SELECT Object_City.Id
                  FROM Object AS Object_City
                       JOIN ObjectLink AS ObjectLink_City_CityKind ON ObjectLink_City_CityKind.ObjectId = Object_City.Id
                                                                  AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
                                                                  AND ObjectLink_City_CityKind.ChildObjectId = inCityKindId
                       LEFT JOIN ObjectLink AS ObjectLink_City_Region ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                                                     AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
                       LEFT JOIN ObjectLink AS ObjectLink_City_Province ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                                                       AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
                  WHERE Object_City.DescId = zc_Object_City() AND Object_City.ValueData = inCityName
                    AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (vbRegionId, 0)
                    AND COALESCE (ObjectLink_City_Province.ChildObjectId, 0) = COALESCE (vbProvinceId, 0)
                  );
      -- создание
      IF COALESCE (vbCityId, 0) = 0
      THEN
          vbCityId := gpInsertUpdate_Object_City (vbCityId, 0, inCityName, inCityKindId, vbRegionId, vbProvinceId, inSession);
      END IF;


      -- Микрорайон в населенном пункте
      IF inProvinceCityName <> ''
      THEN
          -- проверка
          IF COALESCE (vbCityId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Населенный пункт>.'; END IF;   -- по идее такого не может быть
          -- поиск
          vbProvinceCityId:= (SELECT Object_ProvinceCity.Id 
                              FROM Object AS Object_ProvinceCity
                                   INNER JOIN ObjectLink AS ObjectLink_ProvinceCity_City ON ObjectLink_ProvinceCity_City.ObjectId = Object_ProvinceCity.Id
                                                                                        AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
                                                                                        AND ObjectLink_ProvinceCity_City.ChildObjectId = vbCityId
                              WHERE Object_ProvinceCity.DescId = zc_Object_ProvinceCity() AND Object_ProvinceCity.ValueData = inProvinceCityName);
          -- создание
          IF COALESCE (vbProvinceCityId, 0) = 0
          THEN
              --
              vbProvinceCityId := gpInsertUpdate_Object_ProvinceCity (vbProvinceCityId, 0, inProvinceCityName, vbCityId, inSession);
          END IF;
      END IF;


   -- улица
      -- проверка
      IF COALESCE (inStreetName, '') = '' THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Улица/проспект>.' ; END IF;
      -- проверка
      IF COALESCE (inStreetKindId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Вид(улица,проспект)>.' ; END IF;
      -- проверка
      IF COALESCE (vbCityId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка.Не определено значение <Населенный пункт>.'; END IF;   -- по идее такого не может быть

      -- 1.1. проверка
      IF 1 < (SELECT COUNT (*)
                    FROM Object AS Object_Street
                       JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                                                                      AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                       INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                                                                      AND ObjectLink_Street_City.ChildObjectId  = vbCityId
                       LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                             AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                       INNER JOIN ObjectString AS ObjectString_PostalCode ON ObjectString_PostalCode.ObjectId  = Object_Street.Id
                                                                         AND ObjectString_PostalCode.DescId    = zc_ObjectString_Street_PostalCode()
                                                                         AND ObjectString_PostalCode.ValueData <> ''
                                                                             
                  WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                    AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  )
      THEN
          RAISE EXCEPTION 'Ошибка.1.В справочник <Улица/проспект> значение <%><%> не уникально для города <%>.', lfGet_Object_ValueData (inStreetKindId), inStreetName, lfGet_Object_ValueData (vbCityId);
      END IF;

        
      -- 1.2. нашли
      vbStreetId:= (SELECT Object_Street.Id
                    FROM Object AS Object_Street
                       JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                                                                      AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                       INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                                                                      AND ObjectLink_Street_City.ChildObjectId  = vbCityId
                       LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                             AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                       INNER JOIN ObjectString AS ObjectString_PostalCode ON ObjectString_PostalCode.ObjectId  = Object_Street.Id
                                                                         AND ObjectString_PostalCode.DescId    = zc_ObjectString_Street_PostalCode()
                                                                         AND ObjectString_PostalCode.ValueData <> ''
                  WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                    AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  );

      IF COALESCE (vbStreetId, 0) = 0
      THEN
          -- 2.1. проверка
          IF 1 < (SELECT COUNT (*)
                        FROM Object AS Object_Street
                           JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                          AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                                                                          AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                           INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                          AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                                                                          AND ObjectLink_Street_City.ChildObjectId  = vbCityId
                           LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                                 AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                                                                                 
                      WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                        AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                      )
          THEN
              RAISE EXCEPTION 'Ошибка.2.В справочник <Улица/проспект> значение <%><%> не уникально для города <%>.', lfGet_Object_ValueData (inStreetKindId), inStreetName, lfGet_Object_ValueData (vbCityId);
          END IF;
            
          -- 2.2. нашли
          vbStreetId:= (SELECT Object_Street.Id
                        FROM Object AS Object_Street
                           JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                          AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                                                                          AND ObjectLink_Street_StreetKind.ChildObjectId = inStreetKindId
                           INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                          AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                                                                          AND ObjectLink_Street_City.ChildObjectId  = vbCityId
                           LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                                 AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
                      WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                        AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                      );
      END IF;


      -- создание
      IF COALESCE (vbStreetId, 0) = 0
      THEN
          vbStreetId := gpInsertUpdate_Object_Street (vbStreetId, 0, inStreetName, inPostalCode, inStreetKindId, vbCityId, vbProvinceCityId, inSession);
      END IF;
      
    
    END IF; -- if в этом случае "обработка" адреса


   -- финиш - сохранили связь с <Улица>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Partner_Street(), inId, vbStreetId);

   IF inUserId = zfCalc_UserAdmin() :: Integer AND 1=1
   THEN
       RAISE EXCEPTION 'Ошибка.Admin-test=ok';
   END IF;

 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.11.14                                        * all
 11.11.14         *
*/

/*
-- check !!!
SELECT 
  ObjectLink_Street_StreetKind.ChildObjectId
, ObjectLink_Street_City.ChildObjectId 
, Object_Street.ValueData
, ObjectLink_Street_ProvinceCity.ChildObjectId
                    FROM Object AS Object_Street
                       JOIN ObjectLink AS ObjectLink_Street_StreetKind ON ObjectLink_Street_StreetKind.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_StreetKind.DescId = zc_ObjectLink_Street_StreetKind()
                       INNER JOIN ObjectLink AS ObjectLink_Street_City ON ObjectLink_Street_City.ObjectId = Object_Street.Id
                                                                      AND ObjectLink_Street_City.DescId = zc_ObjectLink_Street_City()
                       LEFT JOIN ObjectLink AS ObjectLink_Street_ProvinceCity ON ObjectLink_Street_ProvinceCity.ObjectId = Object_Street.Id
                                                                             AND ObjectLink_Street_ProvinceCity.DescId = zc_ObjectLink_Street_ProvinceCity()
WHERE Object_Street.DescId = zc_Object_Street() 
GROUP BY ObjectLink_Street_StreetKind.ChildObjectId
       , ObjectLink_Street_City.ChildObjectId 
       , Object_Street.ValueData
       , ObjectLink_Street_ProvinceCity.ChildObjectId
having count (*) > 1
-- select * from gpGet_Object_Street(inId := 414427 ,  inSession := '5');
-- select * from ObjectLink where ChildObjectId = 419843
*/
-- тест
-- SELECT * FROM lpUpdate_Object_Partner_Address()
