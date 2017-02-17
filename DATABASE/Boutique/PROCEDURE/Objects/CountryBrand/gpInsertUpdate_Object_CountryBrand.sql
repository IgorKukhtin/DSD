-- Function: gpInsertUpdate_Object_CountryBrand (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CountryBrand (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CountryBrand(
 INOUT ioId           Integer,       -- ключ объекта <Страна производитель>
    IN inCode         Integer,       -- свойство <Код Страна производитель>
    IN inName         TVarChar,      -- главное Название Страна производитель
    IN inSession      TVarChar       -- сессия пользователя
)
  RETURNS integer 
  AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CountryBrand());
   UserId := inSession;

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_CountryBrand();
   ELSE
       Code_max := inCode;
   END IF;

   -- проверка уникальности для свойства <Наименование Страна производитель>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CountryBrand(), inName); --!!!временно откл.!!! 
   -- проверка уникальности для свойства <Код Страна производитель>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CountryBrand(), Code_max);



   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CountryBrand(), Code_max, inName);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
17.02.17                                                          *


*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_CountryBrand()
