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

   IF COALESCE(inId, 0 = 0) THEN
      RAISE EXCEPTION 'Ошибка. Контрагент "%" не найден в справочнике контрагентов.', inPartnerName;
   END IF;

   SELECT ID INTO vbPersonalId 
             FROM OBJECT WHERE DescId = zc_Object_Personal() AND ValueData = inPersonal;
   IF COALESCE(vbPersonalId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Супервайзер "%" не найден в справочнике сотрудников.', inPersonal;
   END IF;

   SELECT ID INTO vbPersonalTradeId 
             FROM OBJECT WHERE DescId = zc_Object_Personal() AND ValueData = inPersonalTrade;
   IF COALESCE(vbPersonalTradeId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Торговый представитель "%" не найден в справочнике сотрудников.', inPersonalTrade;
   END IF;

   SELECT ID INTO vbAreaId 
             FROM OBJECT WHERE DescId = zc_Object_Area() AND ValueData = inArea;
   IF COALESCE(vbAreaId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Регион "%" не найден в справочнике регионов.', inArea;
   END IF;

   SELECT ID INTO vbPartnerTagId 
             FROM OBJECT WHERE DescId = zc_Object_PartnerTag() AND ValueData = inPartnerTag;
   IF COALESCE(vbPartnerTagId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Признак торговой точки "%" не найден в справочнике признаков торговой точки.', inPartnerTag;
   END IF;

   SELECT ID INTO vbCityKindId 
             FROM OBJECT WHERE DescId = zc_Object_CityKind() AND ValueData = inCityKindName;
   IF COALESCE(vbCityKindId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Вид населенного пункта "%" не найден в справочнике видов населенных пунктов.', inCityKindName;
   END IF;

   SELECT ID INTO vbStreetKindId 
             FROM OBJECT WHERE DescId = zc_Object_StreetKind() AND ValueData = inStreetKindName;
   IF COALESCE(vbStreetKindId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка. Вид улицы "%" не найден в справочнике видов улиц.', inStreetKindName;
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
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           );

   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalTradeId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, inAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, inPartnerTagId);

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


