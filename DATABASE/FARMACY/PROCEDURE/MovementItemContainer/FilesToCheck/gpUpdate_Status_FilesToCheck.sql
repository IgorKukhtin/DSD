-- Function: gpUpdate_Status_FilesToCheck()

DROP FUNCTION IF EXISTS gpUpdate_Status_FilesToCheck (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_FilesToCheck(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_FilesToCheck (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_FilesToCheck (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_FilesToCheck (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.09.22                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_FilesToCheck (ioId:= 0, inSession:= zfCalc_UserAdmin())