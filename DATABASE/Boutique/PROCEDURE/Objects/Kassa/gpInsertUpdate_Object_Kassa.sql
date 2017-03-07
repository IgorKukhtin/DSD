-- Function: gpInsertUpdate_Object_Kassa (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Kassa (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Kassa(
 INOUT ioId           Integer,       -- Ключ объекта <Касса>         
    IN inCode         Integer,       -- Код объекта <Касса>          
    IN inName         TVarChar,      -- Название объекта <Касса>     
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Kassa());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Measure_seq'); END IF; 

   -- проверка уникальности для свойства <Наименование Kassa>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Kassa(), inName); 
   -- проверка уникальности для свойства <Код Kassa>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Kassa(), inCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Kassa(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
06.03.17                                                          *
20.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Kassa()
