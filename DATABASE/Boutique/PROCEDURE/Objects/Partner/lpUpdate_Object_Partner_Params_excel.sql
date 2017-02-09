-- Function: lpUpdate_Object_Partner_Params_excel()

DROP FUNCTION IF EXISTS lpUpdate_Object_Partner_Params_excel (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar,  TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Object_Partner_Params_excel(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inShortName           TVarChar  ,    -- Условное обозначение
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
--   OUT outPartnerName        TVarChar  ,    -- 
--   OUT outAddress            TVarChar  ,    -- 
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
    IN inUserId              Integer        -- Пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

    -- сохранили
    PERFORM lpUpdate_Object_Partner_Params( inId                := inId
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
                                          , inIsCheckUnique     := FALSE
                                          , inUserId            := inUserId
                                           );

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 03.12.14                                        *
*/

-- тест
-- SELECT * FROM lpUpdate_Object_Partner_Params_excel()
