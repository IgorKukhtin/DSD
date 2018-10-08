-- Function: gpUpdateMovement_Calculated()

DROP FUNCTION IF EXISTS gpUpdateMovement_Calculated (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Calculated(
    IN inId                  Integer   , -- Ключ объекта <Документ>
 INOUT ioisCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= inSession;

     -- определили признак
     ioisCalculated:= NOT ioisCalculated;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Calculated(), inId, ioisCalculated);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.10.18         * 
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Calculated (inId:= 275079, ioisCalculated:= 'False', inSession:= '2')
