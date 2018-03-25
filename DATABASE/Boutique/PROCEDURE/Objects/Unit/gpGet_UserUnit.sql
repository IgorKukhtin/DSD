-- Function: gpGet_UserUnit()

DROP FUNCTION IF EXISTS gpGet_UserUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserUnit(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(UnitId integer, UnitName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
 
     -- �������� ��� ������������ - � ������ ������������� �� ��������
     vbUnitId:= lpGetUnit_byUser (vbUserId);

     -- ���������
     RETURN QUERY
       SELECT Id, ValueData FROM Object WHERE Id = vbUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.08.17         *
*/

-- ����
-- SELECT * FROM gpGet_UserUnit (inSession:= zfCalc_UserAdmin())
