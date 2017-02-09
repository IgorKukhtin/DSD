-- Function: gpUpdate_Status_TaxCorrective()

DROP FUNCTION IF EXISTS gpUpdate_Status_TaxCorrective (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_TaxCorrective(
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
            PERFORM gpUnComplete_Movement_TaxCorrective (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            outMessageText:= (SELECT tmp.outMessageText FROM gpComplete_Movement_TaxCorrective (inMovementId, inSession) AS tmp);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_TaxCorrective (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', ioStatusCode;
     END CASE;

     -- Вернули статус (вдруг он не изменился)
     ioStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Манько Д.А.
 14.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_TaxCorrective (ioId:= 0, inSession:= zfCalc_UserAdmin())
