-- Function: gpUpdate_MI_Send_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_isMask(
    IN inMovementId      Integer      , -- ключ Документа
    IN inMovementMaskId  Integer      , -- ключ Документа маски
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());


      -- Проверка - что б не копировали два раза
      IF EXISTS (SELECT Id FROM MovementItem WHERE isErased = FALSE AND DescId = zc_MI_Master() AND MovementId = inMovementId AND Amount <> 0)
         THEN RAISE EXCEPTION 'Ошибка.В документе уже есть данные.'; 
      END IF;
    
      -- Результат
       CREATE TEMP TABLE tmpMI (MovementItemId Integer, GoodsId Integer, GoodsKindId Integer, AmountPartner TFloat) ON COMMIT DROP;


      INSERT INTO tmpMI  (MovementItemId, GoodsId, GoodsKindId, AmountPartner)

         WITH 
          tmp AS (SELECT MAX (MovementItem.Id)                         AS MovementItemId
                       , MovementItem.ObjectId                         AS GoodsId
                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                  FROM MovementItem 
                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  WHERE MovementItem.MovementId =  inMovementId
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  GROUP BY MovementItem.ObjectId
                         , MILinkObject_GoodsKind.ObjectId 
                 )

        SELECT COALESCE (tmp.MovementItemId, 0)              AS MovementItemId
             , Object_Goods.Id                               AS GoodsId
             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
             , COALESCE (MIFloat_AmountPartner.ValueData, 0) AS AmountPartner
       FROM MovementItem 
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                         ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                        AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                        AND MIFloat_AmountPartner.ValueData <> 0

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                
            LEFT JOIN tmp ON tmp.GoodsId     = MovementItem.ObjectId
                         AND tmp.GoodsKindId =  COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            
      WHERE MovementItem.MovementId = inMovementMaskId
        AND MovementItem.DescId     = zc_MI_Master()
        AND MovementItem.isErased   = False;


     --cохраняем
     PERFORM lpInsertUpdate_MovementItem_Send (ioId                  := tmpMI.MovementItemId
                                             , inMovementId          := inMovementId
                                             , inGoodsId             := tmpMI.GoodsId
                                             , inAmount              := tmpMI.AmountPartner
                                             , inPartionGoodsDate    := CAST (NULL AS TDateTime)
                                             , inCount               := CAST (0 AS TFloat)
                                             , inHeadCount           := CAST (0 AS TFloat)
                                             , ioPartionGoods        := '' ::TVarChar
                                             , inGoodsKindId         := tmpMI.GoodsKindId
                                             , inGoodsKindCompleteId := 0
                                             , inAssetId             := 0
                                             , inUnitId              := 0
                                             , inStorageId           := 0
                                             , inPartionGoodsId      := 0
                                             , inUserId              := vbUserId
                                              )
     FROM tmpMI
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.22         *
*/

-- тест
--