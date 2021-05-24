-- Function: gpComplete_Movement_LossAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_LossAsset (Integer,  TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_LossAsset(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= lpGetUserBySession (inSession)  :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_LossAsset());
     END IF;

/*IF vbUserId = 5
then
   update Movement set OperDate = '31.08.2020' where Id = inMovementId;
end if;
*/
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Loss_CreateTemp();

     -- !!!проводки!!!
     PERFORM lpComplete_Movement_Loss (inMovementId:= inMovementId
                                     , inUserId    := vbUserId
                                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.20         *
*/
