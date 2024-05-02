-- Function: gpGet_User_IsAdmin (TVarChar)

DROP FUNCTION IF EXISTS gpGet_User_IsAdmin (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_User_IsAdmin(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS BOOLEAN AS
$BODY$
DECLARE vbUserId integer;
BEGIN
    vbUserId:= lpGetUserBySession (inSession);

    IF EXISTS(Select * from gpSelect_Object_UserRole(inSession) Where UserId = vbUserId AND Id = zc_Enum_Role_Admin())
       -- ������������ - ������ ����������� ��������� ��
       AND (NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = 10657326)
         -- ������ - ���������� �������������
         OR EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 10679426)
           )
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 23.09.13                                                          *
*/
-- SELECT * FROM gpGet_User_IsAdmin ('2')



