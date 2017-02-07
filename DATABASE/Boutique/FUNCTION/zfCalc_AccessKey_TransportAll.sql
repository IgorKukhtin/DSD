-- Function: zfCalc_AccessKey_TransportAll - �� ����� ���� ��� ����������, �� ���������� ���� ��� ����������

DROP FUNCTION IF EXISTS zfCalc_AccessKey_TransportAll (Integer);

CREATE OR REPLACE FUNCTION zfCalc_AccessKey_TransportAll (IN inUserId Integer)
RETURNS Boolean AS
$BODY$
BEGIN
     -- ��� ������  - ��� �����
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.15                                        *
*/

-- ����
-- SELECT * FROM zfCalc_AccessKey_TransportAll (zfCalc_UserAdmin()::Integer)

