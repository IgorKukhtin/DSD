-- Function: gpInsertUpdate_Object_Storage()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Storage(Integer, Integer, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Storage(
 INOUT ioId             Integer   ,     -- ключ объекта <Места хранения> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inComment        TVarChar  ,     -- Примечание
    IN inAddress        TVarChar  ,     -- Адрес места
    IN inUnitId         Integer   ,     -- Подразделение
    IN inAreaUnitName   TVarChar  ,     -- Участок
    IN inRoom           TVarChar  ,     -- Кабинет
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;                                 
   DECLARE vbCode_calc Integer;
   DECLARE vbAreaUnitId Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Storage());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Storage());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Storage(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Storage(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Storage(), vbCode_calc, inName);

   -- сохранили свойство <адрес>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Address(), ioId, inAddress);
   -- сохранили свойство <Примечание>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Comment(), ioId, inComment);
   -- сохранили свойство <кабинет>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Storage_Room(), ioId, inRoom);
   -- сохранили связь с <Подразделение>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Storage_Unit(), ioId, inUnitId);
   
   vbAreaUnitId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_AreaUnit() AND TRIM (UPPER (Object.ValueData)) = TRIM (UPPER (inAreaUnitName)) );
   IF COALESCE (vbAreaUnitId,0) = 0
   THEN
       --создаем новый участок
       vbAreaUnitId := (SELECT tmp.ioId
                        FROM gpInsertUpdate_Object_AreaUnit (ioId      := 0    :: Integer
                                                           , inCode    := 0    :: Integer
                                                           , inName    := TRIM (inAreaUnitName) ::TVarChar
                                                           , inSession := inSession             :: TVarChar
                                                            ) AS tmp);
   END IF;
   
   -- сохранили связь с <Участок>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Storage_AreaUnit(), ioId, vbAreaUnitId);   
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.23         *
 26.07.16         *
 28.07.14         *
*/

-- тест
--