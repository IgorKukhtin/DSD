-- Function: gpComplete_Movement_Currency()

DROP FUNCTION IF EXISTS gpComplete_Movement_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Currency(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Currency());


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- Проводим Документ
     PERFORM lpComplete_Movement_Currency (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.11.14                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Currency (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
