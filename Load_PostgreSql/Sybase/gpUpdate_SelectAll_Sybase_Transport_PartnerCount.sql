-- Function: gpUpdate_SelectAll_Sybase_Transport_PartnerCount()

DROP FUNCTION IF EXISTS gpUpdate_SelectAll_Sybase_Transport_PartnerCount (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpUpdate_SelectAll_Sybase_Transport_PartnerCount(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime   --
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     -- Результат
     RETURN QUERY 

     -- Результат
     SELECT tmp.MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
     FROM (SELECT DISTINCT
                  Movement.Id AS MovementId
           FROM Movement
           WHERE Movement.OperDate BETWEEN inStartDate AND CURRENT_DATE + INTERVAL '2 DAY'
             AND Movement.DescId IN (zc_Movement_Transport())
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
         ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.04.21                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_SelectAll_Sybase_Transport_PartnerCount (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE)
