-- Function: gpComplete_Movement_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_IncomeHouseholdInventory  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_IncomeHouseholdInventory(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbGoodsName TVarChar;
  DECLARE vbInvNumber Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Complete_IncomeHouseholdInventory());
           
    -- проверка - Остатки Мастер и Чайлд должны совпадать, если нет - то корректировали не правильно или задним числом съехал остаток
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Error. Нет данных для проведения.';
    END IF;
    
    -- собственно проводки
    PERFORM lpComplete_Movement_IncomeHouseholdInventory(inMovementId, -- ключ Документа
                                                         vbUserId);    -- Пользователь

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 30.07.20                                                       *
 09.07.20                                                       *
 */

-- тест
-- select * from gpUpdate_Status_IncomeHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

