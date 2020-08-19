-- Function: lpUpdate_Object_Partner_Params()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Integer);
DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Params(
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
    IN inUserId              Integer        -- Пользователь
)
RETURNS RECORD
AS
$BODY$
BEGIN

    -- Проверка установки значений
    IF COALESCE (inJuridicalId, 0) = 0 
    THEN
      RAISE EXCEPTION 'Ошибка.Не установлено <Юридическое лицо>.';
    END IF;

    -- !!!меняются значения!!!
    inShortName         := TRIM (inShortName);
    inRegionName        := TRIM (inRegionName);
    inProvinceName      := TRIM (inProvinceName);
    inCityName          := TRIM (inCityName);
    inProvinceCityName  := TRIM (inProvinceCityName);
    inPostalCode        := TRIM (inPostalCode);
    inStreetName        := TRIM (inStreetName);
    inHouseNumber       := TRIM (inHouseNumber);
    inCaseNumber        := TRIM (inCaseNumber);
    inRoomNumber        := TRIM (inRoomNumber);

    -- !!!такой адрес!!!
    outAddress := TRIM (COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = inCityKindId AND DescId = zc_ObjectString_CityKind_ShortName()), '')
              || ' ' || COALESCE (inCityName, '')
              || ' ' || COALESCE ((SELECT ValueData FROM ObjectString WHERE ObjectId = inStreetKindId AND DescId = zc_ObjectString_StreetKind_ShortName()), '')
              || ' ' || COALESCE (inStreetName, '')
                     || CASE WHEN COALESCE (inHouseNumber, '') <> ''
                                  THEN ' буд.' || COALESCE (inHouseNumber, '')
                             ELSE ''
                        END
                     || CASE WHEN COALESCE (inCaseNumber, '') <> ''
                                  THEN ' корп.' || COALESCE (inCaseNumber, '')
                             ELSE ''
                        END
                       );


    -- !!!название состоит из: <Юридическое лицо> + <Условное обозначение> + <Адрес точки доставки>!!!
    outPartnerName:= COALESCE ((SELECT ValueData FROM Object WHERE Id = inJuridicalId), '')
                   || CASE WHEN inShortName <> ''
                                THEN ' ' || inShortName
                           ELSE ''
                      END
                   || CASE WHEN TRIM (outAddress) <> ''
                                THEN ' ' || TRIM (outAddress)
                           ELSE ''
                      END;


    IF inIsCheckUnique = TRUE
    THEN
        -- проверка уникальности <Название>
        PERFORM lpCheckUnique_Object_ValueData (inId, zc_Object_Partner(), outPartnerName);
    END IF;


    -- сохранили <Объект>
    PERFORM lpInsertUpdate_Object (inId, zc_Object_Partner(), inCode, outPartnerName);

    -- сохранили свойство <Адрес точки доставки>
    PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Partner_Address(), inId, outAddress);

   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.12.14                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Partner_Params()
