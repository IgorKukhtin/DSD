-- Function: gpInsertUpdate_Object_Business(Integer,Integer,TVarChar,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Business(Integer,Integer,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Business(
 INOUT ioId	                 Integer,       -- ключ объекта < Бизнес>
    IN inCode                Integer,       -- Код объекта <Бизнес>
    IN inName                TVarChar,      -- Наименование объекта <Бизнес>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Business());

   -- проверка прав уникальности для свойства Наименование объекта <Бизнес>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Business(), inName);
   -- проверка прав уникальности для свойства Код объекта <Бизнес>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Business(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Business(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION gpInsertUpdate_Object_Business (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Business(1,1,'2','2')