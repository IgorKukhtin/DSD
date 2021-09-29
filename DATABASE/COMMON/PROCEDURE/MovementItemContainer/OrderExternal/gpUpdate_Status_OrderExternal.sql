-- Function: gpUpdate_Status_OrderExternal()

DROP FUNCTION IF EXISTS gpUpdate_Status_OrderExternal (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_OrderExternal(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
   OUT outStatusName         TVarChar  ,
   OUT outPrinted            Boolean   ,
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN
     --
     outPrinted := FALSE;
     --
     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_OrderExternal (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            SELECT tmp.outMessageText INTO outMessageText FROM gpComplete_Movement_OrderExternal (inMovementId, inSession) AS tmp;
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_OrderExternal (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', ioStatusCode;
     END CASE;
     
     -- вернули - какой статус
     SELECT Object.ObjectCode, Object.ValueData INTO ioStatusCode, outStatusName
     FROM Movement JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.06.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_OrderExternal (ioId:= 0, inSession:= zfCalc_UserAdmin())
