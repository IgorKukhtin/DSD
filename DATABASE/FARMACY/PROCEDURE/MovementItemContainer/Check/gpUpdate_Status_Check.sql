-- Function: gpUpdate_Status_Check()

DROP FUNCTION IF EXISTS gpUpdate_Status_Check (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Check(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
    DECLARE vbPaidType Integer;
    DECLARE vbCashRegisterId Integer;
BEGIN
     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete()
              THEN PERFORM gpUnComplete_Movement_Check (inMovementId, inSession, inSession);

         WHEN zc_Enum_StatusCode_Complete()
              THEN BEGIN
                -- Определить
                SELECT CASE WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Cash()
                                 THEN 0
                            WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_Card()
                                 THEN 1
                            WHEN MovementLinkObject_PaidType.ObjectId = zc_Enum_PaidType_CardAdd()
                                 THEN 2
                       END as PaidType 
                     , Movement_Check.CashRegisterId

                       INTO vbPaidType, vbCashRegisterId

                FROM Movement_Check_View AS Movement_Check 
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidType
                                                  ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                                 AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
                WHERE Movement_Check.Id =  inMovementId;

                -- формируются проводки
                outMessageText:= gpComplete_Movement_CheckAdmin (inMovementId, vbPaidType, vbCashRegisterId, inSession);

              END;   

         WHEN zc_Enum_StatusCode_Erased()
              THEN PERFORM gpSetErased_Movement_Check (inMovementId, inSession);

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 22.11.14                                                                   *
 03.07.14                                                       *
*/

-- тест
-- SELECT * FROM gpUpdate_Status_Income (ioId:= 0, inSession:= zfCalc_UserAdmin())
