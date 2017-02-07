-- Function: zfCalc_UserAdmin

DROP FUNCTION IF EXISTS zfCalc_UserAdmin ();

CREATE OR REPLACE FUNCTION zfCalc_UserAdmin()
RETURNS TVarChar AS
$BODY$
  DECLARE vbValue TVarChar;
BEGIN
     
     RETURN (SELECT MIN (Object_UserRole_User.ChildObjectId)
             FROM ObjectLink AS Object_UserRole_User -- ����� ������������ � �������� ���� ������������
                  JOIN ObjectLink AS Object_UserRole_Role -- ����� ����� � �������� ���� ������������
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.10.13                                        * - !!!��� ������!!!
*/

-- ����
-- SELECT * FROM zfCalc_UserAdmin ()
-- SELECT * FROM zfFormat_PartionGoods ('�����72121������')
