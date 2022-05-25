-- Function: gpUpdate_Object_GoodsByGoodsKind_Sticker (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_Sticker (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_Sticker(
    IN inId                      Integer  , -- ключ объекта <Товар>
    IN inWeightPackageSticker    TFloat   , -- вес 1-ого пакета
    IN inSession                 TVarChar 
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_GoodsByGoodsKind_Sticker());


   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;


   -- проверка - что б Админ ничего не ломал
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент справочника не установлен.';
   END IF;

   -- сохранили свойство <вес 1-ого пакета>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_WeightPackageSticker(), inId, inWeightPackageSticker);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.02.18         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_GoodsByGoodsKind_Sticker (inId:= 1, inWeightPackageSticker:=0, inUserId:= 2)