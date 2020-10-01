-- Function: lpCheckUnit_byUser (Integer, Integer)

DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, TVarChar);
DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, Integer);
DROP FUNCTION IF EXISTS lpCheckUnit_byUser (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckUnit_byUser (
    IN inUnitId_by Integer , -- ������������� ������� ���� ���������
    IN inUserId    Integer   -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId:= lpGetUnit_byUser (inUserId);


     -- ���� � ������������ = 0, ����� ����� �������� ����� �������, ����� ������ ���� ��� ���� �����
     IF vbUnitId > 0 AND COALESCE (inUnitId_by, 0) NOT IN (SELECT vbUnitId AS UnitId UNION ALL SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Child() AND OL.ObjectId = vbUnitId)
     THEN
         RAISE EXCEPTION '������.� ������������ <%> - <%> ��� �������� � ������ ������������� <%>.'
                       , lfGet_Object_ValueData_sh (inUserId)
                       , lfGet_Object_ValueData_sh (vbUnitId)
                       , lfGet_Object_ValueData_sh (inUnitId_by)
                        ;
     END IF;

     -- ������� - ������������� ������� ���������
     RETURN COALESCE (inUnitId_by, 0);

END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.18         *
*/

-- ����
-- SELECT * FROM lpCheckUnit_byUser (inUnitId_by:= 1525, inUserId:= zfCalc_UserAdmin() :: Integer)
