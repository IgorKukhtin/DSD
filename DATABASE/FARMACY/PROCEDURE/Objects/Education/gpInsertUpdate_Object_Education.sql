-- Function: gpInsertUpdate_Object_Education()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Education(Integer ,Integer , TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Education(
 INOUT ioId	                 Integer   ,    -- ключ объекта <Должности> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта
    IN inNameUkr             TVarChar  ,    -- Наименование на Украинском языке
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Education());
   vbUserId := inSession;
   
   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Education());
   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Education(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Education(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Education(), vbCode_calc, inName);

   -- сохранили Наименование на Украинском языке
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Education_NameUkr(), ioId, inNameUkr);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Education(Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.01.16         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Education()