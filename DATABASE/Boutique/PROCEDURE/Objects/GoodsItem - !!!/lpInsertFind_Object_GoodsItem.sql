-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_GoodsItem (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_GoodsItem(
    IN inGoodsId      Integer,       -- Ключ объекта <Товары>             
    IN inGoodsSizeId  Integer,       -- Ключ объекта <Размер товара>
    IN inUserId       Integer        -- 
)
RETURNS Integer
AS
$BODY$
   DECLARE vbId Integer;
BEGIN
     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Товар>.';
     END IF;
     -- проверка - свойство должно быть установлено
     IF COALESCE (inGoodsSizeId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Не установлено значение <Размер товара>.';
     END IF;


     -- Находим по св-вам
     vbId:= (SELECT Object_GoodsItem.Id FROM Object_GoodsItem WHERE Object_GoodsItem.GoodsId = inGoodsId AND Object_GoodsItem.GoodsSizeId = inGoodsSizeId);
     
     -- Если не нашли
     IF COALESCE (vbId, 0) = 0
     THEN
          -- добавили новый элемент
          INSERT INTO Object_GoodsItem (GoodsId, GoodsSizeId)
                                VALUES (inGoodsId, inGoodsSizeId) RETURNING Id INTO vbId;

     END IF; -- if COALESCE (vbId, 0) = 0

     -- Возвращаем значение
     RETURN (vbId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
24.04.17                                         *
*/

-- тест
-- 