-- Function: gpUpdate_Object_Partner_Address()


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);


DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar, TVarChar
                                                       , Integer, TVarChar, TVarChar,  TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar, TVarChar
                                                       , TVarChar, TVarChar, TVarChar, TVarChar
                                                       , Integer, Integer, Integer, Integer, Integer
                                                       , TVarChar);




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
    
    IN inMemberTakeId        Integer   ,    -- Физ лицо(сотрудник экспедитор) 
    IN inMemberId            Integer   ,    -- Физ лицо (ответственное лицо)
    IN inMemberTradeId       Integer   ,    -- Физ лицо(торговый)
    IN inAreaId              Integer   ,    -- Регион
    IN inPartnerTagId        Integer   ,    -- Признак торговой точки 


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
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Partner_Address());

   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

 
   -- сохранили
   ioId := lpUpdate_Object_Partner_Address( ioId                := ioId
                                          , inCode              := vbCode 
                                          , inName              := inName   
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
                                          , inShortName         := inShortName
                                          , inSession           := inSession);


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
          vbContactPersonId := gpInsertUpdate_Object_ContactPerson (vbContactPersonId, 0, inOrderName, inOrderPhone, inOrderMail, '+', ioId, 0, 0, vbContactPersonKindId, inSession);
          
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


   -- сохранили связь с <Сотрудник (экспедитор)>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTake(), ioId, inMemberTakeId);
   -- сохранили связь с <Сотрудник ()>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Member(), ioId, inMemberId);
   -- сохранили связь с <Сотрудник ()>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_MemberTrade(), ioId, inMemberTradeId);
   -- сохранили связь с <Регион>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Area(), ioId, inAreaId);
   -- сохранили связь с <Признак торговой точки>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_PartnerTag(), ioId, inPartnerTagId);


    -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_Partner_Address (Integer, Integer,  TVarChar, TVarChar,  TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.11.14         *
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()


