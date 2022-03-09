-- Function: gpUpdate_Movement_OrderExternal_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_SupplierFailures(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_SupplierFailures(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisSupplierFailures  Boolean   ,    -- Отложен
   OUT outisSupplierFailures Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisSupplierFailures:=  inisSupplierFailures;

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_SupplierFailures(), inMovementId, inisSupplierFailures);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, false);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 08.03.22                                                      *
*/