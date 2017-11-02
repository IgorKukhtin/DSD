-- Function: zfCalc_AccessKey_SendAll

DROP FUNCTION IF EXISTS zfCalc_AccessKey_SendAll (Integer);

CREATE OR REPLACE FUNCTION zfCalc_AccessKey_SendAll (IN inUserId Integer)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- для Админа  - Все Права
     IF 1 = 0 AND EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
     THEN
         RETURN (TRUE);
     ELSE
         RETURN COALESCE ((SELECT TRUE WHERE EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId IN (zc_Enum_Process_AccessKey_SendAll()))), FALSE);
     END IF;  
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_AccessKey_SendAll (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.17                                        *
*/

-- тест
-- SELECT * FROM zfCalc_AccessKey_SendAll (zfCalc_UserAdmin()::Integer)

