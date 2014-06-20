-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
 INOUT ioId                  Integer   ,    -- ключ объекта <Контрагент> 
   --OUT outPartnerName        TVarChar  ,    -- ключ объекта <Контрагент> 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inName                TVarChar  ,    -- <Контрагент> 
    --IN inShortName           TVarChar  ,    -- краткое наименование

    IN inHouseNumber         TVarChar  ,    -- Номер дома
    IN inCaseNumber          TVarChar  ,    -- Номер корпуса
    IN inRoomNumber          TVarChar  ,    -- Номер квартиры
    IN inStreetId            Integer   ,    -- Улица/проспект  

    --IN inJuridicalId         Integer   ,    -- Юридическое лицо
    
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbAddress TVarChar;
   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId := inSession;

   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!

   vbAddress := (SELECT COALESCE(cityname, '')||', '||COALESCE(streetkindname, '')||' '||
                        COALESCE(name, '')||', '
                   FROM Object_Street_View  WHERE Id = inStreetId);
   vbAddress := vbAddress||inHouseNumber;

   -- определяем параметры, т.к. значения должны быть синхронизированы с объектом <Юридическое лицо>
   --SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inJuridicalId;
   -- !!!в название добавляем <Адрес точки доставки>!!!
   -- outPartnerName:= outPartnerName || ', ' || vbAddress;


   -- проверка уникальности <Наименование>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName );
   -- проверка уникальности <Код>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), vbCode, inName);
   -- сохранили свойство <краткое наименование>
   --PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_ShortName(), ioId, inShortName);
   
   -- сохранили свойство <Адрес точки доставки>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), ioId, vbAddress);
   -- сохранили свойство <дом>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_HouseNumber(), ioId, inHouseNumber);
   -- сохранили свойство <корпус>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_CaseNumber(), ioId, inCaseNumber);
   -- сохранили свойство <квартира>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_RoomNumber(), ioId, inRoomNumber);

   -- сохранили связь с <Улица>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Street(), ioId, inStreetId);
 
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner_Address (Integer, Integer,  TVarChar, TVarChar,  TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_Partner_Address()
