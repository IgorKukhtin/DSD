-- Function: gpInsertUpdate_Object_CarModel()

-- DROP FUNCTION gpInsertUpdate_Object_CarModel();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarModel(
 INOUT ioId	            Integer   ,     -- ключ объекта < Марки Автомобиля> 
    IN inCode           Integer   ,     -- Код объекта <Марки Автомобиля> 
    IN inName           TVarChar  ,     -- Название объекта <Марки Автомобиля>
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
   
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CarModel());

   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_CarModel();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства <Наименование Марки Автомобиля>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarModel(), inName);
   -- проверка прав уникальности для свойства <Код Марки Автомобиля>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarModel(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CarModel(), Code_max, inName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_CarModel (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 03.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CarModel()