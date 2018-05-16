-- Function: gpUpdate_Status_ReturnIn()

-- DROP FUNCTION IF EXISTS gpUpdate_Status_ReturnIn (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Status_ReturnIn (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ReturnIn(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inStartDateSale       TDateTime , --
   OUT outMessageText        Text      ,
   OUT outMemberExpName      TVarChar  , -- Экспедитор из Заявки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
BEGIN

     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ReturnIn (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            outMessageText:= (SELECT tmp.outMessageText FROM gpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                                                         , inStartDateSale  := inStartDateSale
                                                                                         , inIsLastComplete := FALSE
                                                                                         , inSession        := inSession
                                                                                          ) AS tmp);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ReturnIn (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', ioStatusCode;
     END CASE;

     -- Вернули статус (вдруг он не изменился)
     ioStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

     -- Вернули "Экспедитор из Заявки стронней"
     outMemberExpName := COALESCE((SELECT Object_MemberExp.ValueData AS MemberExpName
                                  FROM MovementLinkObject AS MovementLinkObject_MemberExp
                                       LEFT JOIN Object AS Object_MemberExp ON Object_MemberExp.Id = MovementLinkObject_MemberExp.ObjectId
                                  WHERE MovementLinkObject_MemberExp.MovementId = inMovementId
                                    AND MovementLinkObject_MemberExp.DescId = zc_MovementLinkObject_MemberExp()
                                  ), '') :: TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 29.01.14                                        	        *

*/

-- тест
-- SELECT * FROM gpUpdate_Status_ReturnIn (ioId:= 0, inSession:= zfCalc_UserAdmin())