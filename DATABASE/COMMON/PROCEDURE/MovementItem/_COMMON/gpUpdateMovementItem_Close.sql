-- Function: gpUpdateMovementItem_Close()

DROP FUNCTION IF EXISTS gpUpdateMovementItem_Close (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovementItem_Close(
    IN inId                  Integer   , -- Ключ объекта <>
 INOUT ioisClose             Boolean   , -- Выполнено
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);  

     -- определили признак
     ioisClose:= NOT ioisClose;

     -- сохранили свойство
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Close(), inId, ioisClose);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 31.05.17         * 
*/


-- тест
-- select * from gpUpdateMovementItem_Close(inId := 76083510 , ioisClose := 'False' ,  inSession := '5');
