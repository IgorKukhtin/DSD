-- Function: lpComplete_Movement_EDI_Send()

DROP FUNCTION IF EXISTS lpComplete_Movement_EDI_Send (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_EDI_Send(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
 RETURNS VOID
AS
$BODY$
BEGIN


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_EDI_Send()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.18         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_EDI_Send (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
