-- Function: gpInsertUpdate_Object_GoodsKindNew()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsKindNew(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKindNew(
 INOUT ioId	                 Integer   ,   	-- ключ объекта < Тип товара> 
    IN inCode                Integer   ,    -- Код объекта <Тип товара> 
    IN inName                TVarChar  ,    -- Название объекта <Тип товара>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;  
   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsKindNew());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_GoodsKindNew());
   
   -- проверка прав уникальности для свойства <Наименование Типа Товара>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsKindNew(), inName);
   -- проверка прав уникальности для свойства <Код Типа Товара>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKindNew(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKindNew(), inCode, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsKindNew (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
  
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.22         *
*/

-- тест
--