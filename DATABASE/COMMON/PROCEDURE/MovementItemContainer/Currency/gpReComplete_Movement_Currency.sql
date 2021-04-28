-- Function: gpReComplete_Movement_Currency()

DROP FUNCTION IF EXISTS gpReComplete_Movement_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Currency(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)
  RETURNS void AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Currency());

     --  замена
     IF vbUserId = zfCalc_UserAdmin() :: Integer
     THEN
         vbUserId:= zc_Enum_Process_Auto_PrimeCost();
     END IF;

     -- Распроводим Документ
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_Currency (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.12.16                                        *
*/
