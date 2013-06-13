-- Function: gpInsertUpdate_Object_Measure()

-- DROP FUNCTION gpInsertUpdate_Object_Measure();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId	         Integer,   	-- ключ объекта <Единица измерения> 
    IN inCode        Integer,       -- свойство <Код Единицы измерения> 
    IN inName        TVarChar,      -- главное Название Единицы измерения
    IN inSession     TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
 
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Measure();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка уникальности для свойства <Наименование Единицы измерения>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName);
   -- проверка уникальности для свойства <Код Единицы измерения>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Measure(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.13          *
 00.06.13
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Measure()
  
                            