-- Function: gpUpdate_Movement_Check_Closed()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_Closed (Integer, Boolean, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_Closed(
    IN inId                Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inisClosed          Boolean   , -- Закрыто
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    -- сохранили  <Закрыто>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inId, not inisClosed);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.03.23                                                       *
*/
-- тест
-- select * from gpUpdate_Movement_Check_Closed(inId := 7784533 , inisClosed := False ,  inSession := '3');