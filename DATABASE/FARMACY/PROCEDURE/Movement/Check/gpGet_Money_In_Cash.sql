DROP FUNCTION IF EXISTS gpGet_Money_in_Cash (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Money_in_Cash(
   OUT outTotalSumm    TFloat,   --����� ������� �� ����
    IN inDate          TDateTime, --����
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);
  vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
  IF vbUnitKey = '' THEN
    vbUnitKey := '0';
  END IF;   
  vbUnitId := vbUnitKey::Integer;

  Select SUM(Movement_Check.TotalSumm) INTO outTotalSumm
  FROM
    Movement_Check_View AS Movement_Check
  WHERE 
    Movement_Check.StatusId = zc_Enum_Status_Complete()
    AND
    Movement_Check.OperDate >= date_trunc('day', inDate)
    AND
    Movement_Check.OperDate < date_trunc('day', inDate) + INTERVAL '1 DAY'
    AND
    (
      Movement_Check.UnitId = vbUnitId 
      OR 
      vbUnitId = 0
    );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Money_in_Cash (TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 04.07.15                                                                     * 

*/

-- ����
-- SELECT * FROM gpGet_Money_in_Cash (CURRENT_DATE,'3')
