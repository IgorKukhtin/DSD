-- Function: gpUpdate_Status_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpUpdate_Status_AsinoPharmaSP (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_AsinoPharmaSP(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
BEGIN
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_AsinoPharmaSP (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_AsinoPharmaSP (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_AsinoPharmaSP (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.03.23                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_AsinoPharmaSP (ioId:= 0, inSession:= zfCalc_UserAdmin())