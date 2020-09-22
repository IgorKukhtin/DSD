-- Function: zfCalc_UserAdmin

DROP FUNCTION IF EXISTS zfCalc_UserAdmin ();

CREATE OR REPLACE FUNCTION zfCalc_UserAdmin()
RETURNS TVarChar AS
$BODY$
  DECLARE vbValue TVarChar;
BEGIN
     
     RETURN (SELECT MIN (Object_UserRole_User.ChildObjectId)
             FROM ObjectLink AS Object_UserRole_User -- Связь пользователя с объектом роли пользователя
                  JOIN ObjectLink AS Object_UserRole_Role -- Связь ролей с объектом роли пользователя
                                  ON Object_UserRole_Role.DescId = zc_ObjectLink_UserRole_Role()
                                 AND Object_UserRole_Role.ObjectId = Object_UserRole_User.ObjectId
                                 AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
             WHERE Object_UserRole_User.DescId = zc_ObjectLink_UserRole_User());

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_UserAdmin () OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.10.13                                        * - !!!для тестов!!!
*/

-- тест
-- SELECT * FROM zfCalc_UserAdmin ()
-- SELECT * FROM zfFormat_PartionGoods ('фывфы72121фывыфв')
