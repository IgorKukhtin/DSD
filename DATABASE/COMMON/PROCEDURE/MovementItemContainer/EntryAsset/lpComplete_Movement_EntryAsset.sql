-- Function: lpComplete_Movement_EntryAsset()

DROP FUNCTION IF EXISTS lpComplete_Movement_EntryAsset (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_EntryAsset(
    IN inMovementId        Integer               , -- ключ Документа
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN

/*
     -- ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_EntryAsset()
                                , inUserId     := inUserId
                                 );
*/
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Income_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Income (inMovementId     := inMovementId
                                       , inUserId         := inUserId
                                       , inIsLastComplete := FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 28.08.16         *
 
*/

-- тест
/*
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM lpComplete_Movement_EntryAsset (inMovementId:= 1100 , inUserId:= zfCalc_UserAdmin() :: Integer, inIsLastComplete:= FALSE)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1100 , inSession:= zfCalc_UserAdmin())
*/
