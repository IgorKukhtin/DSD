-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPartnerName         TVarChar  ,    -- Наименование Контрагента
    IN inOKPO                TVarChar  ,    -- ОКПО
    IN inRegionName          TVarChar  ,    -- наименование области
    IN inProvinceName        TVarChar  ,    -- наименование район
    IN inCityName            TVarChar  ,    -- наименование населенный пункт
    IN inCityKindName        TVarChar  ,    -- Вид населенного пункта
    IN inProvinceCityName    TVarChar  ,    -- наименование района населенного пункта
    IN inPostalCode          TVarChar  ,    -- индекс
    IN inStreetName          TVarChar  ,    -- наименование улица
    IN inStreetKindName      TVarChar  ,    -- Вид улицы
    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inShortName           TVarChar  ,    -- Условное обозначение

    IN inOrderName           TVarChar  ,    -- заказы
    IN inOrderPhone          TVarChar  ,    --
    IN inOrderMail           TVarChar  ,    --

    IN inDocName             TVarChar  ,    -- первичка
    IN inDocPhone            TVarChar  ,    --
    IN inDocMail             TVarChar  ,    --

    IN inActName             TVarChar  ,    -- Акты
    IN inActPhone            TVarChar  ,    --
    IN inActMail             TVarChar  ,    --
    
    IN inPersonal            TVarChar  ,    -- Сотрудник (супервайзер)
    IN inPersonalTrade       TVarChar  ,    -- Сотрудник (торговый)
    IN inArea                TVarChar  ,    -- Регион
    IN inPartnerTag          TVarChar  ,    -- Признак торговой точки 

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId                Integer;
   DECLARE vbPersonalId            Integer;
   DECLARE vbPersonalTradeId       Integer;
   DECLARE vbAreaId                Integer;
   DECLARE vbPartnerTagId          Integer; 
   DECLARE vbCityKindId            Integer; 
   DECLARE vbStreetKindId          Integer; 
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

   -- проверка
   IF COALESCE (inId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Ключ>.', inPartnerName;
   END IF;
   -- проверка
   IF COALESCE (TRIM (inStreetName), '') = '' THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не определено значение <Улица>.', inPartnerName;
   END IF;


   -- поиск
   vbPersonalId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND PersonalName = inPersonal);
   -- проверка
   IF COALESCE (vbPersonalId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение Супервайзера <%> в справочнике <Сотрудники>.', inPartnerName, inPersonal;
   END IF;


   -- поиск
   vbPersonalTradeId:= (SELECT MAX (PersonalId) FROM Object_Personal_View WHERE isMain = TRUE AND PersonalName = inPersonalTrade);
   -- проверка
   IF COALESCE (vbPersonalTradeId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение Торговый представитель <%> в справочнике <Сотрудники>.', inPartnerName, inPersonalTrade;
   END IF;


   -- поиск
   vbAreaId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Area() AND ValueData = inArea);
   -- проверка
   IF COALESCE (vbAreaId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Регионы>.', inPartnerName, inArea;
   END IF;


   -- поиск
   vbPartnerTagId:= (SELECT Id FROM Object WHERE DescId = zc_Object_PartnerTag() AND ValueData = inPartnerTag);
   -- проверка
   IF COALESCE (vbPartnerTagId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Признак торговой точки>.', inPartnerName, inPartnerTag;
   END IF;


   -- поиск
   vbCityKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_CityKind() AND ValueData = inCityKindName);
   -- проверка
   IF COALESCE (vbCityKindId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Вид населенного пункта>.', inPartnerName, inCityKindName;
   END IF;


   -- поиск
   vbStreetKindId:= (SELECT Id FROM Object WHERE DescId = zc_Object_StreetKind() AND ValueData = inStreetKindName);
   -- проверка
   IF COALESCE (vbStreetKindId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Для контрагента <%> не найдено значение <%> в справочнике <Вид (улица,проспект)>.', inPartnerName, inStreetKindName;
   END IF;


  -- сохранили
  PERFORM  lpUpdate_Object_Partner_Address( inId                := inId
                                          , inJuridicalId       := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                          , inShortName         := inShortName
                                          , inCode              := (SELECT ObjectCode FROM Object WHERE Id = inId)
                                          , inRegionName        := inRegionName
                                          , inProvinceName      := inProvinceName
                                          , inCityName          := inCityName
                                          , inCityKindId        := vbCityKindId
                                          , inProvinceCityName  := inProvinceCityName  
                                          , inPostalCode        := inPostalCode
                                          , inStreetName        := inStreetName
                                          , inStreetKindId      := vbStreetKindId
                                          , inHouseNumber       := inHouseNumber
                                          , inCaseNumber        := inCaseNumber  
                                          , inRoomNumber        := inRoomNumber
                                          , inIsCheckUnique     := FALSE
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           );

   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, vbPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, vbPersonalTradeId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, vbAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, vbPartnerTagId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.12.14                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()


