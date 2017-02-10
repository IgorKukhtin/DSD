-- Function: gpReComplete_Movement_Transport(integer, boolean, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Transport (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Transport(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- это последнее проведение после расчета с/с (для прихода параметр !!!не обрабатывается!!!)
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Transport());

     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Transport())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Transport_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_Transport (inMovementId     := inMovementId
                                          , inUserId         := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.04.15         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 1794 , inSession:= '2')
-- SELECT * FROM gpReComplete_Movement_Transport (inMovementId := 1794, inIsLastComplete := FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 1794 , inSession:= '2')

