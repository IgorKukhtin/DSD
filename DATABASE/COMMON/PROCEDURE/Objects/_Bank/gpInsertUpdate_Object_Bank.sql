-- Function: gpInsertUpdate_Object_Bank(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar)

-- DROP FUNCTION gpInsertUpdate_Object_Bank(Integer,Integer,TVarChar,TVarChar,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Bank(
 INOUT ioId	                 Integer,       -- ключ объекта < Банк>
    IN inCode                Integer,       -- Код объекта <Банк>
    IN inName                TVarChar,      -- Название объекта <Банк>
    IN inMFO                 TVarChar,      -- МФО
    IN inJuridicalId         Integer,       -- Юр. лицо
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Bank());

   -- проверка прав уникальности для свойства <Наименование Банка>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Bank(), inName);
   -- проверка прав уникальности для свойства <МФО>
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_Object_Bank(), inMFO);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_ObjectString_Bank_MFO(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Bank_MFO(), ioId, inMFO);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Bank_Juridical(), ioId, inJuridicalId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


ALTER FUNCTION gpInsertUpdate_Object_Bank (Integer,Integer,TVarChar,TVarChar,Integer,TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.06.13          

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Bank ()
                            