-- Function: gpUpdate_Status_ChangePercent()

DROP FUNCTION IF EXISTS gpUpdate_Status_ChangePercent (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ChangePercent(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ChangePercent (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            outMessageText:= (SELECT tmp.outMessageText FROM gpComplete_Movement_ChangePercent (inMovementId, inSession) AS tmp);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ChangePercent (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;

     -- Вернули статус (вдруг он не изменился)
     ioStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.05.14                                        * del isLastComplete
 25.04.14         *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_ChangePercent (ioId:= 0, inSession:= zfCalc_UserAdmin())
