-- Function: gpUpdate_Goods_isSP()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSP(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSP(
    IN inId                Integer   ,    -- ключ объекта <Товар>
    IN inisSP              Boolean   ,    -- Участвует в Соц. проекте
   OUT outisSP             Boolean   ,
    IN inSession           TVarChar       -- текущий пользователь
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
   outisSP:= NOT inisSP;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SP(), inId, outisSP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 19.12.16         *

*/