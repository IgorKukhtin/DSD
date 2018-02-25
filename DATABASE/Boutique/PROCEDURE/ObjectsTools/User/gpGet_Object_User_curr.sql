-- Function: gpGet_Object_User_curr()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsPrint_User (TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_User_curr (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_curr(
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (UserId Integer
             , UserName TVarChar
              ) 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- Результат
      RETURN QUERY
      SELECT COALESCE (vbUserId, 0)               :: Integer  AS UserId
           , lfGet_Object_ValueData_sh (vbUserId) :: TVarChar AS UserName
      ; 
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Ярошенко Р.Ф.
 24.02.18                                         *
 18.08.17         *
*/

-- тест
-- SELECT * FROM gpGet_Object_User_curr (zfCalc_UserAdmin())
