-- gpUpdate_Movement_Tax_UKTZ_new()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Tax_UKTZ_new (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Tax_UKTZ_new (
    IN inMovementId          Integer   , -- Ключ объекта <>
 INOUT ioIsUKTZ_new          Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- изменения только для zc_Enum_DocumentTaxKind_Prepay
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Tax_UKTZ_new());
    

     -- определили признак
     ioIsUKTZ_new:= NOT ioIsUKTZ_new;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_UKTZ_new(), inMovementId, ioIsUKTZ_new);


    IF vbUserId = 9457 OR vbUserId = 5
    THEN
          RAISE EXCEPTION 'Тест. Ок. <%>', ioIsUKTZ_new; 
    END IF; 
 
     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.11.23         *
*/

-- тест
--