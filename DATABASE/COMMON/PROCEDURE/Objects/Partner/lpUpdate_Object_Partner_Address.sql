-- Function: lpUpdate_Object_Partner_Address()


DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, TVarChar, TVarChar);




CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Address(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inName                TVarChar  ,    -- <Контрагент> 
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
    IN inShortName           TVarChar  ,    -- Примечание

    IN inSession             TVarChar        -- Пользователь
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbAddress TVarChar;

   DECLARE vbRegionId Integer;
   DECLARE vbProvinceId Integer;
   DECLARE vbCityId Integer;
   DECLARE vbStreetId Integer;
   DECLARE vbProvinceCityId Integer;
   
BEGIN

   vbUserId := lpGetUserBySession (inSession);
   
   -- область
   IF inRegionName <> ''
   THEN
      vbRegionId:= (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Region() AND Object.ValueData = inRegionName);

      IF COALESCE (vbRegionId, 0) = 0
      THEN
          vbRegionId := gpInsertUpdate_Object_Region (vbRegionId, 0, inRegionName, inSession);
      END IF;
   END IF;
     
   -- район
   IF inProvinceName <> '' THEN
          -- проверка
      IF inRegionName = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнено поле Область.'; END IF;
      vbProvinceId:= (SELECT Object.Id 
                      FROM Object 
                          JOIN ObjectLink AS ObjectLink_Province_Region ON ObjectLink_Province_Region.ObjectId = Object.Id
                                                                       AND ObjectLink_Province_Region.DescId = zc_ObjectLink_Province_Region()
                                                                       AND ObjectLink_Province_Region.ChildObjectId = vbRegionId -- 267499 --'Днепропетровская'
                      WHERE Object.DescId = zc_Object_Province() AND Object.ValueData = inProvinceName);
      IF COALESCE (vbProvinceId, 0) = 0
      THEN
          --
          vbProvinceId := gpInsertUpdate_Object_Province (vbProvinceId, 0, inProvinceName, vbRegionId, inSession);
      END IF;

   END IF;


   -- город
         -- проверка
          IF inCityName = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнено поле Населенный пункт.'; END IF;
          -- проверка
          IF COALESCE (inCityKindId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка. Не выбран тип улицы.'; END IF;

      vbCityId:= (SELECT Object_City.Id
                  FROM Object AS Object_City
                       JOIN ObjectLink AS ObjectLink_City_CityKind ON ObjectLink_City_CityKind.ObjectId = Object_City.Id
                                                                  AND ObjectLink_City_CityKind.DescId = zc_ObjectLink_City_CityKind()
                                                                  AND ObjectLink_City_CityKind.ChildObjectId = inCityKindId
                       LEFT JOIN ObjectLink AS ObjectLink_City_Region ON ObjectLink_City_Region.ObjectId = Object_City.Id
                                                                AND ObjectLink_City_Region.DescId = zc_ObjectLink_City_Region()
                                                                --AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (vbRegionId, 0)
                       LEFT JOIN ObjectLink AS ObjectLink_City_Province ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                                                  AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
                                                                --AND COALESCE (ObjectLink_City_Province.ChildObjectId, 0) = COALESCE (vbProvinceId, 0)
                  WHERE Object_City.DescId = zc_Object_City() AND Object_City.ValueData = inCityName
                    AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (vbRegionId, 0)
                    AND COALESCE (ObjectLink_City_Province.ChildObjectId, 0) = COALESCE (vbProvinceId, 0)
                  );
      IF COALESCE (vbCityId, 0) = 0
      THEN
          vbCityId := gpInsertUpdate_Object_City (vbCityId, 0, inCityName, inCityKindId, vbRegionId, vbProvinceId, inSession);
      END IF;


   -- район города
      IF inProvinceCityName <> '' THEN
          -- проверка
          IF COALESCE (vbCityId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка. Не заполнено поле Населенный пункт'; END IF;   -- по идее такого не может быть
           vbProvinceCityId:= (SELECT Object_ProvinceCity.Id 
                              FROM Object AS Object_ProvinceCity
                                   INNER JOIN ObjectLink AS ObjectLink_ProvinceCity_City ON ObjectLink_ProvinceCity_City.ObjectId = Object_ProvinceCity.Id
                                                                                        AND ObjectLink_ProvinceCity_City.DescId = zc_ObjectLink_ProvinceCity_City()
                                                                                        AND ObjectLink_ProvinceCity_City.ChildObjectId = vbCityId
                              WHERE Object_ProvinceCity.DescId = zc_Object_ProvinceCity() AND Object_ProvinceCity.ValueData = inProvinceCityName);
          IF COALESCE (vbProvinceCityId, 0) = 0
          THEN
              --
              vbProvinceCityId := gpInsertUpdate_Object_ProvinceCity (vbProvinceCityId, 0, inProvinceCityName, vbCityId, inSession);
          END IF;
      END IF;

   -- улица
      -- проверка
      IF inStreetName = '' THEN RAISE EXCEPTION 'Ошибка. Не заполнено поле Улица.' ; END IF;
      -- проверка
      IF COALESCE (inStreetKindId, 0) = 0 THEN RAISE EXCEPTION 'Ошибка. Не выбран тип улицы.' ; END IF;

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
                                                                  --AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName
                    AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  );
      IF COALESCE (vbStreetId, 0) = 0
      THEN
          --
          vbStreetId := gpInsertUpdate_Object_Street (vbStreetId, 0, inStreetName, inPostalCode, inStreetKindId, vbCityId, vbProvinceCityId, inSession);
      END IF;
      


 
   vbAddress := (SELECT COALESCE(cityname, '')||', '||COALESCE(streetkindname, '')||' '||
                        COALESCE(name, '')||', '
                   FROM Object_Street_View  WHERE Id = vbStreetId);
   vbAddress := vbAddress||inHouseNumber;

   -- определяем параметры, т.к. значения должны быть синхронизированы с объектом <Юридическое лицо>
   --SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inJuridicalId;
   -- !!!в название добавляем <Адрес точки доставки>!!!
   -- outPartnerName:= outPartnerName || ', ' || vbAddress;


   -- проверка уникальности <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName );
   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), inCode);  END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), inCode, inName);
   -- сохранили свойство <краткое наименование>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_ShortName(), ioId, inShortName);
   
   -- сохранили свойство <Адрес точки доставки>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), ioId, vbAddress);
   -- сохранили свойство <дом>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_HouseNumber(), ioId, inHouseNumber);
   -- сохранили свойство <корпус>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_CaseNumber(), ioId, inCaseNumber);
   -- сохранили свойство <квартира>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_RoomNumber(), ioId, inRoomNumber);

   -- сохранили связь с <Улица>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Street(), ioId, vbStreetId);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.14         *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Partner_Address()


