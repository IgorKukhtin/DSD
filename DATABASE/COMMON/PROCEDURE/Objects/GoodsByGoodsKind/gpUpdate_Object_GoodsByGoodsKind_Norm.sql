-- Function: gpUpdate_Object_GoodsByGoodsKind_Norm (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpUpdate_Object_GoodsByGoodsKind_Norm (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsByGoodsKind_Norm(
    IN inId         Integer  , -- ключ объекта <Товар>
    IN inNormRem    TFloat   , -- нормативные остатки, тон
    IN inNormOut    TFloat   , -- нормативное потребление в месяц, тон
    IN inSession    TVarChar 
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_GoodsByGoodsKind_Norm());


   -- проверка - что б Админ ничего не ломал
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION 'Ошибка.Нет прав - что б Админ ничего не ломал.';
   END IF;


   -- сохранили свойство <нормативные остатки, тон>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormRem(), inId, inNormRem);
   -- сохранили свойство <нормативное потребление в месяц, тон>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormOut(), inId, inNormOut);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
25.03.21         *
*/

-- тест
--