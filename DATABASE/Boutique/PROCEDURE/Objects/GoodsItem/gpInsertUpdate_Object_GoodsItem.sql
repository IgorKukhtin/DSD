-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsItem(
 INOUT ioId           Integer,       -- Ключ объекта <Товары с размерами>            
    IN inGoodsId      Integer,       -- Ключ объекта <Товары>             
    IN inGoodsSizeId  Integer,       -- Ключ объекта <Размер товара>
    IN inIsErased     Boolean,       -- Удален (да/нет)	отмечаем - если все приходы удалены, что б избежать физического удаления
    IN inisArc        Boolean,       -- Архивный (да/нет) будем отмечать "старые" элементы, по которым движение завершилось давнооо
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsInfo(), 0, '');

   -- сохранили Удален (да/нет)	отмечаем - если все приходы удалены, что б избежать физического удаления
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsItem_isErased(), ioId, inIsErased);
   -- сохранили Архивный (да/нет) будем отмечать "старые" элементы, по которым движение завершилось давнооо
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsItem_isArc(), ioId, inisArc);

   -- сохранили связь с <Товары> 
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsInfo_Goods(), ioId, inGoodsId);
   -- сохранили связь с <Размер товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsInfo_GoodsSize(), ioId, inGoodsSizeId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
10.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsInfo()
