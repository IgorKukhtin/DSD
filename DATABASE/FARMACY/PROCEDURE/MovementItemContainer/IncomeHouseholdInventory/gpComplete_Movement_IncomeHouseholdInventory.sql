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

    -- Проверяем первые переводы
    IF EXISTS (SELECT 1
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

       RAISE EXCEPTION 'Ошибка.Как минимум по одному хоз. инвентарю <%> <%> не заполнено количество.', vbInvNumber, vbGoodsName;
    END IF;
    
    -- Создание партий
    PERFORM lpInsertUpdate_Object_PartionHouseholdInventory(ioId               := 0,                                     -- ключ объекта <>
                                                            inInvNumber        := MIFloat_InvNumber.ValueData::Integer,  -- Инвентарный номер
                                                            inUnitId           := MovementLinkObject_Unit.ObjectId,      -- Подразделение
                                                            inMovementItemId   := MI_Master.ID,                          -- Ключ элемента прихода хозяйственного инвентаря
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
         
    -- Провели документ
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_IncomeHouseholdInventory()
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
-- select * from gpUpdate_Status_IncomeHouseholdInventory(inMovementId := 19469516 , inStatusCode := 2 ,  inSession := '3');

