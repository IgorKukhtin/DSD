-- Function: gpUpdateMovement_OrderFinance_SignSB()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_SignSB (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_SignSB(
    IN inMovementId      Integer   , -- Ключ объекта <Документ>
    IN inisSignSB        Boolean   ,
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpGetUserBySession (inSession);
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_OrderFinance_SignSB());


     -- сохранили свойство  <Виза СБ>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignSB(), inMovementId, inisSignSB);

     IF COALESCE (inisSignSB, FALSE) = TRUE
     THEN
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили свойство <Дата/время когда установили Виза СБ>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignSB(), inMovementId, NULL ::TDateTime);
     END IF;

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.01.26         *
*/

-- тест
--