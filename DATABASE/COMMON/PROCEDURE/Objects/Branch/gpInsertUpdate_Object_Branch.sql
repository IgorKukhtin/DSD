-- Function: gpInsertUpdate_Object_Branch(Integer, Integer, TVarChar, Integer, TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Branch(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Branch(
 INOUT ioId                  Integer,       -- ключ объекта <Филиал>
    IN inCode                Integer,       -- Код объекта <Филиал> 
    IN inName                TVarChar,      -- Название объекта <Филиал>
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний + 1
   vbCode_calc := lfGet_ObjectCode (inCode, zc_Object_Branch());

   -- проверка прав уникальности для свойства <Наименование Филиала>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Branch(), inName);
   -- проверка прав уникальности для свойства <Код Филиала>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Branch(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Branch(), vbCode_calc, inName
                                , inAccessKeyId:= CASE WHEN vbCode_calc = 1
                                                            THEN zc_Enum_Process_AccessKey_TrasportDnepr()
                                                       WHEN vbCode_calc = 2
                                                            THEN zc_Enum_Process_AccessKey_TrasportKiev()
                                                  END);
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Branch (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.13                                        * add inAccessKeyId
 10.05.13          *
 05.06.13          
 02.07.13                        * Убрал JuridicalId     
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Branch(1,1,'','')