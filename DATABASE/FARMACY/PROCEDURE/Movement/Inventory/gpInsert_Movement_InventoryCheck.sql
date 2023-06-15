-- Function: gpInsert_Movement_InventoryCheck()

DROP FUNCTION IF EXISTS gpInsert_Movement_InventoryCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_InventoryCheck(
    IN inMovementId  Integer   , -- Ключ объекта <Документ Инвентаризации>
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Inventory());    
    
    PERFORM gpInsert_MI_InventoryCheck (inMovementId  := inMovementId
                                      , inGoodsId     := MICheck.GoodsId
                                      , inAmount      := MICheck.Amount
                                      , inDateInput   := MICheck.OperDate
                                      , inUserInputId := MICheck.UserId
                                      , inCheckId     := MICheck.MovementId
                                      , inSession     := inSession)
    FROM gpSelect_Movement_InventoryCheck(inMovementId := inMovementId, inSession := inSession) AS MICheck;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.06.23                                                       *
*/

-- тест

-- select * from gpInsert_Movement_InventoryCheck(inMovementId := 31882953 , inSession := '3');
    