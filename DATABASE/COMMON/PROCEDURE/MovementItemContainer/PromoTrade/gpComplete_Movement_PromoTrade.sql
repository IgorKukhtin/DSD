-- Function: gpComplete_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PromoTrade(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoTrade());

     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement_PromoTrade (inMovementId := inMovementId
                                           , inUserId     := vbUserId
                                            );
                                             
     -- проводим Документ + сохранили протокол
     PERFORM gpUpdate_Movement_PromoTradeHistory (inMovementId := inMovementId
                                                , inSession    := inSession
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
 */

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
