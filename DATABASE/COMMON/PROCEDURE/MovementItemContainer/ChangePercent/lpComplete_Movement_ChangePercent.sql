-- Function: lpComplete_Movement_ChangePercent (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_ChangePercent (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_ChangePercent(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outMessageText      Text                  ,
    IN inUserId            Integer                 -- Пользователь
)                              
RETURNS Text
AS
$BODY$
BEGIN


     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_ChangePercent()
                                , inUserId     := inUserId
                                 );

 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.03.23         *
*/
-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 267275 , inSession:= '2')
-- SELECT * FROM lpComplete_Movement_ChangePercent (inMovementId:= 267275, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 267275 , inSession:= '2')