-- Function: gpComplete_SelectAll_Sybase_PACK()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean);
DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase (TDateTime, TDateTime, Boolean, Boolean);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime , --
    IN inIsSale             Boolean   , -- 
    IN inIsBefoHistoryCost  Boolean
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN

     RETURN QUERY 
     WITH tmpUnit_pack AS (SELECT 8451 AS UnitId, NULL AS isMain  -- Цех Упаковки
     -- WITH tmpUnit_pack AS (SELECT 8450 AS UnitId, NULL AS isMain  -- ЦЕХ копчения
     -- WITH tmpUnit_pack AS (SELECT 8440 AS UnitId, NULL AS isMain  -- Дефростер
                       )
     -- !!!Internal - PACK!!!
     -- 1.5. Send + ProductionUnion
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN tmpUnit_pack AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit_pack AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
       AND inIsBefoHistoryCost = TRUE
       AND (tmpUnit_from.UnitId > 0 OR tmpUnit_To.UnitId > 0)
       -- AND tmpUnit_To.UnitId > 0
    UNION
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN tmpUnit_pack AS tmpUnit_from ON tmpUnit_from.UnitId = MLO_From.ObjectId
          LEFT JOIN tmpUnit_pack AS tmpUnit_To ON tmpUnit_To.UnitId = MLO_To.ObjectId

          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
       AND Movement.StatusId = zc_Enum_Status_Complete()
       AND Movement.DescId IN (zc_Movement_Send(), zc_Movement_ProductionUnion())
       AND inIsBefoHistoryCost = FALSE
       AND ((tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL AND Movement.DescId = zc_Movement_Send())
         OR (tmpUnit_from.UnitId > 0 AND tmpUnit_To.UnitId IS NULL AND Movement.DescId = zc_Movement_ProductionUnion())
           )

    ;

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 04.11.14                                        *
*/
