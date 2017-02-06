-- Function: zfCalc_AccessKey_TransportAll - на самом деле это справочник, но используем пока для документов

DROP FUNCTION IF EXISTS zfCalc_AccessKey_TransportAll (Integer);

CREATE OR REPLACE FUNCTION zfCalc_AccessKey_TransportAll (IN inUserId Integer)
RETURNS Boolean AS
$BODY$
BEGIN
     -- для Админа  - Все Права
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = inUserId)
     THEN
         RETURN (TRUE);
     ELSE
         RETURN COALESCE ((SELECT TRUE WHERE EXISTS (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId IN (zc_Enum_Process_AccessKey_DocumentAll(), zc_Enum_Process_AccessKey_TrasportAll()))), FALSE);
     END IF;  
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_AccessKey_TransportAll (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.11.15                                        *
*/

-- тест
-- SELECT * FROM zfCalc_AccessKey_TransportAll (zfCalc_UserAdmin()::Integer)

