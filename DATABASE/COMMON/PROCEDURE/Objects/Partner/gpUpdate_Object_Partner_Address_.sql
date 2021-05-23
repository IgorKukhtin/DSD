-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar,  TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar,  TVarChar, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);




CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   --OUT outPartnerName        TVarChar  ,    -- ключ объекта <Контрагент> 
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

    IN inOrderName           TVarChar  ,    -- заказы
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- первичка
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- Акты
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inSession             TVarChar       -- сессия пользователя
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
   DECLARE vbContactPersonId Integer;
   DECLARE vbContactPersonKindId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

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
                                                                AND COALESCE (ObjectLink_City_Region.ChildObjectId, 0) = COALESCE (vbRegionId, 0)
                       LEFT JOIN ObjectLink AS ObjectLink_City_Province ON ObjectLink_City_Province.ObjectId = Object_City.Id
                                                                  AND ObjectLink_City_Province.DescId = zc_ObjectLink_City_Province()
                                                                  AND COALESCE (ObjectLink_City_Province.ChildObjectId, 0) = COALESCE (vbProvinceId, 0)
                  WHERE Object_City.DescId = zc_Object_City() AND Object_City.ValueData = inCityName);
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
                                                                  AND COALESCE (ObjectLink_Street_ProvinceCity.ChildObjectId, 0) = COALESCE (vbProvinceCityId, 0)
                  WHERE Object_Street.DescId = zc_Object_Street() AND Object_Street.ValueData = inStreetName);
      IF COALESCE (vbStreetId, 0) = 0
      THEN
          --
          vbStreetId := gpInsertUpdate_Object_Street (vbStreetId, 0, inStreetName, inPostalCode, inStreetKindId, vbCityId, vbProvinceCityId, inSession);
      END IF;
      


  -- Контактные лица 
  -- Заявки
   IF inOrderName <> '' THEN
      -- проверка
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CreateOrder();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inOrderPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inOrderMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inOrderName
                           );
      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '+', ioId, 0, 0, vbContactPersonKindId, 0, 0, inSession);
          
      END IF;

   END IF;

 -- Первичка
   IF inDocName <> '' THEN
      -- проверка
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_CheckDocument();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inDocPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inDocMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inDocName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inDocName, inDocPhone, inDocMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
      END IF;

   END IF;

 -- Акты сверки
   IF inActName <> '' THEN
      -- проверка
      vbContactPersonId := 0;
      vbContactPersonKindId := zc_Enum_ContactPersonKind_AktSverki();
      
      vbContactPersonId:= (SELECT Object_ContactPerson.Id
                           FROM Object AS Object_ContactPerson
                                JOIN ObjectString AS ObjectString_Phone
                                                  ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                                                 AND ObjectString_Phone.ValueData = inActPhone
                                JOIN ObjectString AS ObjectString_Mail
                                                  ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id 
                                                 AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()
                                                 AND ObjectString_Mail.ValueData = inActMail
                                                            
                                JOIN ObjectLink AS ContactPerson_ContactPerson_Object
                                                ON ContactPerson_ContactPerson_Object.ObjectId = Object_ContactPerson.Id
                                                AND ContactPerson_ContactPerson_Object.DescId = zc_ObjectLink_ContactPerson_Object()
                                JOIN Object AS ContactPerson_Object 
                                            ON ContactPerson_Object.Id = ContactPerson_ContactPerson_Object.ChildObjectId
                                           AND ContactPerson_Object.DescId = zc_Object_Partner()
                                           AND ContactPerson_Object.Id = ioId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inActName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inActName, inActPhone, inActMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
      END IF;

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
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode);  END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), vbCode, inName);
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
--ALTER FUNCTION gpUpdate_Object_Partner_Address (Integer, Integer,  TVarChar, TVarChar,  TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()


