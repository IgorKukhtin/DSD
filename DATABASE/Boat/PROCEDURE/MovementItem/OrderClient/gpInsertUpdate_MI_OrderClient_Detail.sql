-- Function: gpUpdate_MI_OrderClient_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_OrderClient_Detail (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_OrderClient_Detail(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ> 
    IN inGoodsId_uzel        Integer   , -- узел / узел ПФ
    IN inObjectId            Integer   , -- Комплектующие
    IN inAmount              TFloat    , -- Количество для сборки Узла
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId   Integer;
            vbGoodsId  Integer;
            vbGoodsId_basis Integer;
BEGIN
     --
     vbUserId := lpGetUserBySession (inSession);
     
     --если изменение  zc_MI_Detail
     IF COALESCE (inId,0) <> 0
     THEN
         -- сохранили <Элемент документа zc_MI_Detail> 
         PERFORM lpInsertUpdate_MovementItem (inId, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, vbUserId);

     -- новый zc_MI_Detail
     ELSEIF COALESCE (inId,0) = 0 AND COALESCE (inGoodsId_uzel,0) <> 0
     THEN
         --ищем узел
         SELECT DISTINCT
                MILinkObject_Goods.ObjectId       AS GoodsId
              , CASE WHEN MILinkObject_Goods_basis.ObjectId = inGoodsId_uzel THEN MILinkObject_Goods_basis.ObjectId ELSE NULL END AS GoodsId_basis
        INTO vbGoodsId, vbGoodsId_basis    
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods_basis
                                               ON MILinkObject_Goods_basis.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods_basis.DescId         = zc_MILinkObject_GoodsBasis()                  
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Detail()
           AND MovementItem.isErased = FALSE
           AND (MILinkObject_Goods_basis.ObjectId = inGoodsId_uzel OR MILinkObject_Goods.ObjectId = inGoodsId_uzel)
         ;
           
         -- сохранили <Элемент документа zc_MI_Detail> 
         inId := lpInsertUpdate_MovementItem (0, zc_MI_Detail(), inObjectId, NULL, inMovementId, inAmount, NULL, vbUserId);
         -- сохранили связь с <Комплектующие - какой Узел собирается>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), inId, vbGoodsId);
         -- сохранили связь с <Комплектующие - какой "Виртуальный" Узел собирается>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsBasis(), inId, vbGoodsId_basis);
     
     --если компл. без узла. могут поменять товар или кол.    
     ELSEIF COALESCE (inId,0) = 0 AND COALESCE (inGoodsId_uzel,0) = 0    
     THEN
          --пробуем найти чайлд, если не найдем создаем новый
          SELECT MovementItem.Id
        INTO inId    
         FROM MovementItem
              LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                              AND MILinkObject_Goods.DescId         = zc_MILinkObject_Goods()
         WHERE MovementItem.MovementId = inMovementId
           AND MovementItem.DescId = zc_MI_Child()
           AND MovementItem.isErased = FALSE
           AND MovementItem.ObjectId = inObjectId
           AND MILinkObject_Goods.ObjectId IS NULL;
           
         -- сохранили <Элемент документа>
         inId := lpInsertUpdate_MovementItem (COALESCE (inId,0), zc_MI_Child(), inObjectId, NULL, inMovementId, inAmount, NULL, vbUserId);
     END IF;

 
     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.08.25         * 
*/

-- тест
-- 