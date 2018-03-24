-- Function: lpGetUnit_byUser(Integer)

-- DROP FUNCTION IF EXISTS lpGetUnitBySession (TVarChar);
-- DROP FUNCTION IF EXISTS lpGetUnitByUser (Integer);
DROP FUNCTION IF EXISTS lpGetUnit_byUser (Integer);

CREATE OR REPLACE FUNCTION lpGetUnit_byUser (
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$  
BEGIN
     -- �������� ��� ������������ - � ������ ������������� �� ��������
     RETURN  COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_User_Unit
                        WHERE ObjectLink_User_Unit.DescId   = zc_ObjectLink_User_Unit()
                          AND ObjectLink_User_Unit.ObjectId = inUserId)
                       , 0);
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
