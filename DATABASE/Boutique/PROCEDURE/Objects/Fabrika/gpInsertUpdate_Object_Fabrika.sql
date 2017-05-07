-- Фабрика производитель

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fabrika(
 INOUT ioId           Integer,       -- Ключ объекта <Фабрика производитель>             
    IN inCode         Integer,       -- Код объекта <Фабрика производитель>              
    IN inName         TVarChar,      -- Название объекта <Фабрика производитель>         
    IN inSession      TVarChar       -- сессия пользователя                      
)                                    
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Fabrika());
   vbUserId:= lpGetUserBySession (inSession);

    -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Fabrika_seq'); END IF; 
 
   -- проверка уникальности для свойства <Наименование Fabrika>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fabrika(), inName); 
   -- проверка уникальности для свойства <Код Fabrika>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fabrika(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fabrika(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Fabrika()
