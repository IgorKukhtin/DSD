-- Function: gpInsertUpdate_Object_ContractTagKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractTagKind(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractTagKind(
 INOUT ioId                  Integer   ,     -- ключ объекта <Признак товара> 
    IN inCode                Integer   ,     -- Код объекта  
    IN inName                TVarChar  ,     -- Название объекта 
    IN inSession             TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractTagKind());
   vbUserId:= lpGetUserBySession (inSession);


   -- Если код не установлен, определяем его каи последний+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_ContractTagKind());
      
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractTagKind(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractTagKind(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractTagKind(), inCode, inName);
   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.08.26         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ContractTagKind(ioId:=null, inCode:=null, inName:='Торговая сеть 1', inSession:='2')
