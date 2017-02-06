-- Function: zfCalc_AccessKey_GuideAll

DROP FUNCTION IF EXISTS zfCalc_AccessKey_GuideAll (Integer);

CREATE OR REPLACE FUNCTION zfCalc_AccessKey_GuideAll (IN inUserId Integer)
RETURNS Boolean AS
$BODY$
BEGIN
     -- для Админа  - Все Права
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
     THEN
         RETURN (TRUE);
     ELSE
         RETURN COALESCE ((SELECT TRUE WHERE EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId IN (zc_Enum_Process_AccessKey_GuideAll(), zc_Enum_Process_AccessKey_TrasportAll(), zc_Enum_Process_AccessKey_CashDnepr()))), FALSE);
     END IF;  
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_AccessKey_GuideAll (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.11.14                                        * add zc_Enum_Process_AccessKey_CashDnepr
 21.12.13                                        * ObjectLink_UserRole_View
 14.12.13                                        *
*/

-- тест
-- SELECT * FROM zfCalc_AccessKey_GuideAll (zfCalc_UserAdmin()::Integer)

