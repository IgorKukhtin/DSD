-- Function: gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId           Integer,       -- Ключ объекта <Единицы измерения>    
    IN inCode         Integer,       -- Код объекта <Единицы измерения>     
    IN inName         TVarChar,      -- Название объекта <Единицы измерения>
    IN inInternalCode TVarChar,      -- Международный код
    IN inInternalName TVarChar,      -- Международное наименование
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
   vbUserId:= lpGetUserBySession (inSession);
  
   -- проверка уникальности для свойства <Наименование Единицы измерения>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), inCode, inName);
   -- сохранили Международный код
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalCode(), ioId, inInternalCode);
   -- сохранили Международное наименование
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalName(), ioId, inInternalName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
16.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Measure()
