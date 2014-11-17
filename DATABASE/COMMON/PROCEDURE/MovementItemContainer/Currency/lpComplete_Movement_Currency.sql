-- Function: lpComplete_Movement_Currency()

DROP FUNCTION IF EXISTS lpComplete_Movement_Currency (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Currency(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
 RETURNS VOID
AS
$BODY$
BEGIN

     -- Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Currency()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Currency (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
