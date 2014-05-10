-- Function: lpComplete_Movement_Tax()

DROP FUNCTION IF EXISTS lpComplete_Movement_Tax (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Tax(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
 RETURNS VOID
AS
$BODY$
BEGIN
     -- Обязательно меняем статус документа
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND DescId = zc_Movement_Tax() AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.05.14                                        * set lp
 10.05.14                                        * add lpInsert_MovementProtocol
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Tax (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
