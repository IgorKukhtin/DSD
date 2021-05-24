-- Function: gpInsertUpdate_Object_ReplServer()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReplServer(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReplServer(
 INOUT ioId              Integer   ,    -- ключ объекта <>
    IN inCode            Integer   ,    -- Код объекта 
    IN inName            TVarChar  ,    -- Название объекта 
    IN inHost            TVarChar  ,    -- 
    IN inUser            TVarChar  ,    -- 
    IN inPassword        TVarChar  ,    --
    IN inPort            TVarChar  ,    -- 
    IN inDataBase        TVarChar  ,    -- 
    IN inSession         TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReplServer());
   vbUserId:= lpGetUserBySession (inSession);

    -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ReplServer()); 

   -- проверка уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ReplServer(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReplServer(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Host(), ioId, inHost);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_User(), ioId, inUser);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Password(), ioId, inPassword);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_Port(), ioId, inPort);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReplServer_DataBase(), ioId, inDataBase);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.06.18         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReplServer()
