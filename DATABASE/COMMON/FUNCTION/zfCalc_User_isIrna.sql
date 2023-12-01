-- Function: zfCalc_User_isIrna

DROP FUNCTION IF EXISTS zfCalc_UserIrna (Integer);
DROP FUNCTION IF EXISTS zfCalc_User_isIrna (Integer);

CREATE OR REPLACE FUNCTION zfCalc_User_isIrna (in inUserId Integer)
RETURNS Boolean
AS
$BODY$
BEGIN

     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = zc_Enum_Role_Admin())
         -- Роль доступ Алан + Ирна
         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId = 8101711)
     THEN
         RETURN NULL;

     ELSEIF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = inUserId AND RoleId IN (8101714 -- Роль Ирна - все
                                                                                            , 8101715 -- Роль Ирна - производство
                                                                                             ))
        OR EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE UserId = inUserId AND AccessKeyId = zc_Enum_Process_AccessKey_UserIrna())

     THEN
          RETURN TRUE;


     ELSE 
          RETURN FALSE;
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.22                                        *
*/

-- тест
-- SELECT zfCalc_User_isIrna (5) as forAdmin, zfCalc_User_isIrna (10) as forOth, zfCalc_User_isIrna (4467766) as forIrna
