-- Function: gpUpdate_Unit_ListDaySUN_pi()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ListDaySUN_pi(Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ListDaySUN_pi(
    IN inId                Integer   ,    -- ключ объекта <подразделение>
    IN inListDaySUN_pi     TVarChar  ,    -- 
    IN inSession           TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- По каким дням недели по СУН2
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN_pi(), inId, inListDaySUN_pi);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.20         *
*/
--