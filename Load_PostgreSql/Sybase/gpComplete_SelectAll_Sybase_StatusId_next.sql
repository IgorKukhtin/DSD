-- Function: gpComplete_SelectAll_Sybase_StatusId_next()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_StatusId_next (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_StatusId_next(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime   --
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, StatusId_next Integer, StatusName_next TVarChar, StatusId Integer, StatusName TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     -- Ðåçóëüòàò
     RETURN QUERY 

     -- Ðåçóëüòàò
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , Movement.StatusId_next
          , Object_Status_next.ValueData AS StatusName_next
          , Movement.StatusId
          , Object_Status.ValueData AS StatusName
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
     FROM Movement
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To          ON Object_To.Id          = MLO_To.ObjectId
          LEFT JOIN Object AS Object_Status      ON Object_Status.Id      = Movement.StatusId
          LEFT JOIN Object AS Object_Status_next ON Object_Status_next.Id = Movement.StatusId_next

     WHERE Movement.OperDate BETWEEN inStartDate AND CURRENT_DATE + INTERVAL '1 DAY'
       AND Movement.StatusId_next = zc_Enum_Status_UnComplete()
       AND Movement.StatusId      <> zc_Enum_Status_UnComplete()
       AND Movement.DescId IN (zc_Movement_Income(), zc_Movement_ReturnOut()
                             , zc_Movement_SendOnPrice(), zc_Movement_Send(), zc_Movement_Loss()
                             , zc_Movement_ProductionUnion(), zc_Movement_ProductionSeparate()
                             , zc_Movement_Sale(), zc_Movement_ReturnIn()
                             , zc_Movement_Inventory()
                              )
     ORDER BY 2, 1
         ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.   Ìàíüêî Ä.
 10.04.25                                        *
*/

-- òåñò
-- select sum (case when amount > 0 then amount else 0 end), sum (case when amount < 0 then amount else 0 end) from MovementItemContainer where MovementId = 30946866 and descId = 1 -- -13.5600
-- select sum (case when amount > 0 then amount else 0 end), sum (case when amount < 0 then amount else 0 end) from MovementItemContainer where MovementId = 30946867 and descId = 1 -- 3.0800;-9.0000
-- òåñò
-- SELECT * FROM gpComplete_SelectAll_Sybase_StatusId_next (inStartDate:= '01.04.2025', inEndDate:= '30.04.2025')

