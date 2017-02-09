-- Function: gpInsertUpdate_Object_Advertising(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Advertising(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Advertising(
 INOUT ioId	                 Integer,       -- ключ объекта < Банк>
    IN inCode                Integer,       -- Код объекта <Банк>
    IN inName                TVarChar,      -- Название объекта <Банк>
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Advertising());
   vbUserId := lpGetUserBySession(inSession);
   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Advertising());


   -- проверка прав уникальности для свойства <Наименование рекламной поддержки>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Advertising(), inName);
   -- проверка прав уникальности для свойства <Код рекламной поддержки>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Advertising(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Advertising(), vbCode_calc, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Advertising (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 31.10.15                                                                      *
 */

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Advertising ()
                            