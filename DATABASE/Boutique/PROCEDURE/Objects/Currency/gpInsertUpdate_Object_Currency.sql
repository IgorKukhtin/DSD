-- Function: gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId           Integer,       -- Ключ объекта <Валюта>     
    IN inCode         Integer,       -- Код объекта <Валюта>      
    IN inName         TVarChar,      -- Название объекта <Валюта> 
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Currency_seq'); END IF; 


   -- проверка уникальности для свойства <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Currency(), inName); 
  

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Currency(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
02.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Currency()
