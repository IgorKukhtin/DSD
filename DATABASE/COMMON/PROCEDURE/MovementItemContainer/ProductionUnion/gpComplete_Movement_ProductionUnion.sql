-- Function: gpComplete_Movement_ProductionUnion()

DROP FUNCTION IF EXISTS gpComplete_Movement_ProductionUnion (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ProductionUnion(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession IN (zc_Enum_Process_Auto_PrimeCost() :: TVarChar, zc_Enum_Process_Auto_Defroster() :: TVarChar, zc_Enum_Process_Auto_Kopchenie() :: TVarChar)
     THEN vbUserId:= lpGetUserBySession (inSession) :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ProductionUnion());
     END IF;

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_ProductionUnion_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_ProductionUnion (inMovementId    := inMovementId
                                                , inIsHistoryCost := TRUE
                                                , inUserId        := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.05.15                                        * set lp
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 143712, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ProductionUnion (inMovementId:= 143712, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 143712, inSession:= '2')
