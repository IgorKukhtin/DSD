-- Function: gpComplete_Movement_PersonalRate (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalRate (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalRate(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PersonalRate());

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_PersonalRate (inMovementId := inMovementId
                                             , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19         * 
*/

-- тест