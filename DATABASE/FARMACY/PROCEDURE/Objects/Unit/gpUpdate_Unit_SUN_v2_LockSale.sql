-- Function: gpUpdate_Unit_SUN_v2_LockSale()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SUN_v2_LockSale(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SUN_v2_LockSale(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisSUN_v2_LockSale   Boolean   ,    -- Участвует в Автоперемещении
   OUT outisSUN_v2_LockSale  Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisSUN_v2_LockSale:= NOT inisSUN_v2_LockSale;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_LockSale(), inId, outisSUN_v2_LockSale);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.05.20         *
*/