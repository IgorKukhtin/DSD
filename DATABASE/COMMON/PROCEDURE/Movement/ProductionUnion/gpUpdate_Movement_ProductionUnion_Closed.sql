-- Function: gpUpdate_Movement_ProductionUnion_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Closed (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Closed(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inisClosed            Boolean   , --
   OUT outClosed             Boolean   , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProductionUnion());
     vbUserId:= lpGetUserBySession (inSession);

     -- определили признак
     outClosed := not inisClosed;

     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inId, outClosed);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.03.22          *
*/

-- тест
--  