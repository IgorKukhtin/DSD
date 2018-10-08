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
  DECLARE vbId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsInfo());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверяем есть ли уже такая связь
   vbId:= (SELECT Object_GoodsItem.Id 
           FROM Object_GoodsItem 
           WHERE Object_GoodsItem.GoodsId = inGoodsId 
             AND Object_GoodsItem.GoodsSizeId = inGoodsSizeId 
             AND Object_GoodsItem.Id <> COALESCE (ioId, 0)
           );
   IF COALESCE (vbId, 0) <> 0 THEN ioId := vbId; END IF; 
   
   IF COALESCE (ioId, 0) = 0 THEN
      -- добавили новый элемент справочника и вернули значение <Ключ объекта>
      INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                  VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO ioId;
   ELSE
       -- !!!проверка - нельзя менять ТОВАР!!!
       IF EXISTS (SELECT 1 FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsItemId = ioId AND GoodsId <> inGoodsId)
       THEN
           RAISE EXCEPTION 'Ошибка.Нельзя менять <Товар>';
       END IF;

       -- !!!меняем у остальных партий - ЭТИ св-ва!!!
       UPDATE Object_PartionGoods SET GoodsId = inGoodsId, GoodsSizeId = inGoodsSizeId WHERE Object_PartionGoods.GoodsItemId = ioId;

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
11.04.17          *
10.03.17                                                          *
*/

-- тест
-- 