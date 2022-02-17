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
   DECLARE vbOrderName TVarChar; vbOrderPhone TVarChar; vbOrderMail TVarChar;
   DECLARE vbDocName TVarChar; vbDocPhone TVarChar; vbDocMail TVarChar;
   DECLARE vbActName TVarChar; vbActPhone TVarChar; vbActMail TVarChar;

   DECLARE vbRegionName          TVarChar  ;    -- наименование области
           vbProvinceName        TVarChar  ;    -- наименование район
           vbCityName            TVarChar  ;    -- наименование населенный пункт
           vbCityKindId          Integer   ;    -- Вид населенного пункта
           vbProvinceCityName    TVarChar  ;    -- наименование района населенного пункта
           vbPostalCode          TVarChar  ;    -- индекс
           vbStreetName          TVarChar  ;    -- наименование улица
           vbStreetKindId        Integer   ;    -- Вид улицы
           vbHouseNumber         TVarChar  ;    -- Номер дома
           vbCaseNumber          TVarChar  ;    -- Номер корпуса
           vbRoomNumber          TVarChar  ;    -- Номер квартиры
           vbShortName           TVarChar  ;    -- Условное обозначение
           vbMemberTakeId        Integer   ;    -- Физ лицо (сотрудник экспедитор)
           vbPersonalId          Integer   ;    -- Сотрудник (супервайзер)
           vbPersonalTradeId     Integer   ;    -- Сотрудник (торговый)
           vbPersonalMerchId     Integer   ;    -- Сотрудник (мерчандайзер)
           vbAreaId              Integer   ;    -- Регион
           vbPartnerTagId        Integer   ;   -- Признак торговой точки
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

   -- сохраненные данные
   SELECT tmp.RegionName
      , tmp.ProvinceName
      , tmp.CityName
      , tmp.CityKindId
      , tmp.ProvinceCityName
      , tmp.PostalCode
      , tmp.StreetName
      , tmp.StreetKindId
      , tmp.HouseNumber
      , tmp.CaseNumber
      , tmp.RoomNumber
      , tmp.ShortName
      , tmp.MemberTakeId
      , tmp.PersonalId
      , tmp.PersonalTradeId
      , tmp.PersonalMerchId
      , tmp.AreaId
      , tmp.PartnerTagId
  INTO vbRegionName
      , vbProvinceName
      , vbCityName
      , vbCityKindId
      , vbProvinceCityName
      , vbPostalCode
      , vbStreetName
      , vbStreetKindId
      , vbHouseNumber
      , vbCaseNumber
      , vbRoomNumber
      , vbShortName
      , vbMemberTakeId
      , vbPersonalId
      , vbPersonalTradeId
      , vbPersonalMerchId
      , vbAreaId
      , vbPartnerTagId
   FROM gpGet_Object_Partner(inId          := inId ::Integer        -- Контрагент
                           , inMaskId      := 0    ::Integer        --
                           , inJuridicalId := 0    ::Integer        --
                           , inSession     := inSession
                            ) AS tmp;


       IF (COALESCE (vbRouteId, 0)    <> inRouteId   OR COALESCE (vbRetailId, 0)    <> inRetailId
        OR COALESCE (vbActName, '')   <> inActName   OR COALESCE (vbActPhone, '')   <> inActPhone   OR COALESCE (vbActMail, '')   <> inActMail
        OR COALESCE (vbDocName, '')   <> inDocName   OR COALESCE (vbDocPhone, '')   <> inDocPhone   OR COALESCE (vbDocMail, '')   <> inDocMail
        OR COALESCE (vbOrderName, '') <> inOrderName OR COALESCE (vbOrderPhone, '') <> inOrderPhone OR COALESCE (vbOrderMail, '') <> inOrderMail
          )
         AND inRegionName       = COALESCE (vbRegionName, '')
         AND inProvinceName     = COALESCE (vbProvinceName, '')
         AND inCityName         = COALESCE (vbCityName, '')
         AND inCityKindId       = COALESCE (vbCityKindId, 0)
         AND inProvinceCityName = COALESCE (vbProvinceCityName, '')
         AND inPostalCode       = COALESCE (vbPostalCode, '')
         AND inStreetName       = COALESCE (vbStreetName, '')
         AND inStreetKindId     = COALESCE (vbStreetKindId, 0)
         AND inHouseNumber      = COALESCE (vbHouseNumber, '')
         AND inCaseNumber       = COALESCE (vbCaseNumber, '')
         AND inRoomNumber       = COALESCE (vbRoomNumber, '')
         AND inShortName        = COALESCE (vbShortName, '')
         AND inMemberTakeId     = COALESCE (vbMemberTakeId, 0)
         AND inPersonalId       = COALESCE (vbPersonalId, 0)
         AND inPersonalTradeId  = COALESCE (vbPersonalTradeId, 0)
         AND inPersonalMerchId  = COALESCE (vbPersonalMerchId, 0)
         AND inAreaId           = COALESCE (vbAreaId, 0)
         AND inPartnerTagId     = COALESCE (vbPartnerTagId, 0)
       THEN
           -- проверка прав пользователя на вызов процедуры
           vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Trade());

           IF COALESCE (vbRetailId, 0) <> inRetailId
           THEN
               -- сохранили связь  <юр.лица> с торговой сетью
               PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), vbJuridicalId, inRetailId);

               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbJuridicalId, inUserId);
           END IF;

           IF COALESCE (vbRouteId, 0) <> inRouteId
           THEN
               -- сохранили связь с <>
               PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), inId, inRouteId);
           END IF;

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
           -- вернули значения
           outAddress:= (SELECT ObjectString.ValueData FROM ObjectString WHERE ObjectString.ObjectId = inId AND ObjectString.DescId = zc_ObjectString_Partner_Address());
           outPartnerName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = inId);

       ELSE
           -- проверка прав пользователя на вызов процедуры
           vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

           IF COALESCE (vbRetailId, 0) <> inRetailId
           THEN
               -- сохранили связь  <юр.лица> с торговой сетью
               PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Juridical_Retail(), vbJuridicalId, inRetailId);

               -- сохранили протокол
               PERFORM lpInsert_ObjectProtocol (vbJuridicalId, inUserId);
           END IF;

           IF COALESCE (vbRouteId, 0) <> inRouteId
           THEN
               -- сохранили связь с <>
               PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Route(), inId, inRouteId);
           END IF;

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

       END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.02.22         * разделение по правам
 19.06.17         * add inPersonalMerchId
 12.11.14         *
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()
