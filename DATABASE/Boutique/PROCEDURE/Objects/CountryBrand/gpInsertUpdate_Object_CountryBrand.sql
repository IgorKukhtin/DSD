-- Function: gpInsertUpdate_Object_CountryBrand (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CountryBrand (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CountryBrand(
 INOUT ioId           Integer,       -- Ключ объекта <Страна производитель>
    IN inCode         Integer,       -- Код Объекта <Страна производитель>
    IN inName         TVarChar,      -- Название объекта <Страна производитель>
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS integer 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CountryBrand());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его как последний+1
   Code_max:=lfGet_ObjectCode (inCode, zc_Object_CountryBrand()); 

   -- проверка уникальности для свойства <Наименование Страна производитель>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CountryBrand(), inName);
   -- проверка уникальности для свойства <Код Страна производитель>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CountryBrand(), Code_max);



   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CountryBrand(), Code_max, inName);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

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
