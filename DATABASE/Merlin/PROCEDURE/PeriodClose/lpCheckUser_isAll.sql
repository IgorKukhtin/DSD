-- Проверка закрытия периода
-- Function: lpCheckUser_isAll()

DROP FUNCTION IF EXISTS lpCheckUser_isAll (Integer);

CREATE OR REPLACE FUNCTION lpCheckUser_isAll(
    IN inUserId          Integer     -- пользователь
)
RETURNS Boolean
AS
$BODY$  
BEGIN

     -- Проверка - период
     IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = inUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
     THEN
         RETURN TRUE;
     ELSE
         RETURN FALSE;
     END IF;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.05.22                                        *
*/

-- тест
-- SELECT lpCheckUser_isAll (inUserId:= 5)
