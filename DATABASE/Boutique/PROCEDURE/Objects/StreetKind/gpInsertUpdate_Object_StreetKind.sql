-- Function: gpInsertUpdate_Object_StreetKind(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_StreetKind(Integer,Integer,TVarChar,TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_StreetKind(
 INOUT ioId	             Integer,       -- ключ объекта <Вид (улица, проспект)>
    IN inCode                Integer,       -- Код объекта <>
    IN inName                TVarChar,      -- Название объекта <>
    IN inShortName           TVarChar,      -- короткое наименование
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;  
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_StreetKind());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_StreetKind());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_StreetKind(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_StreetKind(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_StreetKind(), vbCode_calc, inName);

   -- сохранили св-во <Короткое наименование>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_StreetKind_ShortName(), ioId, inShortName);
      
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_StreetKind (Integer,Integer,TVarChar,TVarChar,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.11.14         * add ShortName               
 31.05.14         * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_StreetKind ()
