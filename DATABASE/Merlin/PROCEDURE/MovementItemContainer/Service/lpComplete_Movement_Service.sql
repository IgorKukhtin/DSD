DROP FUNCTION IF EXISTS lpComplete_Movement_Service (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Service(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
BEGIN

 

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_Service()
                               , inUserId     := inUserId
                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Service (inMovementId:= 224, inUserId := zfCalc_UserAdmin() :: Integer)  order by ObjectId_parent;
