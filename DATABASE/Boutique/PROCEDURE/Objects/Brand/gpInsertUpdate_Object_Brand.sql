-- Торговая марка

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Brand (Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Brand(
 INOUT ioId              Integer,       -- ключ объекта <Бренд>
 INOUT ioCode            Integer,       -- свойство <Код Бренда>
    IN inName            TVarChar,      -- главное Название Бренда
    IN inCountryBrandId  Integer,       -- ключ объекта <Страна производитель> 
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId:= lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Brand());

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Brand_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Brand_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- проверка уникальности для свойства <Наименование Бренда>
   IF TRIM (COALESCE (inName, '')) = ''
   THEN
       RAISE EXCEPTION 'Ошибка.Значение не может быть пустым.';
   END IF; 

   -- проверка уникальности для свойства <Наименование Бренда>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Brand(), inName); 

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Brand(), ioCode, inName);

   -- сохранили связь с <Страна производитель>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Brand_CountryBrand(), ioId, inCountryBrandId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
13.05.17                                                          *
02.03.17                                                          *
19.02.17                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Brand()
