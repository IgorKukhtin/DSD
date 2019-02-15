-- Function: gpUpdate_Object_Goods_IsGoodsCategory()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isGoodsCategory(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isGoodsCategory(
    IN inId                           Integer   ,    -- ключ объекта <Подразделение>
    IN inisGoodsCategory              Boolean   ,    -- Участвует в Автоперемещении
   OUT outisGoodsCategory             Boolean   ,
    IN inSession                      TVarChar       -- текущий пользователь
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
   outisGoodsCategory:= inisGoodsCategory;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_GoodsCategory(), inId, outisGoodsCategory);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Unit_isGoodsCategory(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.19         *
*/