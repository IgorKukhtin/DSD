--Function: gpSelect_ObjectGUID(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ReplServer_load (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplServer_load(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Code              Integer
             , Name              TVarChar
             , HostName          TVarChar
             , Users             TVarChar
             , Passwords         TVarChar
             , Port              TVarChar
             , DataBases         TVarChar
             , Start_toChild     TDateTime
             , Start_fromChild   TDateTime
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат
     RETURN QUERY
        SELECT
             123                      :: Integer  AS Id
           , 1                        :: Integer  AS Code
           , 'Name - 1'               :: TVarChar AS Name
           , 'integer-srv.alan.dp.ua' :: TVarChar AS HostName
           , 'admin'                  :: TVarChar AS Users
           , 'vas6ok'                 :: TVarChar AS Passwords
           , '5432'                   :: TVarChar AS Port
           , 'project'                :: TVarChar AS DataBases
           , (CURRENT_TIMESTAMP - INTERVAL '720 MIN') :: TDateTime AS Start_toChild
           , (CURRENT_TIMESTAMP - INTERVAL '720 MIN') :: TDateTime AS Start_fromChild
       UNION ALL
        SELECT
             456                      :: Integer  AS Id
           , 2                        :: Integer  AS Code
           , 'Name - 2'               :: TVarChar AS Name
           , 'project-vds.vds.colocall.com' :: TVarChar AS HostName
           , 'admin'                  :: TVarChar AS Users
           , 'vas6ok'                 :: TVarChar AS Passwords
           , '5432'                   :: TVarChar AS Port
           , 'project'                :: TVarChar AS DataBases
           , (CURRENT_TIMESTAMP - INTERVAL '720 MIN') :: TDateTime AS Start_toChild
           , (CURRENT_TIMESTAMP - INTERVAL '720 MIN') :: TDateTime AS Start_fromChild
      ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.18                                        *
*/

-- тест
-- SELECT * FROM gpSelect_ReplServer_load  (inSession:= zfCalc_UserAdmin())
