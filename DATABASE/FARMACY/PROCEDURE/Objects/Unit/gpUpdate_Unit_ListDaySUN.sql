-- Function: gpUpdate_Unit_ListDaySUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ListDaySUN(Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_ListDaySUN(
    IN inId             Integer   ,    -- ключ объекта <подразделение>
    IN inListDaySUN     TVarChar   ,    -- 
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- По каким дням недели по СУН
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Unit_ListDaySUN(), inId, inListDaySUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.04.20                                                       *

*/
--