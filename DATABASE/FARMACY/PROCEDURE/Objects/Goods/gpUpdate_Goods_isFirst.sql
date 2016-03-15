-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isFirst(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isFirst(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inisFirst             Boolean   ,    -- 1-выбор
   OUT outColor              Integer   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
  
   IF inisFirst = TRUE 
   THEN
      outColor = zc_Color_GreenL();
   ELSE 
      outColor = zc_Color_White();
   END IF;


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_First(), inId, inisFirst);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.03.16         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
