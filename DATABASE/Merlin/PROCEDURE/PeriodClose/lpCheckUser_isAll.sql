-- �������� �������� �������
-- Function: lpCheckUser_isAll()

DROP FUNCTION IF EXISTS lpCheckUser_isAll (Integer);

CREATE OR REPLACE FUNCTION lpCheckUser_isAll(
    IN inUserId          Integer     -- ������������
)
RETURNS Boolean
AS
$BODY$  
BEGIN

     -- �������� - ������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.05.22                                        *
*/

-- ����
-- SELECT lpCheckUser_isAll (inUserId:= 5)
