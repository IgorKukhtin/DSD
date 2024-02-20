-- Function: gpUpdate_Object_GoodsByGoodsKind_PackLimit (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_PackLimit (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_PackLimit(
    IN inId                      Integer  , -- ключ объекта <>
    IN inPackLimit               TFloat   , -- 
    IN inisPackLimit             Boolean  ,
    IN inSession                 TVarChar 
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_GoodsByGoodsKind_PackLimit());

   -- проверка - что б Админ ничего не ломал
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент справочника не установлен.';
   END IF;
  
   -- сохранили свойство <>
   IF inisPackLimit = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_PackLimit(), inId, inPackLimit);
   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_PackLimit(), inId, inisPackLimit);

   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5 OR vbUserId = 9457
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.02.24         *
*/

-- тест
--