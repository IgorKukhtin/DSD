-- Function: gpInsertUpdate_Object_Freight (Integer,Integer,TVarChar, TFloat,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Freight (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Freight(
 INOUT ioId              Integer   ,    -- ключ объекта <Виды топлива>
    IN inCode            Integer   ,    -- Код объекта <Виды топлива>
    IN inName            TVarChar  ,    -- Название объекта <Виды топлива>
    IN inSession         TVarChar       -- сессия пользователя
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Freight());
   vbUserId:= lpGetUserBySession (inSession);


   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Freight()); 
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Freight(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Freight(), vbCode_calc);
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Freight(), vbCode_calc, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql;
ALTER FUNCTION gpInsertUpdate_Object_Freight(Integer,Integer,TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.10.13                                        * пытаемся найти код
 24.09.13          * 
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Freight()
