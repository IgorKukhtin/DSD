-- Function: gpComplete_Movement_EDI_Send()

DROP FUNCTION IF EXISTS gpComplete_Movement_EDI_Send (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_EDI_Send(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_EDI_Send());

     -- Проводим Документ
     PERFORM lpComplete_Movement_EDI_Send (inMovementId := inMovementId
                                         , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.18         *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_EDI_Send (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
