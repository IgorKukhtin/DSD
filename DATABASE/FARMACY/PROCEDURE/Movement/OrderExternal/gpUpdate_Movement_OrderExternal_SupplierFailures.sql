-- Function: gpUpdate_Movement_OrderExternal_SupplierFailures()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderExternal_SupplierFailures(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderExternal_SupplierFailures(
    IN inMovementId           Integer   ,    -- ключ документа
    IN inisSupplierFailures   Boolean   ,    -- Загружен отказ
   OUT outisSupplierFailures  Boolean   ,
    IN inSession              TVarChar       -- текущий пользователь
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
   
   IF NOT EXISTS (SELECT 1
                  FROM MovementBoolean
                  WHERE MovementBoolean.MovementId = inMovementId
                    AND MovementBoolean.DescId     = zc_MovementBoolean_SupplierFailures()
                    AND MovementBoolean.ValueData  = outisSupplierFailures)
   THEN

     PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_SupplierFailures(), inMovementId, outisSupplierFailures);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, false);
   END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 29.09.22                                                      *
 08.03.22                                                      *
*/