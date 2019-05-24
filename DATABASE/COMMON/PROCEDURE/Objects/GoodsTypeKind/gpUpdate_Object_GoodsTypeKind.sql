
-- Function: gpUpdate_Object_GoodsTypeKind  (Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsTypeKind (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsTypeKind(
    IN inId                Integer   ,    -- ключ объекта <> 
    IN inShortName         TVarChar  ,    -- 
    IN inSession           TVarChar       -- сессия пользователя
)
 RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_GoodsTypeKind());
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsTypeKind_ShortName(), inId, inShortName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.05.19         * 
*/

-- тест
--