-- Function: gpUpdate_Status_LossDebt()

DROP FUNCTION IF EXISTS gpUpdate_Status_LossDebt (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_LossDebt(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_LossDebt (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_LossDebt (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_LossDebt (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_LossDebt (ioId:= 0, inSession:= zfCalc_UserAdmin())
