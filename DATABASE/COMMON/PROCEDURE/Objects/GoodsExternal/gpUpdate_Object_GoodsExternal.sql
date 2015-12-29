-- Function: gpUpdate_Object_GoodsExternal()

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsExternal(Integer,Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsExternal(
    IN inId                    Integer   ,     -- ключ объекта <Товары медка> 
    IN inGoodsId               Integer   ,     -- товар
    IN inGoodsKindId           Integer   ,     -- Вид товара
    IN inSession               TVarChar        -- сессия пользователя
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_GoodsExternal());

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_Goods(), inId, inGoodsId);  
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsExternal_GoodsKind(), inId, inGoodsKindId);  


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.12.15         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_GoodsExternal(inId:=null, inCode:=null, inName:='валшг', inSession:='2')