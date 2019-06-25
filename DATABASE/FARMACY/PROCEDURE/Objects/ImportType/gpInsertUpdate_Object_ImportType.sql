-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportType (Integer, Integer, TVarChar, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportType(
 INOUT ioId                      Integer   ,   	-- ключ объекта <Договор>
    IN inCode                    Integer   ,    -- Код объекта <>
    IN inName                    TVarChar  ,    -- Название объекта <>
    IN inProcedureName           TVarChar  ,    --  
    IN inJSONParamName           TVarChar  ,    -- название параметра JSON 
    IN inSession                 TVarChar       -- сессия пользователя
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;  

BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 

   -- Если код не установлен, определяем его как последний+1 
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_ImportType());

   
   -- проверка уникальности <Наименование>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_ImportType(), inName);
   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ImportType(), vbCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportType(), vbCode, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportType_ProcedureName(), ioId, inProcedureName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ImportType_JSONParamName(), ioId, inJSONParamName);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportType (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Подмогильный В.В.
 09.02.18                                                           *               
 02.07.14         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
