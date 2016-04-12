-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSecond(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSecond(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inisSecond            Boolean   ,    -- Неприоритет-выбор
   OUT outColor        Integer   ,
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
  
   IF inisSecond = TRUE 
   THEN
      outColor = zc_Color_Red();  --16380671
   ELSE 
      outColor = zc_Color_White();
   END IF;


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Second(), inId, inisSecond);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.16         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
