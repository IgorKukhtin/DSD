-- Function: gpInsertUpdate_Object_CFO()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CFO(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CFO(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inCode                Integer   ,    -- Код объекта
    IN inName                TVarChar  ,    -- Название объекта
    IN inMemberId            Integer   ,    -- физ. лицо
    IN inComment             TVarChar  ,    -- Примечание
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_CFO());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_CFO());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CFO(), inCode, inName);

   -- сохранили связь с <физ.лицом>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_CFO_Member(), ioId, inMemberId);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CFO_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 23.10.25         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CFO()