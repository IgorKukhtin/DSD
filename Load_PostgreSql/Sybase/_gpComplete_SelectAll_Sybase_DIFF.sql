-- Function: gpComplete_SelectAll_Sybase_diff()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_diff (TDateTime, TDateTime, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_diff(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     -- !!!
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')
           || '  min = ' || MIN (HistoryCost.ContainerId) :: TVarChar || '  max = ' || MAX (HistoryCost.ContainerId) :: TVarChar
            ) :: TVarChar
     FROM HistoryCost
          INNER JOIN MovementItem ON MovementItem.Id = HistoryCost.MovementItemId_diff
          INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                             -- AND Movement.DescId = zc_Movement_Sale()
                             -- AND Movement.DescId <> zc_Movement_Inventory()
          /*INNER JOIN MovementItemContainer ON MovementItemContainer.MovementId = Movement.Id
                                          AND MovementItemContainer.MovementItemId = HistoryCost.MovementItemId_diff
                                          AND MovementItemContainer.ContainerId = HistoryCost.ContainerId*/

          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

     WHERE HistoryCost.MovementItemId_diff > 0
      AND inStartDate >= StartDate AND inEndDate <= EndDate
     GROUP BY Movement.Id
            , Movement.OperDate
            , Movement.InvNumber
            , MovementDesc.Code
            , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, ''))
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 08.08.15                                        *
*/

-- SELECT * FROM gpComplete_SelectAll_Sybase_diff (inStartDate:= '01.07.2015', inEndDate:= '31.07.2015', inIsBefoHistoryCost:= NULL)
