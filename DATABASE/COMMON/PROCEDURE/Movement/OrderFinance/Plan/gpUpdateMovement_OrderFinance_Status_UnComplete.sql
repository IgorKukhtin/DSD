-- Function: gpUpdateMovement_OrderFinance_Status_UnComplete()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_Status_UnComplete (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_Status_UnComplete(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete(), StatusId_next = zc_Enum_Status_Complete()
     WHERE Movement.Id = inMovementId;


     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


     --
     if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. <%>', inMovementId; end if;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.12.25                                        *
*/


-- тест
-- select * from gpUpdateMovement_OrderFinance_Status_UnComplete(inMovementId := 32907603 , inMovementItemId := 341774314 , inDateDay := ('27.10.2025')::TDateTime , ioDateDay_old := ('27.10.2025')::TDateTime , inAmount := 15000 , ioAmountPlan_day := 23 , inIsAmountPlan_day := 'True' ,  inSession := '9457');
