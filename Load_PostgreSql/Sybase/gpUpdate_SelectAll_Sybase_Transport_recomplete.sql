-- Function: gpUpdate_SelectAll_Sybase_Transport_recomplete()

DROP FUNCTION IF EXISTS gpUpdate_SelectAll_Sybase_Transport_recomplete (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpUpdate_SelectAll_Sybase_Transport_recomplete(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime   --
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar, MovementDescId Integer, zc_Movement_Transport Integer, zc_Movement_TransportService Integer
              )
AS
$BODY$
BEGIN

     -- ���������
     RETURN QUERY 

     -- ���������
     SELECT tmp.MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
          , Movement.DescId                AS MovementDescId
          , zc_Movement_Transport()        AS zc_Movement_Transport
          , zc_Movement_TransportService() AS zc_Movement_TransportService
     FROM (SELECT DISTINCT
                  Movement.Id AS MovementId
           FROM Movement
           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
             AND Movement.DescId IN (zc_Movement_Transport(), zc_Movement_TransportService())
             AND Movement.StatusId = zc_Enum_Status_Complete()
          ) AS tmp
          LEFT JOIN Movement ON Movement.Id = tmp.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_Car()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
     ORDER BY 2
         ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 28.04.21                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_SelectAll_Sybase_Transport_recomplete (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE)
