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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_Income());


     -- обнулили <Итого сумма затрат по документу (с учетом НДС)>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSpending(), (SELECT Movement.ParentId FROM Movement WHERE Movement.Id = inMovementId), 0);

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
