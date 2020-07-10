-- Function: gpUnComplete_Movement_IncomeHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_IncomeHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_IncomeHouseholdInventory(
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
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_UnComplete_IncomeHouseholdInventory());

    -- Проверяем первые переводы
    IF (SELECT StatusId FROM Movement WHERE Id = inMovementId) = zc_Enum_Status_Complete() AND
       EXISTS (SELECT 1
               FROM MovementItem AS MI_Master
               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount     <> 1
                 AND MI_Master.IsErased   = FALSE
              )
    THEN
       SELECT Object_HouseholdInventory.ValueData, MIFloat_InvNumber.ValueData::Integer
       INTO vbGoodsName, vbInvNumber
       FROM MovementItem AS MI_Master

            LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                        ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                       AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                       
            LEFT JOIN Object AS Object_HouseholdInventory
                             ON Object_HouseholdInventory.ID = MI_Master.ObjectId

       WHERE MI_Master.MovementId = inMovementId
         AND MI_Master.DescId     = zc_MI_Master()
         AND MI_Master.Amount     <> 1
         AND MI_Master.IsErased   = FALSE;

       RAISE EXCEPTION 'Ошибка.Как минимум один хоз. инвентарь <%> <%> списан.', vbInvNumber, vbGoodsName;
    END IF;

    -- Открепление партий
    PERFORM lpInsertUpdate_Object_PartionHouseholdInventory(ioId               := 0,                                     -- ключ объекта <>
                                                            inInvNumber        := MIFloat_InvNumber.ValueData::Integer,  -- Инвентарный номер
                                                            inUnitId           := MovementLinkObject_Unit.ObjectId,      -- Подразделение
                                                            inMovementItemId   := 0,                                     -- Ключ элемента прихода хозяйственного инвентаря
                                                            inUserId           := vbUserId)
    FROM MovementItem AS MI_Master

         LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                     ON MIFloat_InvNumber.MovementItemId = MI_Master.Id
                                    AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()
                                       
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = MI_Master.MovementId
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    WHERE MI_Master.MovementId = inMovementId
      AND MI_Master.DescId     = zc_MI_Master()
      AND MI_Master.Amount     > 0
      AND MI_Master.IsErased   = FALSE;    

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

    -- пересчитали Итоговые суммы по документу
    PERFORM lpInsertUpdate_IncomeHouseholdInventory_TotalSumm (inMovementId);
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_IncomeHouseholdInventory (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())