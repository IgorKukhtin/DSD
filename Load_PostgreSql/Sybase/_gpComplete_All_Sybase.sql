-- Function: gpComplete_All_Sybase()

DROP FUNCTION IF EXISTS gpComplete_All_Sybase (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_All_Sybase(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsNoHistoryCost   Boolean              , --
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbMovementDescId Integer;
  DECLARE vbStatusId Integer;
BEGIN

     SELECT DescId, StatusId INTO vbMovementDescId, vbStatusId FROM Movement WHERE Id = inMovementId;

     IF COALESCE (vbMovementDescId, 0) = 0
     THEN
         RAISE EXCEPTION 'NOT FIND, inMovementId = %', inMovementId;
     END IF;


     -- !!! распроведение!!!
     PERFORM lpUnComplete_Movement (inMovementId:= inMovementId, inUserId:= zfCalc_UserAdmin() :: Integer);



     -- !!!1 - Loss!!!
     IF vbMovementDescId = zc_Movement_Loss()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Loss_CreateTemp();
             -- !!! проводим - Loss !!!
             PERFORM lpComplete_Movement_Loss (inMovementId     := inMovementId
                                             , inUserId         := zfCalc_UserAdmin() :: Integer);

     ELSE
     -- !!!2 - SendOnPrice!!!
     IF vbMovementDescId = zc_Movement_SendOnPrice()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
             -- !!! проводим - SendOnPrice !!!
             PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                                    , inUserId         := zfCalc_UserAdmin() :: Integer);

     ELSE
     -- !!!3 - ReturnIn!!!
     IF vbMovementDescId = zc_Movement_ReturnIn()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ReturnIn_CreateTemp();
             -- !!! проводим - ReturnIn !!!
             PERFORM lpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                 , inUserId         := zfCalc_UserAdmin() :: Integer
                                                 , inIsLastComplete := inIsNoHistoryCost);

     ELSE
     -- !!!4 - Sale!!!
     IF vbMovementDescId = zc_Movement_Sale()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Sale_CreateTemp();
             -- !!! проводим - Sale !!!
             PERFORM lpComplete_Movement_Sale (inMovementId     := inMovementId
                                             , inUserId         := zfCalc_UserAdmin() :: Integer
                                             , inIsLastComplete := inIsNoHistoryCost);
     ELSE
     -- !!!5 - ReturnOut!!!
     IF vbMovementDescId = zc_Movement_ReturnOut()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ReturnOut_CreateTemp();
             -- !!! проводим - ReturnOut !!!
             PERFORM lpComplete_Movement_ReturnOut (inMovementId     := inMovementId
                                                  , inUserId         := zfCalc_UserAdmin() :: Integer
                                                  , inIsLastComplete := inIsNoHistoryCost);

     ELSE
     -- !!!6.1. - Send!!!
     IF vbMovementDescId = zc_Movement_Send()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_Send_CreateTemp();
             -- !!! проводим - Send !!!
             PERFORM gpComplete_Movement_Send (inMovementId     := inMovementId
                                             , inIsLastComplete := NULL
                                             , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!6.2. - ProductionUnion!!!
     IF vbMovementDescId = zc_Movement_ProductionUnion()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
             -- !!! проводим - ProductionUnion !!!
             PERFORM gpComplete_Movement_ProductionUnion (inMovementId     := inMovementId
                                                        , inIsLastComplete := NULL
                                                        , inSession        := zfCalc_UserAdmin());
     ELSE
     -- !!!6.3. - ProductionSeparate!!!
     IF vbMovementDescId = zc_Movement_ProductionSeparate()
     THEN
             -- создаются временные таблицы - для формирование данных для проводок
             PERFORM lpComplete_Movement_ProductionSeparate_CreateTemp();
             -- !!! проводим - ProductionSeparate !!!
             PERFORM gpComplete_Movement_ProductionSeparate (inMovementId     := inMovementId
                                                           , inIsLastComplete := NULL
                                                           , inSession        := zfCalc_UserAdmin());
     ELSE
         RAISE EXCEPTION 'NOT FIND inMovementId = %, MovementDescId = %(%)', inMovementId, vbMovementDescId, (SELECT ItemName FROM MovementDesc WHERE Id = vbMovementDescId);
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.14                                        *
*/

-- тест
-- SELECT * FROM gpComplete_All_Sybase (inMovementId:= 3581, inIsBefoHistoryCost:= FALSE, inIsNoHistoryCost = FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
