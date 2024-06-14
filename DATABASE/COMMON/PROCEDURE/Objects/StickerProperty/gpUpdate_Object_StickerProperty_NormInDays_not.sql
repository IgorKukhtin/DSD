-- Function: gpUpdate_Object_StickerProperty_NormInDays_not()

DROP FUNCTION IF EXISTS gpUpdate_Object_StickerProperty_NormInDays_not(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_StickerProperty_NormInDays_not(
    IN inId                  Integer   , -- ключ объекта <>
    IN inisNormInDays_not                Boolean   , --
   OUT outisNormInDays_not               Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not());

   outisNormInDays_not := NOT inisNormInDays_not;
   
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не определен.';
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_NormInDays_not(), inId, outisNormInDays_not);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.24         *
*/

-- тест
--