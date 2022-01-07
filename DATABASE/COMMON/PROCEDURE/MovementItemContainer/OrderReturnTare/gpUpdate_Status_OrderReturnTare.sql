-- Function: gpUpdate_Status_OrderReturnTare()

DROP FUNCTION IF EXISTS gpUpdate_Status_OrderReturnTare (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_OrderReturnTare(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            --
            PERFORM gpUnComplete_Movement_OrderReturnTare (inMovementId, inSession);

         WHEN zc_Enum_StatusCode_Complete() THEN
            --
            PERFORM gpComplete_Movement_OrderReturnTare (inMovementId, inSession);

         WHEN zc_Enum_StatusCode_Erased() THEN

            --
            PERFORM gpSetErased_Movement_OrderReturnTare (inMovementId, inSession);

         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *

*/

-- тест
-- SELECT * FROM gpUpdate_Status_OrderReturnTare (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
