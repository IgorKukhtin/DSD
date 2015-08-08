-- Function: gpSelect_Movement_Income()

DROP FUNCTION IF EXISTS gpGet_UserUnit (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserUnit(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(UnitId integer, UnitName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
     SELECT Id, ValueData FROM Object WHERE Id = vbUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_UserUnit (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.15                        *

*/

-- ����
-- SELECT * FROM gpSelect_CashRemains (inSession:= '2')