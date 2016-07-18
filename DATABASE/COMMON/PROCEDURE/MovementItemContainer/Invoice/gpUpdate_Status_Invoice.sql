-- Function: gpUpdate_Status_Invoice()

DROP FUNCTION IF EXISTS gpUpdate_Status_Invoice (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_Invoice(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inStatusCode          Integer   , -- Статус документа. Возвращается который должен быть
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
BEGIN

     CASE inStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            -- проверка прав пользователя на вызов процедуры
            PERFORM lpCheckRight (inSession, zc_Enum_Process_UnComplete_Invoice());
            --
            PERFORM gpUnComplete_Movement (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            -- проверка прав пользователя на вызов процедуры
            PERFORM lpCheckRight (inSession, zc_Enum_Process_Complete_Invoice());
            --
            PERFORM gpComplete_Movement_Invoice (inMovementId, FALSE, inSession);
         WHEN zc_Enum_StatusCode_Erased() THEN
            -- проверка прав пользователя на вызов процедуры
            PERFORM lpCheckRight (inSession, zc_Enum_Process_SetErased_Invoice());
            --
            PERFORM gpSetErased_Movement (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION 'Нет статуса с кодом <%>', inStatusCode;
     END CASE;
     
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.07.16         *

*/

-- тест
-- SELECT * FROM gpUpdate_Status_Invoice (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inAmount:= 20, inFromId:= 1, inToId:= 1, inPaidKindId:= 1,  inInfoMoneyId:= 0, inUnitId:= 0, inServiceDate:= '01.01.2013', inSession:= '2')
