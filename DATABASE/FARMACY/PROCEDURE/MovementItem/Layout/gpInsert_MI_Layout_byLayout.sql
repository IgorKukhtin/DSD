-- Function: gpInsert_MI_Layout_byLayout()

DROP FUNCTION IF EXISTS gpInsert_MI_Layout_byLayout (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MI_Layout_byLayout(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_mask     Integer   , -- Ключ объекта <Документ выкладки> из которого копируем товары
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    -- сохраняем товары
    PERFORM lpInsertUpdate_MovementItem_Layout (ioId         := tmpAll.Id
                                              , inMovementId := inMovementId
                                              , inGoodsId    := tmpAll.GoodsId
                                              , inAmount     := tmpAll.Amount  :: TFloat
                                              , inUserId     := vbUserId
                                              )
    FROM (WITH 
          -- товары входящего док. выкладки
          tmpMI_mask AS (SELECT MovementItem.ObjectId AS GoodsId
                              , MovementItem.Amount   AS Amount
                         FROM MovementItem
                         WHERE MovementItem.MovementId = inMovementId_mask
                           AND MovementItem.DescId = zc_MI_Master()
                           AND MovementItem.isErased = FALSE
                         )
        , tmpMI AS (SELECT MovementItem.Id       AS Id
                         , MovementItem.ObjectId AS GoodsId
                         , MovementItem.Amount   AS Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

          SELECT COALESCE (tmpMI.Id, 0)                       AS Id
               , COALESCE (tmpMI.GoodsId, tmpMI_mask.GoodsId) AS GoodsId
               , COALESCE (tmpMI.Amount, tmpMI_mask.Amount)   AS Amount
          FROM tmpMI
              FULL JOIN tmpMI_mask ON tmpMI_mask.GoodsId = tmpMI.GoodsId
          ) AS tmpAll;       

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.20         *
*/