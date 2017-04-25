-- Function: gpUnComplete_Movement_OrderExternal (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUnComplete_Movement_OrderExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_OrderExternal(
    IN inMovementId        Integer               , -- ключ Документа
   OUT outPrinted          Boolean               ,
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя

)
RETURNS Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_OrderExternal());


     -- меняем статус документа + сохранили протокол
     outPrinted := lpUnComplete_Movement_OrderExternal (inMovementId := inMovementId, inUserId := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 21.04.17                                        *
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_OrderExternal (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())