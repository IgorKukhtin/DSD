-- Function: gpUpdate_Object_Goods_IsHOT()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isNOT(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isNOT(
    IN inId        Integer   ,    -- ключ объекта <Товар>
    IN inisNOT     Boolean   ,    -- НОТ-неперемещаемый остаток
    IN inSession   TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили св-во
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NOT(), inId, inisNOT);

   outisNOT:=
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.10.19         * 
*/