-- Function: gpInsertUpdate_Object_Business(Integer,Integer,TVarChar,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Business(Integer,Integer,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Business(
 INOUT ioId	             Integer,       -- ключ объекта < Бизнес>
    IN inCode                Integer,       -- Код объекта <Бизнес>
    IN inName                TVarChar,      -- Наименование объекта <Бизнес>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;   

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Business());
   vbUserId:= lpGetUserBySession (inSession);

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Business();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- проверка прав уникальности для свойства Наименование объекта <Бизнес>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Business(), inName);
   -- проверка прав уникальности для свойства Код объекта <Бизнес>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Business(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Business(), Code_max, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION gpInsertUpdate_Object_Business (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.06.13          *
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Business(1,1,'2','2')