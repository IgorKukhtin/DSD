-- Function: gpUpdate_Unit_isShareFromPrice()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isShareFromPrice(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isShareFromPrice(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisShareFromPrice    Boolean   ,    -- Делить медикаменты от цены
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShareFromPrice(), inId, not inisShareFromPrice);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.12.20                                                       *
*/