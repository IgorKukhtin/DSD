-- Function: gpInsertUpdate_Object_ToolsWeighing()

DROP FUNCTION IF EXISTS gpUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_ToolsWeighing(
 INOUT ioId                  Integer   ,
    IN inCode                Integer  ,
    IN inNameUser	         TVarChar  ,
    IN inValueData           TVarChar  ,
    IN inSession             TVarChar       -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbName TVarChar;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ToolsWeighing());
   vbUserId := inSession;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), inCode, inValueData);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_ToolsWeighing (Integer, Integer, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 13.03.14                                                         *

*/

-- тест
-- SELECT * FROM gpUpdate_Object_ToolsWeighing()
