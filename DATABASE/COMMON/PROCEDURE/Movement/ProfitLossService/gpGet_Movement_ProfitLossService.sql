-- Function: gpGet_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpGet_Movement_ProfitLossService (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProfitLossService(
    IN inMovementId        Integer  , -- ���� ���������
    IN inOperDate          TDateTime, -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             )
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProfitLossService());
     IF COALESCE (inMovementId, 0) = 0
     THEN
       RETURN QUERY
       SELECT
               0                                    AS Id
             , CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) AS InvNumber
             , inOperDate						    AS OperDate
             , Object_Status.Code                   AS StatusCode
             , Object_Status.Name                   AS StatusName
       FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE

       RETURN QUERY
       SELECT
             Movement.Id                            AS Id
           , Movement.InvNumber                     AS InvNumber
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode          	    AS StatusCode
           , Object_Status.ValueData         	    AS StatusName

       FROM Movement
       LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


       WHERE Movement.Id =  inMovementId
       AND Movement.DescId = zc_Movement_ProfitLossService();
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ProfitLossService (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.     ������ �.�.
 17.02.14                                                            *
*/

-- ����
-- SELECT * FROM gpGet_Movement_ProfitLossService (inMovementId:= 1, inOperDate:='01.01.2014', inSession:= '2')