-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2 (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2 (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_v2(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisSUN_v2            Boolean   ,    -- Работают по СУН
   OUT outisSUN_v2           Boolean   ,
    IN inDescName            TVarChar  ,    -- 
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
   outisSUN_v2:= NOT inisSUN_v2;

   PERFORM lpInsertUpdate_ObjectBoolean (ObjectBooleanDesc.Id, inId, outisSUN_v2)
   FROM ObjectBooleanDesc
   WHERE ObjectBooleanDesc.Code = inDescName;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.19         *
*/
--zc_ObjectBoolean_Unit_SUN_v2()