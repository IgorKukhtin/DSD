-- Function: gpUpdateMovement_OrderFinance_SignWait_1()

DROP FUNCTION IF EXISTS gpUpdateMovement_OrderFinance_SignWait_1 (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_OrderFinance_SignWait_1(
    IN inMovementId          Integer   , -- Ключ объекта <Документ> 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили свойство  <Состояние Ожидание Согласования-1>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SignWait_1(), inMovementId, TRUE);
 
     -- сохранили свойство <Дата/время когда переведен в Состояние Ожидание Согласования>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_SignWait_1(), inMovementId, CURRENT_TIMESTAMP);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);


  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.11.25         *
*/


-- тест
--