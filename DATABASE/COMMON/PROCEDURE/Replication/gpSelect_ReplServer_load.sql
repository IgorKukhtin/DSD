-- настройки Серверов - для Коннекта - куда будут переброшены данные

DROP FUNCTION IF EXISTS gpSelect_ReplServer_load (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_ReplServer_load (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReplServer_load(
    IN gConnectHost       TVarChar,      -- виртуальный, что б в exe - использовать другой сервак
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
             , OID_last          Integer -- BigInt
              )
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PaidKind());


     -- Результат
     RETURN QUERY
        SELECT
             gpSelect.Id
           , gpSelect.Code
           , gpSelect.Name
           , gpSelect.Host      AS HostName
           , gpSelect.UserName  AS Users
           , gpSelect.Password  AS Passwords
           , gpSelect.Port
           , gpSelect.DataBaseName AS DataBases
           , COALESCE (gpSelect.StartTo,   CURRENT_TIMESTAMP - INTERVAL '1 DAY') :: TDateTime AS Start_toChild
           , COALESCE (gpSelect.StartFrom, CURRENT_TIMESTAMP - INTERVAL '1 DAY') :: TDateTime AS Start_fromChild
           , gpSelect.OID_last
        FROM gpSelect_Object_ReplServer (inSession) AS gpSelect
        WHERE gpSelect.isErased = FALSE
        ORDER BY 2
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
-- SELECT * FROM gpSelect_ReplServer_load  (gConnectHost:= '', inSession:= zfCalc_UserAdmin())
