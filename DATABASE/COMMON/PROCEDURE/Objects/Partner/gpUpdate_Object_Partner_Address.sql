-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
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
    
    IN inMemberTakeId        Integer   ,    -- Физ лицо (сотрудник экспедитор)
    IN inPersonalId          Integer   ,    -- Сотрудник (супервайзер)
    IN inPersonalTradeId     Integer   ,    -- Сотрудник (торговый)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки 


    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

 
   -- Контактные лица 
   PERFORM lpUpdate_Object_Partner_ContactPerson (inId        := inId
                                                , inOrderName := inOrderName
                                                , inOrderPhone:= inOrderPhone
                                                , inOrderMail := inOrderMail
                                                , inDocName   := inDocName
                                                , inDocPhone  := inDocPhone
                                                , inDocMail   := inDocMail
                                                , inActName   := inActName
                                                , inActPhone  := inActPhone
                                                , inActMail   := inActMail
                                                , inSession   := inSession
                                                 );

   -- сохранили связь с <Физ лицо (сотрудник экспедитор)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), inId, inMemberTakeId);
   -- сохранили связь с <Сотрудник (супервайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Personal(), inId, inPersonalId);
   -- сохранили связь с <Сотрудник (торговый)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalTrade(), inId, inPersonalTradeId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), inId, inAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), inId, inPartnerTagId);


   -- сохранили
   SELECT tmp.outPartnerName, tmp.outAddress
         INTO outPartnerName, outAddress
      FROM lpUpdate_Object_Partner_Address( inId                := inId
                                          , inJuridicalId       := (SELECT ChildObjectId FROM ObjectLink WHERE ObjectId = inId AND DescId = zc_ObjectLink_Partner_Juridical())
                                          , inShortName         := inShortName
                                          , inCode              := (SELECT ObjectCode FROM Object WHERE Id = inId)
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
                                          , inSession           := inSession
                                          , inUserId            := vbUserId
                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.11.14         *
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()
