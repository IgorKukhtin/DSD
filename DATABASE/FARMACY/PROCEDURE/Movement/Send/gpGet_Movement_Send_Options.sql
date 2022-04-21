-- Function: gpGet_Movement_Send_Options()

DROP FUNCTION IF EXISTS gpGet_Movement_Send_Options (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Send_Options(
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (GroupByBox Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbisAdmin Boolean;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Send());
   vbUserId := inSession;
     
   vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin());

   RETURN QUERY
   SELECT NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                     WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy());

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Send_Options (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.04.22                                                       *
 */

-- ����
-- 
select * from gpGet_Movement_Send_Options(inSession := '3');