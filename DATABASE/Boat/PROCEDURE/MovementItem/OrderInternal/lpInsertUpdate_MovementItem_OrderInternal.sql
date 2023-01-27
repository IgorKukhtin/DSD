-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_OrderInternal(Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_OrderInternal(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inGoodsId                Integer   , -- Комплектующие
    IN inAmount                 TFloat    , -- Количество
    IN inComment                TVarChar  ,
    IN inUserId                 Integer     -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
    DECLARE vbIsInsert Boolean;
BEGIN
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- Проверка
     IF EXISTS (SELECT 1
                FROM MovementItem
                     LEFT JOIN MovementItemFloat AS MIFloat_MovementId
                                                 ON MIFloat_MovementId.MovementItemId = MovementItem.Id
                                                AND MIFloat_MovementId.DescId         = zc_MIFloat_MovementId()
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND MovementItem.ObjectId   = inGoodsId
                  AND MovementItem.isErased   = FALSE
                  AND MovementItem.Id         <> COALESCE (ioId, 0)
                  --
                  AND COALESCE (MIFloat_MovementId.ValueData, 0) = inMovementId_OrderClient
               )
     THEN
         RAISE EXCEPTION 'Ошибка.Элемент <%> уже существует для <%>.', lfGet_Object_ValueData_article (inGoodsId), lfGet_Movement_Data (inMovementId_OrderClient);
     END IF;

     -- !Замена!
     IF inAmount = 0
     THEN
         inAmount:= 1;
     END IF;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, NULL, inMovementId, CASE WHEN vbIsInsert = TRUE AND inAmount = 0 THEN 1 ELSE inAmount END, NULL,inUserId);

     -- сохранили свойство <Заказ Клиента>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementId(), ioId, inMovementId_OrderClient ::TFloat);

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

     --
     PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                     := 0
                                                  , inParentId               := ioId
                                                  , inMovementId             := inMovementId
                                                  , inObjectId               := tmpMI.ObjectId
                                                  , inReceiptLevelId         := tmpMI.ReceiptLevelId
                                                  , inColorPatternId         := tmpMI.ColorPatternId
                                                  , inProdColorPatternId     := tmpMI.ProdColorPatternId
                                                  , inProdOptionsId          := tmpMI.ProdOptionsId
                                                  , inUnitId                 := 0 -- !!!
                                                  , inAmount                 := tmpMI.Amount
                                                  , inAmountReserv           := 0
                                                  , inAmountSend             := tmpMI.Amount
                                                  , inForCount               := tmpMI.ForCount
                                                  , inUserId                 := inUserId
                                                   )
     FROM (SELECT DISTINCT
                  CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            -- собираем в одну строчку "виртуальный" узел
                            THEN MILinkObject_Goods_basis.ObjectId
                        ELSE MovementItem.ObjectId
                  END AS ObjectId
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ReceiptLevel.ObjectId
                  END AS ReceiptLevelId
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdOptions.ObjectId
                  END AS ProdOptionsId
                  
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ColorPattern.ObjectId
                  END AS ColorPatternId
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdColorPattern.ObjectId
                  END AS ProdColorPatternId
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            -- кол-во для одной строчки "виртуальный" узел
                            THEN 1
                        ELSE MovementItem.Amount
                  END AS Amount
                  --
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MIFloat_ForCount.ValueData
                  END AS ForCount

           FROM MovementItem
                -- какой узел собирается
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                 ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
                -- какой "виртуальный" узел собирается
                LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                                 ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()
                --
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ColorPattern
                                                 ON MILinkObject_ColorPattern.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ColorPattern.DescId         = zc_MILinkObject_ColorPattern()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdColorPattern
                                                 ON MILinkObject_ProdColorPattern.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdColorPattern.DescId         = zc_MILinkObject_ProdColorPattern()
                --
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ReceiptLevel
                                                 ON MILinkObject_ReceiptLevel.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ReceiptLevel.DescId         = zc_MILinkObject_ReceiptLevel()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                 ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
                LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                            ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                           AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()

           WHERE MovementItem.MovementId = inMovementId_OrderClient
             AND MovementItem.DescId     = zc_MI_Detail()
             AND MovementItem.isErased    = FALSE
             AND ((MILinkObject_Goods.ObjectId      = inGoodsId AND MILinkObject_Goods_basis.ObjectId IS NULL)
               OR MILinkObject_Goods_basis.ObjectId = inGoodsId
                 )

          UNION
           SELECT 
                  MovementItem.ObjectId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                , MovementItem.Amount
                  --
                , MIFloat_ForCount.ValueData AS ForCount

           FROM MovementItem
                -- какой узел был в ReceiptProdModel, заполняется если была замена
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsBasis
                                                 ON MILinkObject_GoodsBasis.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsBasis.DescId         = zc_MILinkObject_GoodsBasis()
                                              --AND MILinkObject_GoodsBasis.ObjectId       = inGoodsId
                LEFT JOIN MovementItemFloat AS MIFloat_ForCount
                                            ON MIFloat_ForCount.MovementItemId = MovementItem.Id
                                           AND MIFloat_ForCount.DescId         = zc_MIFloat_ForCount()
                -- Опция
                LEFT JOIN MovementItemLinkObject AS MILinkObject_ProdOptions
                                                 ON MILinkObject_ProdOptions.MovementItemId = MovementItem.Id
                                                AND MILinkObject_ProdOptions.DescId         = zc_MILinkObject_ProdOptions()
           WHERE MovementItem.MovementId = inMovementId_OrderClient
             AND MovementItem.DescId     = zc_MI_Child()
             AND MovementItem.isErased    = FALSE
             -- не опция
             AND MILinkObject_ProdOptions.ObjectId IS NULL
             -- это Лодка
             AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Product())

          UNION
           SELECT lpSelect.GoodsId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                  -- Кол-во опций
                , lpSelect.Amount
                  --
                , 1 AS ForCount

           FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                            , inIsShowAll:= FALSE
                                            , inIsErased := FALSE
                                            , inIsSale   := TRUE
                                            , inSession  := inUserId :: TVarChar
                                             ) AS lpSelect
           WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient
             AND lpSelect.ProductId              = inGoodsId
             AND lpSelect.GoodsId                > 0
             -- БЕЗ этой Структуры
             AND COALESCE (lpSelect.ProdColorPatternId, 0) = 0
             -- это Лодка
             AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Product())
           
          ) AS tmpMI
    ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.12.22         *
*/

-- тест
--