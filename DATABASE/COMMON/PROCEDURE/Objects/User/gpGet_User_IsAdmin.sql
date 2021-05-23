-- Function: gpGet_User_IsAdmin (TVarChar)

DROP FUNCTION IF EXISTS gpGet_User_IsAdmin (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_IsAdmin(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS BOOLEAN AS
$BODY$
DECLARE vbUserId integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id = zc_Enum_Role_Admin())
    THEN
        RETURN True;
    ELSE
        RETURN False;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_User_IsAdmin (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 23.09.13                                                          *
*/
-- SELECT * FROM gpGet_User_IsAdmin ('2')



