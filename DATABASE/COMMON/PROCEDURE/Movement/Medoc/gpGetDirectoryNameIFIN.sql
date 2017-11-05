-- Function: gpGetDirectoryNameIFIN()

DROP FUNCTION IF EXISTS gpGetDirectoryNameIFIN (TVarChar);

CREATE OR REPLACE FUNCTION gpGetDirectoryNameIFIN(
       OUT Directory             TVarChar, 
        IN inSession             TVarChar       -- текущий пользователь
      )
RETURNS TVarChar
AS
$BODY$
DECLARE
   DECLARE vbUserId Integer;
BEGIN
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   IF EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0)
   OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 131936) -- Хлеб
   THEN
       Directory := 'c:\IFIN\'
                 || COALESCE ((SELECT '(' || ObjectCode :: TVarChar || ')'  || ValueData FROM Object where Id = vbUserId), '')
                 || '\';
   ELSE
       Directory := '\\Axf\общая\'
                 || COALESCE ((SELECT '(' || ObjectCode :: TVarChar || ')'  || ValueData FROM Object where Id = vbUserId), '')
                 || '\IFIN\data\';
   END IF;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetDirectoryNameIFIN (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.11.17                                        *
*/

-- тест
-- SELECT * FROM gpGetDirectoryNameIFIN('5')

