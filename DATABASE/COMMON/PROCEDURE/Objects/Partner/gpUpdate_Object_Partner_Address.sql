-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer
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
    IN inPersonalMerchId     Integer   ,    -- Сотрудник (мерчандайзер)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки 

    IN inRouteId             Integer   ,    --
    IN inRetailId            Integer   ,    -- торговая сеть меняем у юр.лица

    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   
   DECLARE vbRouteId Integer;
   DECLARE vbRetailId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbOrderName TVarChar;
   DECLARE vbDocName TVarChar;
   DECLARE vbActName TVarChar;
BEGIN


   CREATE TEMP TABLE tmpContactPerson (Id Integer, Name TVarChar/*, Phone TVarChar, Mail TVarChar*/, ContactPersonKindId Integer) ON COMMIT DROP;
   INSERT INTO tmpContactPerson (Id, Name, ContactPersonKindId)
           SELECT Object_ContactPerson.Id          AS Id
                , Object_ContactPerson.ValueData   AS Name
                --, ObjectString_Phone.ValueData     AS Phone
                --, ObjectString_Mail.ValueData      AS Mail
                , ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId AS ContactPersonKindId
           FROM ObjectLink
                LEFT JOIN Object AS Object_ContactPerson
                                 ON Object_ContactPerson.Id = ObjectLink.ObjectId
                                AND Object_ContactPerson.DescId = zc_Object_ContactPerson()

                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                /*LEFT JOIN ObjectString AS ObjectString_Phone
                                       ON ObjectString_Phone.ObjectId = Object_ContactPerson.Id
                                      AND ObjectString_Phone.DescId = zc_ObjectString_ContactPerson_Phone()
                LEFT JOIN ObjectString AS ObjectString_Mail
                                       ON ObjectString_Mail.ObjectId = Object_ContactPerson.Id
                                      AND ObjectString_Mail.DescId = zc_ObjectString_ContactPerson_Mail()*/
           WHERE ObjectLink.ChildObjectId = inId
             AND ObjectLink.DescId = zc_ObjectLink_ContactPerson_Object()
           ;
  
   vbOrderName := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153272);    --"Формирование заказов"
   vbDocName   := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153273);      --"Проверка документов"
   vbActName   := (SELECT tmpContactPerson.Name FROM tmpContactPerson WHERE tmpContactPerson.ContactPersonKindId = 153274);      --"Акты сверки и выполенных работ"
   vbRouteId        := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.ObjectId = inId AND ObjectLink.DescId = zc_ObjectLink_Partner_Route());

   SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
        , ObjectLink_Juridical_Retail.ChildObjectId  AS RetailId
  INTO vbJuridicalId, vbRetailId
   FROM ObjectLink AS ObjectLink_Partner_Juridical
        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
   WHERE ObjectLink_Partner_Juridical.ObjectId = inId
     AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical();

   
   IF vbRouteId <> inRouteId OR vbRetailId <> inRetailId OR vbActName <> inActName OR vbDocName <> inDocName OR vbOrderName <> inOrderName
   THEN
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Trade());
       
       -- сохранили связь  <юр.лица> с торговую сеть
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), vbJuridicalId, inRetailId);

       -- сохранили связь с <> 
       PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), inId, inRouteId);

   ELSE
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());
   END IF;
 
   --
 
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
   -- сохранили связь с <Сотрудник (мерчандайзер)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PersonalMerch(), inId, inPersonalMerchId);
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
 19.06.17         * add inPersonalMerchId
 12.11.14         *
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()
