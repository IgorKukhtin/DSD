-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_AddressLoad (Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_AddressLoad(
    IN inId                  Integer   ,    -- ключ объекта <Контрагент> 
    IN inPartnerName         TVarChar  ,    -- Наименование Контрагента
    IN inOKPO                TVarChar  ,    -- ОКПО
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
    
    IN inMemberTake          TVarChar  ,    -- Физ лицо (сотрудник экспедитор)
    IN inPersonal            TVarChar  ,    -- Сотрудник (супервайзер)
    IN inPersonalTrade       TVarChar  ,    -- Сотрудник (торговый)
    IN inArea                TVarChar  ,    -- Регион
    IN inPartnerTag          TVarChar  ,    -- Признак торговой точки 


    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS RECORD AS
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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

 
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
                                           AND ContactPerson_Object.Id = inId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inOrderName
                           );
      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '', inId, 0, 0, vbContactPersonKindId, inSession);
          
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
                                           AND ContactPerson_Object.Id = inId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inDocName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inDocName, inDocPhone, inDocMail, '', inId, 0, 0, vbContactPersonKindId, inSession);
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
                                           AND ContactPerson_Object.Id = inId
            
                                JOIN ObjectLink AS ObjectLink_ContactPerson_ContactPersonKind
                                                ON ObjectLink_ContactPerson_ContactPersonKind.ObjectId = Object_ContactPerson.Id
                                               AND ObjectLink_ContactPerson_ContactPersonKind.DescId = zc_ObjectLink_ContactPerson_ContactPersonKind()
                                               AND ObjectLink_ContactPerson_ContactPersonKind.ChildObjectId = vbContactPersonKindId
                           WHERE Object_ContactPerson.DescId = zc_Object_ContactPerson()
                             AND Object_ContactPerson.ValueData = inActName
                           );

      IF COALESCE (vbContactPersonId, 0) = 0
      THEN
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inActName, inActPhone, inActMail, '', inId, 0, 0, vbContactPersonKindId, inSession);
      END IF;

   END IF;


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


