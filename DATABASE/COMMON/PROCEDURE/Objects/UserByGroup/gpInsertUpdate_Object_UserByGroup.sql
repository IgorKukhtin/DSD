-- Function: gpInsertUpdate_Object_UserByGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UserByGroup(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UserByGroup(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Группа юр лиц>
    IN inCode                Integer   ,    -- Код объекта <Группа юр лиц>
    IN inName                TVarChar  ,    -- Название объекта <Группа юр лиц>
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   UserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_UserByGroup());

   -- Если код не установлен, определяем его как последний+1
   vbCode:= lfGet_ObjectCode (inCode, zc_Object_UserByGroup()); 
   
   -- Проверем уникальности для свойства <Название Группы>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_UserByGroup(), inName);
   -- проверка прав уникальности для свойства <Код Группы>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_UserByGroup(), vbCode);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_UserByGroup(), vbCode, inName);

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.04.22         *
*/

-- тест
--