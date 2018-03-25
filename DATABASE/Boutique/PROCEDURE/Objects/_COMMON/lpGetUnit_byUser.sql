-- Function: lpGetUnit_byUser(Integer)

DROP FUNCTION IF EXISTS lpGetUnitBySession (TVarChar);
DROP FUNCTION IF EXISTS lpGetUnitByUser (Integer);
DROP FUNCTION IF EXISTS lpGetUnit_byUser (Integer);

CREATE OR REPLACE FUNCTION lpGetUnit_byUser (
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- ��� ������  - ��� �����
     IF EXISTS (SELECT 1
                FROM ObjectLink AS Object_UserRole_User -- ����� ������������ � �������� ���� ������������
                         JOIN ObjectLink AS Object_UserRole_Role -- ����� ����� � �������� ���� ������������
                                         ON Object_UserRole_Role.DescId        = zc_ObjectLink_UserRole_Role()
                                        AND Object_UserRole_Role.ObjectId      = Object_UserRole_User.ObjectId
                                        AND Object_UserRole_Role.ChildObjectId = zc_Enum_Role_Admin()
                WHERE Object_UserRole_User.DescId        = zc_ObjectLink_UserRole_User()
                  AND Object_UserRole_User.ChildObjectId = inUserId
               )
     THEN
        -- ��� �����
        RETURN 0;
     ELSE
        -- �������� ��� ������������ - � ������ ������������� �� ��������
        RETURN COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                          FROM ObjectLink AS ObjectLink_User_Unit
                          WHERE ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
                            AND ObjectLink_User_Unit.ObjectId = inUserId)
                         , 0);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.02.18         *
*/

-- ����
-- SELECT * FROM lpGetUnit_byUser (inUserId:= zfCalc_UserAdmin() :: Integer)
