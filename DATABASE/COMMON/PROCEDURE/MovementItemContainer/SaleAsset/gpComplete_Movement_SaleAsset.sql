-- Function: gpComplete_Movement_SaleAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_SaleAsset (Integer,  TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SaleAsset(
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
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SaleAsset());
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Sale_CreateTemp();
  
     -- !!!проводки!!!
     PERFORM lpComplete_Movement_Sale (inMovementId:= inMovementId
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
