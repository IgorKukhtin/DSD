-- Function: lpComplete_Movement_PersonalGroupSummAdd (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalGroupSummAdd (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS void
AS
$BODY$
  DECLARE vbMemberId_From Integer;
BEGIN

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalGroupSummAdd()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.02.24         * 
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM lpComplete_Movement_PersonalGroupSummAdd (inMovementId:= 103, inUserId:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 103, inSession:= zfCalc_UserAdmin())
