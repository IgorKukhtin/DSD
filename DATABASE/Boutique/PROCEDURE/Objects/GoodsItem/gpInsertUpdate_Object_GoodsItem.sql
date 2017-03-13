-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsItem(
 INOUT ioId           Integer,       -- Ключ объекта <Товары с размерами>            
    IN inGoodsId      Integer,       -- Ключ объекта <Товары>             
    IN inGoodsSizeId  Integer,       -- Ключ объекта <Размер товара>
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
   
   IF COALESCE (ioId, 0) = 0 THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                  VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO ioId;
   ELSE
       -- изменили элемент справочника по значению <Ключ объекта>
       UPDATE Object_GoodsItem SET GoodsId = inGoodsId, GoodsSizeId = inGoodsSizeId WHERE Id = ioId ;

       -- если такой элемент не был найден
       IF NOT FOUND THEN
          -- добавили новый элемент справочника со значением <Ключ объекта>
          INSERT INTO Object_GoodsItem (Id, GoodsId, GoodsSizeId)
                     VALUES (ioId, inGoodsId, inGoodsSizeId);
       END IF; -- if NOT FOUND

   END IF; -- if COALESCE (ioId, 0) = 0  


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
