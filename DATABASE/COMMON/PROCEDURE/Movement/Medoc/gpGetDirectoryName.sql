-- Function: gpGetDirectoryName()

DROP FUNCTION IF EXISTS gpGetDirectoryName (TVarChar);

CREATE OR REPLACE FUNCTION gpGetDirectoryName(
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
       Directory := 'c:\medoc\data\'
                 || COALESCE ((SELECT '(' || ObjectCode :: TVarChar || ')'  || ValueData FROM Object where Id = vbUserId), '')
                 || '\';
   ELSE
       Directory := '\\Axf\общая\'
                 || COALESCE ((SELECT '(' || ObjectCode :: TVarChar || ')'  || ValueData FROM Object where Id = vbUserId), '')
                 || '\medoc\data\';
   END IF;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGetDirectoryName (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.03.15                                        * add Object_RoleAccessKeyGuide_View...
*/

-- тест
-- SELECT * FROM gpGetDirectoryName('5')

