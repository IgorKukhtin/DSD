-- Function: gpUpdate_MI_OrderInternal_Child_byOrder()

DROP FUNCTION IF EXISTS gpUpdate_MI_OrderInternal_Child_byOrder (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_OrderInternal_Child_byOrder(
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inMovementId_OrderClient Integer   , -- Заказ Клиента
    IN inGoodsId                Integer   , -- Комплектующие
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);

     -- удалили - ВСЕ
     PERFORM lpSetErased_MovementItem (inMovementItemId:= MovementItem.Id, inUserId:= vbUserId)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.ParentId   = inParentId
       AND MovementItem.isErased   = FALSE;

     -- ВСЕГДА автоматом формировать zc_MI_Child  
     PERFORM lpInsertUpdate_MI_OrderInternal_Child (ioId                     := 0
                                                  , inParentId               := inParentId
                                                  , inMovementId             := inMovementId
                                                  , inObjectId               := tmpMI.ObjectId
                                                  , inReceiptLevelId         := tmpMI.ReceiptLevelId
                                                  , inColorPatternId         := tmpMI.ColorPatternId
                                                  , inProdColorPatternId     := tmpMI.ProdColorPatternId
                                                  , inProdOptionsId          := tmpMI.ProdOptionsId
                                                  , inUnitId                 := 0 -- !!!
                                                  , inAmount                 := tmpMI.Amount
                                                  , inAmountReserv           := 0
                                                  , inAmountSend             := 0
                                                  , inForCount               := tmpMI.ForCount
                                                  , inUserId                 := vbUserId
                                                   )
     FROM (-- 1. Узел или "виртуальный" узел
           SELECT DISTINCT
                  CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            -- собираем в одну строчку "виртуальный" узел
                            THEN MILinkObject_Goods_basis.ObjectId
                        ELSE MovementItem.ObjectId
                  END AS ObjectId
                  -- ReceiptLevel
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ReceiptLevel.ObjectId
                  END AS ReceiptLevelId
                  -- Шаблон Boat Structure
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ColorPattern.ObjectId
                  END AS ColorPatternId
                  -- Boat Structure
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdColorPattern.ObjectId
                  END AS ProdColorPatternId
                  -- Options
                , CASE WHEN MILinkObject_Goods.ObjectId = inGoodsId
                        AND MILinkObject_Goods_basis.ObjectId > 0
                            THEN 0
                        ELSE MILinkObject_ProdOptions.ObjectId
                  END AS ProdOptionsId
                  
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
             AND (MILinkObject_Goods.ObjectId       = inGoodsId
               OR MILinkObject_Goods_basis.ObjectId = inGoodsId
                 )

          UNION
           -- Лодка
           SELECT 
                  MovementItem.ObjectId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                , 0 AS ProdOptionsId
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
           -- Опции
           SELECT lpSelect.GoodsId AS ObjectId
                  --
                , 0 AS ReceiptLevelId
                  --
                , 0 AS ColorPatternId
                  --
                , 0 AS ProdColorPatternId
                  --
                , lpSelect.ProdOptionsId
                  -- Кол-во опций
                , lpSelect.Amount
                  --
                , 1 AS ForCount

           FROM gpSelect_Object_ProdOptItems (inMovementId_OrderClient:= inMovementId_OrderClient
                                            , inIsShowAll:= FALSE
                                            , inIsErased := FALSE
                                            , inIsSale   := TRUE
                                            , inSession  := inSession
                                             ) AS lpSelect
           WHERE lpSelect.MovementId_OrderClient = inMovementId_OrderClient
             AND lpSelect.ProductId              = inGoodsId
             AND lpSelect.GoodsId                > 0
             -- БЕЗ этой Структуры
             AND COALESCE (lpSelect.ProdColorPatternId, 0) = 0
             -- это Лодка
             AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inGoodsId AND Object.DescId = zc_Object_Product())
           
          ) AS tmpMI;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.11.23         *
*/

-- тест
-- SELECT * FROM