-- Function: gpInsertUpdate_Movement_Check_CheckCombine()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_CheckCombine(Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_CheckCombine(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementAddId       Integer   , -- Ключ объекта <Документ>
    IN inisCheckCombine      Boolean   , -- Не для НТЗ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;
  
  IF COALESCE(inisCheckCombine, FALSE) <>TRUE
  THEN
    RETURN;
  END IF;
  
  IF COALESCE(inMovementId, 0) = 0 or COALESCE(inMovementAddId, 0) = 0
  THEN
    RETURN;
  END IF;
  
  PERFORM gpInsertUpdate_MovementItem_Check_Site (ioId:= 0
                                                , inMovementId:= inMovementID
                                                , inGoodsId:= MI_Master.ObjectId
                                                , inAmount:= MI_Master.Amount
                                                , inPrice:= MIFloat_Price.ValueData 
                                                , inSession := inSession)
  FROM MovementItem AS MI_Master
       LEFT JOIN MovementItemFloat AS MIFloat_Price
                                   ON MIFloat_Price.MovementItemId = MI_Master.Id
                                  AND MIFloat_Price.DescId = zc_MIFloat_Price()
       LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                   ON MIFloat_PriceSale.MovementItemId = MI_Master.Id
                                  AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
       LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                   ON MIFloat_ChangePercent.MovementItemId = MI_Master.Id
                                  AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
  WHERE MI_Master.MovementId = inMovementAddId
    AND MI_Master.DescId = zc_MI_Master()
    AND MI_Master.isErased = FALSE
    AND MI_Master.Amount > 0;
    
    
  PERFORM gpSetErased_Movement_Income (inMovementId:= inMovementAddId, inSession:= inSession);  

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 23.01.20                                                                    *
*/

-- тест

-- select * from gpInsertUpdate_Movement_Check_CheckCombine(inMovementId := 24038406 , inMovementAddId := 24038407 , inisCheckCombine := 'True' ,  inSession := '3');