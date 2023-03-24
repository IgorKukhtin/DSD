-- Function: gpUpdate_Movement_EDI_VchasnoEDI()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDI_VchasnoEDI (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDI_VchasnoEDI(
    IN inMovementId          Integer    , -- Ключ объекта <Документ>
    IN inDealId              TVarChar   , -- внутрішній ІД замовлення у системі
    IN inSession             TVarChar     -- Пользователь
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDI_Params());
     vbUserId:= lpGetUserBySession (inSession);

     -- сохранили DealId внутрішній ІД замовлення у системі
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_DealId(), inMovementId, inDealId);

     -- сохранили
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isLoad(), inMovementId, True);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.03.23                                                       * 
*/

-- тест
-- SELECT * FROM gpUpdate_Movement_EDI_VchasnoEDI (inMovementId:= 10, inisLoad:= False, inSession:= '2')