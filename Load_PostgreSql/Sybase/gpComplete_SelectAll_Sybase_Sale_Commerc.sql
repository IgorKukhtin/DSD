-- Function: gpComplete_SelectAll_Sybase_Sale_Commerc()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_Sale_Commerc (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_Sale_Commerc(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime   --
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, MovementDescId Integer, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     -- WITH --tmpUnit AS (SELECT tmp.UnitId,       TRUE AS isMain FROM lfSelect_Object_Unit_byGroup (8446) AS tmp -- ÷≈’ ÍÓÎ·‡Ò‡+‰ÂÎ-Ò˚
     --                   )
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , Movement.DescId
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          -- LEFT JOIN tmpUnit AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          -- LEFT JOIN tmpUnit AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 30.06.26                                        *
*/

-- SELECT * FROM gpComplete_SelectAll_Sybase_Sale_Commerc (inStartDate:= '01.05.2026', inEndDate:= '31.05.2026')
