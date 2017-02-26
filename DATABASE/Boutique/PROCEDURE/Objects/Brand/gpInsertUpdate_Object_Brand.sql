-- Function: gpInsertUpdate_Object_Brand (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Brand (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Brand(
 INOUT ioId           Integer,       -- ключ объекта <Бренд>
    IN inCode         Integer,       -- свойство <Код Бренда>
    IN inName         TVarChar,      -- главное Название Бренда
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbCode_max Integer;

BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   vbCode_max:=lfGet_ObjectCode (inCode, zc_Object_Brand()); 

   -- проверка уникальности для свойства <Наименование Бренда>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Brand(), inName); 
   -- проверка уникальности для свойства <Код Бренда>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Brand(), vbCode_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Brand(), vbCode_max, inName);

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
-- SELECT * FROM gpInsertUpdate_Object_Brand()
