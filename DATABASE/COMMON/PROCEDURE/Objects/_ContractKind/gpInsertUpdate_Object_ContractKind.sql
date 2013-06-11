-- Function: gpInsertUpdate_Object_ContractKind()

-- DROP FUNCTION gpInsertUpdate_Object_ContractKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractKind(
INOUT ioId	                Integer,       -- ключ объекта <Виды договоров>
   IN inCode                Integer   ,    -- Код объекта <Виды договоров>
   IN inName                TVarChar  ,    -- Название объекта <Виды договоров>
   IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());
   UserId := inSession;
   
   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_ContractKind();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Виды Договора>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_ContractKind(), inName);
   -- проверка прав уникальности для свойства <Код Вида Договора>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractKind(), Code_max);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ContractKind(), Code_max, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ContractKind (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 03.06.13          
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Route()
  
                            