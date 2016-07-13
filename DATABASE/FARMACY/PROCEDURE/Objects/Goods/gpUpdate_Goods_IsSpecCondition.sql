-- Function: gpUpdate_Object_Goods_IsSpecCondition()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSpecCondition(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IsSpecCondition(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inisSpecCondition     Boolean   ,    -- Товар под спец услдовия
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisSpecCondition Boolean;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

    -- Получаем сохраненное значение св-ва
    vbisSpecCondition:=COALESCE((SELECT ObjectFloat.ValueData FROM ObjectBoolean WHERE ObjectBoolean.DescId = zc_ObjectBoolean_Goods_SpecCondition() AND ObjectBoolean.ObjectId = inId),0);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SpecCondition(), inId, inisSpecCondition);


   IF COALESCE(inisSpecCondition,0) <> vbisSpecCondition
   THEN
       -- сохранили свойство <Дата корр.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);
       -- сохранили свойство <Пользователь (корр.)>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), inId, inUserId);
   END If;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_isSpecCondition(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 18.02.16         *

*/