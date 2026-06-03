-- Function: gpInsertUpdate_Object_TypeCommerc()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_TypeCommerc(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_TypeCommerc(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inCode                Integer   ,    -- Код объекта
    IN inName                TVarChar  ,    -- Название объекта 
    IN inComment             TVarChar  ,    -- Примечание
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_TypeCommerc());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_TypeCommerc());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_TypeCommerc(), inCode, inName, NULL);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_TypeCommerc_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 03.06.26         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_TypeCommerc()