-- Function: gpUnComplete_Movement_InventoryHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_InventoryHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_InventoryHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_UnComplete_InventoryHouseholdInventory());

    -- Отменяем проведение
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete()
    THEN
        PERFORM lpUpdate_MovementItem_IncomeHouseholdInventory (PHI_MovementItemId.ValueData::Integer, 1, vbUserId)
        FROM MovementItem AS MI_Master

             LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                   ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                  AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                                  
        WHERE MI_Master.MovementId = inMovementId
          AND MI_Master.DescId     = zc_MI_Master()
          AND MI_Master.Amount     = 0
          AND MI_Master.IsErased   = FALSE; 
    END IF;

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    -- пересчитали Итоговые суммы по документу
    PERFORM lpInsertUpdate_InventoryHouseholdInventory_TotalSumm (inMovementId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_InventoryHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())