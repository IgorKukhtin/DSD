-- Function: gpInsertUpdate_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inObjectId            Integer   , -- Комплектующие
    IN inReceiptProdModelId  Integer   , --
    IN inAmount              TFloat    , -- Количество
    IN inComment             TVarChar  ,
    IN inUserId              Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
     
     -- !Замена!
     IF inAmount = 0
     THEN
         inAmount:= 1;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inObjectId, NULL, inMovementId, inAmount, NULL,inUserId);


     -- сохранили свойство <Заказ Клиента> 
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReceiptProdModel(), ioId, inReceiptProdModelId);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, inUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);

     END IF;


     -- удалили - ВСЕ
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= inUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = ioId
       AND MovementItem.isErased   = FALSE;


     -- ВСЕГДА автоматом формировать zc_MI_Child
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId         := 0
                                                    , inParentId   := ioId
                                                    , inMovementId := inMovementId
                                                    , inObjectId   := tmpReceiptGoodsChild.GoodsId
                                                    , inAmount     := tmpReceiptGoodsChild.Value * inAmount
                                                    , inUserId     := inUserId
                                                    )
     FROM (WITH tmpReceiptGoodsChild AS (SELECT ObjectLink_Goods_master.ChildObjectId AS GoodsId_master
                                              , ObjectLink_Object.ChildObjectId       AS GoodsId
                                              , ObjectLink_GoodsChild.ChildObjectId   AS GoodsId_child
                                              , ObjectFloat_Value.ValueData           AS Value
                                         FROM ObjectLink AS ObjectLink_ReceiptGoods
                                              -- какой узел собирается
                                              LEFT JOIN ObjectLink AS ObjectLink_Goods_master
                                                                   ON ObjectLink_Goods_master.ObjectId = ObjectLink_ReceiptGoods.ChildObjectId
                                                                  AND ObjectLink_Goods_master.DescId   = zc_ObjectLink_ReceiptGoods_Object()

                                              INNER JOIN Object AS Object_ReceiptGoodsChild
                                                                ON Object_ReceiptGoodsChild.Id       = ObjectLink_ReceiptGoods.ObjectId
                                                               -- не удален
                                                               AND Object_ReceiptGoodsChild.isErased = FALSE

                                              LEFT JOIN ObjectLink AS ObjectLink_Object
                                                                   ON ObjectLink_Object.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptGoodsChild_Object()
                                              INNER JOIN Object AS Object_Object
                                                                ON Object_Object.Id     = ObjectLink_Object.ChildObjectId
                                                               -- это НЕ услуги и НЕ пустой Boat Structure
                                                               AND Object_Object.DescId = zc_Object_Goods()

                                              -- значение в сборке
                                              INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                                     ON ObjectFloat_Value.ObjectId  = Object_ReceiptGoodsChild.Id
                                                                    AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ReceiptGoodsChild_Value()
                                                                    AND ObjectFloat_Value.ValueData > 0
                                              -- первоначальный узел сборки
                                              LEFT JOIN ObjectLink AS ObjectLink_GoodsChild
                                                                   ON ObjectLink_GoodsChild.ObjectId = Object_ReceiptGoodsChild.Id
                                                                  AND ObjectLink_GoodsChild.DescId   = zc_ObjectLink_ReceiptGoodsChild_GoodsChild()

                                         WHERE ObjectLink_ReceiptGoods.ChildObjectId = inReceiptProdModelId
                                           AND ObjectLink_ReceiptGoods.DescId        = zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods()
                                        )
           -- 1. если это первоначальный узел сборки
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_child = inObjectId

         UNION ALL
           -- 2.1. если это сборка узла
           SELECT tmpReceiptGoodsChild.GoodsId
                , tmpReceiptGoodsChild.Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- отбросили первоначальный узел сборки
             AND tmpReceiptGoodsChild.GoodsId_child IS NULL
             -- если это
             AND tmpReceiptGoodsChild.GoodsId NOT IN (SELECT DISTINCT tmpCheck.GoodsId_child FROM tmpReceiptGoodsChild AS tmpCheck WHERE tmpCheck.GoodsId_child > 0)

         UNION ALL
           -- 2.2. если это сборка узла
           SELECT DISTINCT
                  tmpReceiptGoodsChild.GoodsId_child AS GoodsId
                  -- замена
                , 1 AS Value
           FROM tmpReceiptGoodsChild
           WHERE tmpReceiptGoodsChild.GoodsId_master = inObjectId
              -- отюросили первоначальный узел сборки
             AND tmpReceiptGoodsChild.GoodsId_child > 0


         UNION ALL
           -- 3. если это сборка Лодки
           SELECT ObjectLink_Object.ChildObjectId       AS GoodsId
                  -- замена
                , ObjectFloat_Value.ValueData AS Value

           FROM ObjectLink AS ObjectLink_ReceiptProdModel
                INNER JOIN Object AS Object_ReceiptProdModelChild
                                  ON Object_ReceiptProdModelChild.Id       = ObjectLink_ReceiptProdModel.ObjectId
                                 -- не удален
                                 AND Object_ReceiptProdModelChild.isErased = FALSE

                LEFT JOIN ObjectLink AS ObjectLink_Object
                                     ON ObjectLink_Object.ObjectId = Object_ReceiptProdModelChild.Id
                                    AND ObjectLink_Object.DescId   = zc_ObjectLink_ReceiptProdModelChild_Object()
                INNER JOIN Object AS Object_Object
                                  ON Object_Object.Id     = ObjectLink_Object.ChildObjectId
                                 -- это НЕ услуги
                                 AND Object_Object.DescId = zc_Object_Goods()

                -- значение в сборке
                INNER JOIN ObjectFloat AS ObjectFloat_Value
                                       ON ObjectFloat_Value.ObjectId  = Object_ReceiptProdModelChild.Id
                                      AND ObjectFloat_Value.DescId    = zc_ObjectFloat_ReceiptProdModelChild_Value()
                                      AND ObjectFloat_Value.ValueData > 0

           WHERE ObjectLink_ReceiptProdModel.ChildObjectId = inReceiptProdModelId
             AND ObjectLink_ReceiptProdModel.DescId        = zc_ObjectLink_ReceiptProdModelChild_ReceiptProdModel()

          ) AS tmpReceiptGoodsChild
           ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.01.23         *
 12.07.21         *
*/

-- тест
--