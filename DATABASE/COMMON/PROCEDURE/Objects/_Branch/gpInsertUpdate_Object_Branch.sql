-- Function: gpInsertUpdate_Object_Branch(Integer, Integer, TVarChar, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Branch(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Branch(
 INOUT ioId	                 Integer,       -- ключ объекта < Филиал>
    IN inCode                Integer,       -- Код объекта <Филиал> 
    IN inName                TVarChar,      -- Название объекта <Филиал>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Branch());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   inCode := lfGet_ObjectCode(inCode, zc_Object_Branch());

   -- проверка прав уникальности для свойства <Наименование Филиала>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Branch(), inName);
   -- проверка прав уникальности для свойства <Код Филиала>
   PERFORM lpCheckUnique_Object_ObjectCode(ioId, zc_Object_Branch(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Branch(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.05.13          *
 05.06.13          
 02.07.13                        * Убрал JuridicalId     
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Branch(1,1,'','')