-- Function: gpComplete_Movement_WriteOffHouseholdInventory()

DROP FUNCTION IF EXISTS gpComplete_Movement_WriteOffHouseholdInventory  (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_WriteOffHouseholdInventory(
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
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Complete_WriteOffHouseholdInventory());
           
    -- проверка - Остатки Мастер и Чайлд должны совпадать, если нет - то корректировали не правильно или задним числом съехал остаток
    IF NOT EXISTS (SELECT 1
                   FROM MovementItem
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.Amount > 0
                     AND MovementItem.DescId = zc_MI_Master())
    THEN
        RAISE EXCEPTION 'Ошибка. Нет данных для проведения.';
    END IF;

    -- Проверяем первые переводы
    IF EXISTS (SELECT 1 
               FROM MovementItem AS MI_Master

                    LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                          ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                         AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                    LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = PHI_MovementItemId.ValueData::Integer

               WHERE MI_Master.MovementId = inMovementId
                 AND MI_Master.DescId     = zc_MI_Master()
                 AND MI_Master.Amount     > 0
                 AND MI_Master.Amount     > COALESCE(MI_Income.Amount, 0)
                 AND MI_Master.IsErased   = FALSE
              )
    THEN
      SELECT Object_HouseholdInventory.ValueData, Object_PartionHouseholdInventory.ObjectCode
      INTO vbGoodsName, vbInvNumber
      FROM MovementItem AS MI_Master

           LEFT JOIN Object AS Object_PartionHouseholdInventory ON Object_PartionHouseholdInventory.Id = MI_Master.ObjectId

           LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                 ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                                AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

           LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = PHI_MovementItemId.ValueData::Integer

           LEFT JOIN Object AS Object_HouseholdInventory
                            ON Object_HouseholdInventory.ID = MI_Income.ObjectId
                            
      WHERE MI_Master.MovementId = inMovementId
        AND MI_Master.DescId     = zc_MI_Master()
        AND MI_Master.Amount     > 0
        AND MI_Master.Amount     > COALESCE(MI_Income.Amount, 0)
        AND MI_Master.IsErased   = FALSE;

      RAISE EXCEPTION 'Ошибка.Как минимум по одному хоз. инвентарю <%> <%> списание уже произведено.', vbInvNumber, vbGoodsName;
    END IF;
    
    -- Вычитаем из прихода
    PERFORM lpUpdate_MovementItem_IncomeHouseholdInventory (PHI_MovementItemId.ValueData::Integer, - MI_Master.Amount, vbUserId)
    FROM MovementItem AS MI_Master

         LEFT JOIN ObjectFloat AS PHI_MovementItemId
                               ON PHI_MovementItemId.ObjectId = MI_Master.ObjectId
                              AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                              
    WHERE MI_Master.MovementId = inMovementId
      AND MI_Master.DescId     = zc_MI_Master()
      AND MI_Master.Amount     > 0
      AND MI_Master.IsErased   = FALSE;    
         
    -- Провели документ
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_WriteOffHouseholdInventory()
                               , inUserId     := vbUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.07.20                                                       *
 */

-- тест
-- select * from gpUpdate_Status_WriteOffHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');
