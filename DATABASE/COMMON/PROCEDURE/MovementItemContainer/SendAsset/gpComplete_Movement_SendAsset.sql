-- Function: gpComplete_Movement_SendAsset()

DROP FUNCTION IF EXISTS gpComplete_Movement_SendAsset (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SendAsset(
    IN inMovementId        Integer              , -- ключ Документа
    IN inIsLastComplete    Boolean DEFAULT False, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF inSession = zc_Enum_Process_Auto_PrimeCost() :: TVarChar
     THEN vbUserId:= inSession :: Integer;
     ELSE vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SendAsset());
     END IF;

     -- Эти параметры нужны для
     vbMovementDescId:= zc_Movement_SendAsset();

      -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_SendAsset_CreateTemp();
    -- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
     -- 5.3. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SendAsset()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.03.20         *
*/

