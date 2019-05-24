-- Function: gpUpdate_Object_Retail_ClientKind()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_ClientKind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_ClientKind (
    IN inId                    Integer   ,  -- ключ объекта <Торговая сеть> 
    IN inClientKindId          Integer   ,  -- 
    IN inSession               TVarChar     -- сессия пользователя
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_ClientKind());

   -- сохранили связь с <Классификаторы свойств товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_ClientKind(), inId, inClientKindId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.19         *
*/

-- тест
--