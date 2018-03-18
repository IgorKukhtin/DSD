-- Function: lpCheckUnitByUser(Integer)

DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, Integer);
DROP FUNCTION IF EXISTS lpCheckUnitByUser (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpCheckUnitByUser (
    IN inUnitId    Integer ,
    IN inSession   TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN

     vbUserId := lpGetUserBySession (inSession);
     vbUnitId := lpGetUnitBySession (inSession);

     -- ���� � ������������ = 0, ����� ����� �������� ����� �������, ����� ������ ����
     IF vbUnitId <> 0 AND vbUnitId <> inUnitId AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectLink_Unit_Child() AND OL.ChildObjectid = inUnitId AND OL.Objectid = vbUnitId)
     THEN
         RAISE EXCEPTION '������.� ������������ <%> ��� �������� � ������ �� ������������� <%> .', lfGet_Object_ValueData_sh (vbUserId), lfGet_Object_ValueData_sh (inUnitId);
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
-- SELECT * FROM lpCheckUnitByUser (inUnitId := 1525, inSession:= '2')
