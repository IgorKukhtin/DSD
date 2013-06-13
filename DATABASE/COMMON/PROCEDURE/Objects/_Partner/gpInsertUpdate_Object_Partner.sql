-- Function: gpInsertUpdate_Object_Partner()

-- DROP FUNCTION gpInsertUpdate_Object_Partner();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Partner(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Контрагент> 
    IN inCode                Integer   ,    -- код объекта <Контрагент> 
    IN inName                TVarChar  ,    -- Название объекта <Контрагент>
    IN inGLNCode             TVarChar  ,    -- Код GLN
    IN inJuridicalId         Integer   ,    -- Юридическое лицо
    IN inRouteId             Integer   ,    -- Маршрут
    IN inRouteSortingId      Integer   ,    -- Сортировка маршрутов
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
 
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());
   UserId := inSession;

   -- Если код не установлен, определяем его как последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Route();
   ELSE
       Code_max := inCode;
   END IF; 
   
   -- !!! Проверем уникальность имени
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);

   -- проверка уникальности для свойства <Наименование Контрагента>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Partner(), inName);
   -- проверка уникальности для свойства <Код Контрагента>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), Code_max, inName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Partner(Integer, Integer, TVarChar, TVarChar, Integer, Integer,Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.06.13          *
 14.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
