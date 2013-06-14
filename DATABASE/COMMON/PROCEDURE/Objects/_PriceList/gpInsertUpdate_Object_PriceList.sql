-- Function: gpInsertUpdate_Object_PriceList()

-- DROP FUNCTION gpInsertUpdate_Object_PriceList();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
 INOUT ioId	           Integer   ,     -- ключ объекта <Прайс листы> 
    IN inCode          Integer   ,     -- Код объекта <Прайс листы> 
    IN inName          TVarChar  ,     -- Название объекта <Прайс листы> 
    IN inSession       TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_PriceList();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Прайс листа>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);
   -- проверка прав уникальности для свойства <Код Прайс листа>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PriceList(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_PriceList(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_PriceList (Integer, Integer, TVarChar, TVarChar)
      OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.06.13          *
 00.06.13

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PriceList()