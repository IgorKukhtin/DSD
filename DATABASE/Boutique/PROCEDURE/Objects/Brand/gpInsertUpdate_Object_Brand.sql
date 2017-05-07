-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Brand (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Brand(
 INOUT ioId              Integer,       -- ключ объекта <Бренд>
    IN inCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
    IN inCountryBrandId  Integer,       -- ключ объекта <Страна производитель> 
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Brand());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Brand_seq'); END IF; 


   -- проверка уникальности для свойства <Наименование Бренда>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Brand(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Brand(), inCode, inName);

   -- сохранили связь с <Страна производитель>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Brand_CountryBrand(), ioId, inCountryBrandId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
02.03.17                                                          *
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Brand()
