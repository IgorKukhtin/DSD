-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- Ключ объекта <Группа для состава товара>
 INOUT ioCode         Integer,       -- Код объекта <Группа для состава товара>
    IN inName         TVarChar,      -- Название объекта <Группа для состава товара>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS record 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!ВРЕМЕННО!!! - пытаемся найти Id  для Загрузки из Sybase - !!!но если в Sybase нет уникальности - НАДО УБРАТЬ!!!
   IF COALESCE (ioId, 0) = 0    AND COALESCE(ioCode,0) = 0 
   THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_CompositionGroup());
        -- пытаемся найти код
        ioCode := (SELECT ObjectCode FROM Object WHERE Id = ioId);
   END IF;
   -- !!!ВРЕМЕННО!!! - для загрузки из Sybase т.к. там код = 0 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_CompositionGroup_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := coalesce((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 THEN  ioCode := NEXTVAL ('Object_CompositionGroup_seq'); 
   END IF; 


   -- проверка уникальности для <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), ioCode);
   -- проверка уникальности для <Название>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_CompositionGroup(), inName);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), ioCode, inName);

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
