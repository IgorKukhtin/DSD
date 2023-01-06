-- Function: gpInsertUpdate_MovementItem_PromoUnit()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_Set_Zero (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_Set_Zero(
    IN inMovementId          Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoUnit());
     vbUserId := inSession;
	 
     -- Обнулили все позиции
    PERFORM lpInsertUpdate_MovementItem_PromoUnit (ioId                 := MovementItem.Id
                                                 , inMovementId         := MovementItem.MovementId
                                                 , inGoodsId            := MovementItem.ObjectId
                                                 , inAmount             := 0::TFloat
                                                 , inAmountPlanMax      := 0::TFloat
                                                 , inPrice              := COALESCE(MovementItemFloat_Price.ValueData,0)
                                                 , inComment            := ''::TVarChar
                                                 , inisFixedPercent     := False
                                                 , inUserId             := vbUserId)
    FROM MovementItem
        LEFT OUTER JOIN MovementItemFloat AS MovementItemFloat_Price
                                          ON MovementItemFloat_Price.MovementItemId = MovementItem.Id
                                         AND MovementItemFloat_Price.DescId = zc_MIFloat_Price() 
    WHERE MovementItem.MovementId = inMovementId
      AND MovementItem.DescId = zc_MI_Master()
      AND MovementItem.Amount <> 0;
        
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
  25.04.16        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_PromoUnit_Set_Zero inMovementId:= 0, inSession:= '2')
