-- Фабрика производитель

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fabrika(
 INOUT ioId           Integer,       -- Ключ объекта <Фабрика производитель>             
 INOUT ioCode         Integer,       -- Код объекта <Фабрика производитель>              
    IN inName         TVarChar,      -- Название объекта <Фабрика производитель>         
    IN inSession      TVarChar       -- сессия пользователя                      
)                                    
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Fabrika());
   

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Fabrika_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Fabrika_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 
 
   -- проверка уникальности для свойства <Наименование Fabrika>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fabrika(), inName); 
   -- проверка уникальности для свойства <Код Fabrika>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fabrika(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fabrika(), ioCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
13.05.17                                                          *
08.05.17                                                          *
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Fabrika()
