-- Function: gpGet_Movement_IncomePharmacy_Visible()

DROP FUNCTION IF EXISTS gpGet_Movement_IncomePharmacy_Visible (TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_IncomePharmacy_Visible(
   OUT outisVisiableTotalSumm  BOOLEAN,  
    IN inSession               TVarChar   -- ������ ������������
)
RETURNS  Boolean
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

    outisVisiableTotalSumm := vbUnitId = 394426;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_IncomePharmacy_Visible (TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.08.22                                                       *
*/

-- ����
-- SELECT * FROM gpGet_Movement_IncomePharmacy_Visible (inSession:= '9818')