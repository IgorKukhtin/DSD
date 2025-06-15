-- Function: gpGet_Object_EmailSettings()

DROP FUNCTION IF EXISTS gpGet_Object_EmailSettings(Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_EmailSettings(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_EmailSettings(
    IN inEmailKindId   Integer   ,
    IN inOrderNumber   TVarChar  ,
   OUT outHostName     TVarChar  ,
   OUT outTokenValue   TVarChar  ,
    IN inSession       TVarChar       -- сессия пользователя
)
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_EmailSettings());

   RETURN QUERY 
    WITH tmpEmailSettings AS (SELECT * FROM gpSelect_Object_EmailSettings (inEmailKindId:= CASE WHEN inOrderNumber <> '' THEN zc_Enum_EmailKind_HTTP_OrderClient() ELSE inEmailKindId END, inSession:= inSession)
                             )
       --
       SELECT (CASE WHEN tmpEmailSettings_Host.Value <> '' THEN tmpEmailSettings_Host.Value ELSE tmpEmailSettings_Mail.Value     END || inOrderNumber) :: TVarChar AS HostName
            , CASE WHEN tmpEmailSettings_User.Value <> '' THEN tmpEmailSettings_User.Value ELSE tmpEmailSettings_Password.Value END :: TVarChar AS TokenValue
             
       FROM (SELECT 1) AS tmp
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Host     ON tmpEmailSettings_Host.EmailToolsId     = zc_Enum_EmailTools_Host()
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Mail     ON tmpEmailSettings_Mail.EmailToolsId     = zc_Enum_EmailTools_Mail()
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_User     ON tmpEmailSettings_User.EmailToolsId     = zc_Enum_EmailTools_User()
            LEFT JOIN tmpEmailSettings AS tmpEmailSettings_Password ON tmpEmailSettings_Password.EmailToolsId = zc_Enum_EmailTools_Password()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.25                                        *
*/

-- тест
-- SELECT * FROM gpGet_Object_EmailSettings (inEmailKindId:= 0, inOrderNumber:= '12345', inSession:= '5')
