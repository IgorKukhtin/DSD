-- Function: gpInsertUpdate_Object_PLZ (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PLZ (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PLZ(
 INOUT ioId           Integer,       -- Ключ объекта <Физические лица>    
 INOUT ioCode         Integer,       -- Код объекта <Физические лица>     
    IN inName         TVarChar,      -- Название объекта ФИО <Физические лица>
    IN inCity         TVarChar,      -- ИНН
    IN inAreaCode     TVarChar,      -- E-Mail
    IN inComment      TVarChar,      -- Примечание
    IN inCountryId    Integer ,      --
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PLZ());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- Если код не установлен, определяем его как последний+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_PLZ()); 
   
   -- проверка уникальности для свойства <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PLZ(), inName, vbUserId); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PLZ(), ioCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PLZ_Country(), ioId, inCountryId);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_City(), ioId, inCity);
   -- сохранили Примечание  
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_Comment(), ioId, inComment);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_AreaCode(), ioId, inAreaCode);

   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PLZ()
