-- Function: lpGetUnitByUser(Integer)

DROP FUNCTION IF EXISTS lpGetUnitByUser (Integer);

CREATE OR REPLACE FUNCTION lpGetUnitByUser (
    IN inUserId Integer
)
RETURNS Integer
AS
$BODY$  
BEGIN
     
     RETURN  COALESCE ((SELECT ObjectLink_User_Unit.ChildObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_User_Unit
                        WHERE ObjectLink_User_Unit.DescId = zc_ObjectLink_User_Unit()
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
-- SELECT * FROM lpGetUnitByUser (inUserId:= 2)
