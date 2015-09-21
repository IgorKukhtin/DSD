-- Function: gpComplete_Movement_ReturnOut()

DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbOperDate  TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnOut());
     vbUserId:= inSession;
     -- Проверили перед проведением на достаточность наличия, НДС и пр.
     PERFORM lpCheckComplete_Movement_ReturnOut (inMovementId);
     
    -- Проверить, что бы не было переучета позже даты документа
    SELECT
        Movement.OperDate,
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION 'Ошибка. По одному или более товарам есть документ переучета позже даты текущего возврата. Проведение документа запрещено!';
    END IF;
     
      -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- собственно проводки
     PERFORM lpComplete_Movement_ReturnOut(inMovementId, -- ключ Документа
                                           vbUserId);    -- Пользователь                          

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.15                         * 

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
