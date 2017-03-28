-- Function: gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId           Integer,       -- Ключ объекта <Должности>    
    IN inCode         Integer,       -- Код объекта <Должности>     
    IN inName         TVarChar,      -- Название объекта <Должности>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Position());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Position_seq'); END IF; 

   -- проверка уникальности для свойства <Наименование Должности>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Position(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Position()
