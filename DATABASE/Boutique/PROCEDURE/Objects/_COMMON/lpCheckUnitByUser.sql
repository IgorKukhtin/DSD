-- Function: lpCheckUnitByUser(Integer)

DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, Integer);

CREATE OR REPLACE FUNCTION lpCheckUnitByUser (
    IN inUnitId   Integer,
    IN inUserId   Integer
)
RETURNS Integer
AS
$BODY$  
   DECLARE vbUnitId Integer;
BEGIN

     vbUnitId := lpGetUnitByUser(inUserId);

     -- ���� � ������������ = 0, ����� ����� �������� ����� �������, ����� ������ ����
     IF vbUnitId <> 0 AND vbUnitId <> inUnitId AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Child() AND OL.ChildObjectid = inUnitId AND OL.Objectid = vbUnitId)
     THEN
         RAISE EXCEPTION '������.� ������������ <%> ��� ���� ��������� ������ �� ������������� <%> .', lfGet_Object_ValueData (inUserId), lfGet_Object_ValueData (inUnitId);
     END IF;
     
     RETURN  COALESCE (vbUnitId, 0);
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.18         *
*/

-- ����
-- SELECT * FROM lpCheckUnitByUser (inUserId:= 2)
