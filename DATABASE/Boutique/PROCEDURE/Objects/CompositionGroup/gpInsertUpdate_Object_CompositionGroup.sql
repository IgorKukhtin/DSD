-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- Ключ объекта <Группа для состава товара>
    IN inCode         Integer,       -- Код объекта <Группа для состава товара>
    IN inName         TVarChar,      -- Название объекта <Группа для состава товара>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!ВРЕМЕННО!!! - пытаемся найти Id  для Загрузки из Sybase - !!!но если в Sybase нет уникальности - НАДО УБРАТЬ!!!
   IF COALESCE (ioId, 0) = 0
   THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_CompositionGroup());
        -- пытаемся найти код
        inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!ВРЕМЕННО!!! - для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (inCode, 0) = 0 THEN  inCode := NEXTVAL ('Object_CompositionGroup_seq'); END IF; 


   -- проверка уникальности для <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), inCode);
   -- проверка уникальности для <Название>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CompositionGroup(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), inCode, inName);

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
-- SELECT * FROM gpInsertUpdate_Object_CompositionGroup()
