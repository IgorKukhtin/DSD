-- Function: gpInsertUpdate_Object_InfoMoneyDestination()

-- DROP FUNCTION gpInsertUpdate_Object_InfoMoneyDestination();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_InfoMoneyDestination(
INOUT ioId	         Integer   ,   	/* ключ */
IN inCode                Integer   , 
IN inName                TVarChar  ,    /* Группа управленческих аналитик */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_InfoMoneyDestination());

   -- !!! проверка прав уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_InfoMoneyDestination(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_InfoMoneyDestination(), inCode, inName);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_InfoMoneyDestination (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Contract()
