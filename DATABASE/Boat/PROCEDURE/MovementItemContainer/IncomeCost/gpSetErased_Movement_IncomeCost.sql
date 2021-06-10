-- Function: gpSetErased_Movement_IncomeCost (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_Movement_IncomeCost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_Movement_IncomeCost(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_IncomeCost());

     -- снимаем сумму затраты с документа приход
     IF (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId) = zc_Enum_Status_Complete()
     THEN
         PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummCost(), Movement.ParentId, COALESCE(MovementFloat_TotalSummCost.ValueData,0) - COALESCE(MovementFloat_AmountCost.ValueData,0) ) 
         FROM Movement
              --затрата
              LEFT JOIN MovementFloat AS MovementFloat_AmountCost
                                      ON MovementFloat_AmountCost.MovementId = Movement.Id
                                     AND MovementFloat_AmountCost.DescId = zc_MovementFloat_AmountCost()
              --сумма затратв док приходе
              LEFT JOIN MovementFloat AS MovementFloat_TotalSummCost
                                      ON MovementFloat_TotalSummCost.MovementId = Movement.ParentId
                                     AND MovementFloat_TotalSummCost.DescId = zc_MovementFloat_TotalSummCost()
         WHERE Movement.Id = inMovementId;
     END IF;


     -- Удаляем Документ
     PERFORM lpSetErased_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId
                                  );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.01.19                                        *
*/

-- тест
-- SELECT * FROM gpSetErased_Movement_IncomeCost (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())
