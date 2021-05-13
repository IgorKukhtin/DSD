-- Function: gpUpdate_Status_Sale()

--DROP FUNCTION IF EXISTS gpUpdate_Status_Sale (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Status_Sale (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Sale(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
   OUT outPrinted            Boolean   ,
    IN inisReCalcPrice       Boolean   , -- Пересчет цен при п/п
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
BEGIN
     --
     outPrinted := FALSE;
     --
     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_Sale (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            PERFORM gpComplete_Movement_Sale (inMovementId, FALSE, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_Sale (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.10.13                                        *
 06.10.13                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_Sale (ioId:= 0, inSession:= zfCalc_UserAdmin())
