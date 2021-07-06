-- Function: gpUpdate_Object_StickerProperty_CK()

DROP FUNCTION IF EXISTS gpUpdate_Object_StickerProperty_CK(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_StickerProperty_CK(
    IN inId                  Integer   , -- ключ объекта <>
    IN inisCK                Boolean   , --
   OUT outisCK               Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StickerProperty_CK());

   outisCK := NOT inisCK;
   
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не определен.';
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_CK(), inId, outisCK);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.04.21         *
*/

-- тест
--