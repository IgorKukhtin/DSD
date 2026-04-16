-- Function: gpInsertUpdate_Object_MemberGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberGoods(Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberGoods(
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
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_MemberGoods());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_MemberGoods());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberGoods(), inCode, inName);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_MemberGoods_Comment(), ioId, inComment);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.    Кухтин И.В.   Климентьев К.И.
 16.04.26         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MemberGoods()