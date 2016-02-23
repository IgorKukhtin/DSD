-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_isOrder(
 INOUT ioId                  Integer  , -- ключ объекта <Товар>
    IN inIsOrder             Boolean  , -- используется в заявках
    IN inSession             TVarChar 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder());

   -- проверка
   IF COALESCE (ioId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Элемент не записан.';
   END IF;
   
   -- сохранили свойство <используется в заявках>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.02.16         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)
