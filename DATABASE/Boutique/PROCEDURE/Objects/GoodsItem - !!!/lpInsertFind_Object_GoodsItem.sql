-- Function: gpInsertUpdate_Object_GoodsItem (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS lpInsertFind_Object_GoodsItem (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertFind_Object_GoodsItem (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_GoodsItem(
    IN inGoodsId      Integer,       -- Ключ объекта <Товар>
    IN inGoodsSizeId  Integer,       -- Ключ объекта <Размер товара>
    IN inPartionId    Integer,       -- Ключ объекта <Партия товара>
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

     -- если не нашли, но партия уже есть
     IF inPartionId > 0 AND COALESCE (vbId, 0) = 0
     THEN
         -- Находим по партии
         vbId:= (SELECT Object_PartionGoods.GoodsItemId FROM Object_PartionGoods WHERE Object_PartionGoods.MovementItemId = inPartionId);
     
         -- ТОЛЬКО - если этот элемент принадлежит одной партии - inPartionId
         IF 1 = (SELECT COUNT(*) FROM Object_PartionGoods WHERE Object_PartionGoods.GoodsItemId = vbId)
         THEN
             -- изменили элемент
             UPDATE Object_GoodsItem SET GoodsId = inGoodsId, GoodsSizeId = inGoodsSizeId WHERE Id = vbId ;
         
             -- если такой элемент не был изменен
             IF NOT FOUND THEN
                RAISE EXCEPTION 'Ошибка.такой элемент не был изменен <%> <%>.', vbId, inPartionId;
             END IF; -- if NOT FOUND

         ELSE

             -- считаем что НЕ нашли, т.е. надо будет сделать INSERT
             vbId:= 0;

         END IF; -- if 1 = ...
         
     END IF;

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