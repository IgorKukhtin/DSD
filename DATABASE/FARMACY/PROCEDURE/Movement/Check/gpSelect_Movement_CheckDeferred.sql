-- Function: gpSelect_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckDeferred (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckDeferred(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitName TVarChar, 
  CashRegisterName TVarChar)

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

     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_UnComplete() AS StatusId
                          UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE)
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
        FROM Movement_Check_View AS Movement_Check 
          INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
       WHERE 
		 Movement_Check.IsDeferred = True
		 AND
		 Movement_Check.CashMember is null
		 AND
		 (
		   Movement_Check.UnitId = vbUnitId 
		   OR 
		   vbUnitId = 0
		 );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckDeferred (Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 04.07.15                                                                     * 

*/

-- ����
-- SELECT * FROM gpSelect_Movement_CheckDeferred (inIsErased := FALSE, inSession:= '2')