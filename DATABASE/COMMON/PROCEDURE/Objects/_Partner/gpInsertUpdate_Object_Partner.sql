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
    IN inSession             TVarChar       -- текущий пользователь
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Partner());

   -- !!! Проверем уникальность имени
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_Partner(), inCode, inName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Partner_GLNCode(), ioId, inGLNCode);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Partner_Juridical(), ioId, inJuridicalId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Partner(Integer, Integer, TVarChar, TVarChar, Integer, Integer,Integer, TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Partner()
