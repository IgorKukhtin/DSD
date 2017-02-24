-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- Ключ объекта <Группа для состава товара>
    IN inCode         Integer,       -- Код объекта <Группа для состава товара>
    IN inName         TVarChar,      -- Название объекта <Группа для состава товара>
    IN inSession      TVarChar       -- сессия пользователя
)
  RETURNS integer 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;

BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Composition());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_CompositionGroup()); 

   -- проверка уникальности для свойства <Наименование >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CompositionGroup(), inName);
   -- проверка уникальности для свойства <Код >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), vbCode_max, inName);

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
