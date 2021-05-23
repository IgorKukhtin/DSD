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
   vbUserId:= lpGetUserBySession (inSession);


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ToolsWeighing(), inCode, inValueData);

   -- сохранили
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), ioId, inNameUser);

   -- сохранили остальным
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ToolsWeighing_NameUser(), OS_ToolsWeighing_Name_find.ObjectId, inNameUser)
   FROM ObjectString AS OS_ToolsWeighing_Name
        INNER JOIN ObjectString AS OS_ToolsWeighing_Name_find
                                ON OS_ToolsWeighing_Name_find.ValueData = OS_ToolsWeighing_Name.ValueData
                               AND OS_ToolsWeighing_Name_find.DescId = zc_ObjectString_ToolsWeighing_Name()
                               AND OS_ToolsWeighing_Name_find.ObjectId <> OS_ToolsWeighing_Name.ObjectId
   WHERE OS_ToolsWeighing_Name.ObjectId = ioId
     AND OS_ToolsWeighing_Name.DescId = zc_ObjectString_ToolsWeighing_Name();


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   -- сохранили протокол - остальным
   PERFORM lpInsert_ObjectProtocol (OS_ToolsWeighing_Name_find.ObjectId, vbUserId)
   FROM ObjectString AS OS_ToolsWeighing_Name
        INNER JOIN ObjectString AS OS_ToolsWeighing_Name_find
                                ON OS_ToolsWeighing_Name_find.ValueData = OS_ToolsWeighing_Name.ValueData
                               AND OS_ToolsWeighing_Name_find.DescId    = zc_ObjectString_ToolsWeighing_Name()
                               AND OS_ToolsWeighing_Name_find.ObjectId <> OS_ToolsWeighing_Name.ObjectId
   WHERE OS_ToolsWeighing_Name.ObjectId = ioId
     AND OS_ToolsWeighing_Name.DescId = zc_ObjectString_ToolsWeighing_Name();


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
