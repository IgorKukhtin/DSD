-- Function: gpComplete_SelectAll_Sybase_Promo_Auto_60()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_Promo_Auto_60 (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_Promo_Auto_60(
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
                  Movement.Id :: Integer AS MovementId
           FROM Movement
                INNER JOIN MovementDate AS MovementDate_StartSale
                                        ON MovementDate_StartSale.MovementId = Movement.Id
                                       AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
                                       AND MovementDate_StartSale.ValueData  BETWEEN inStartDate AND inEndDate

           WHERE Movement.DescId   IN (zc_Movement_Promo())
             AND Movement.StatusId = zc_Enum_Status_Complete()
           --AND Movement.OperDate BETWEEN inStartDate AND inEndDate

          ) AS tmp
          LEFT JOIN Movement ON Movement.Id = tmp.MovementId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
     ORDER BY 2, 1
         ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.26                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase_Promo_Auto_60 (inStartDate:= '01.01.2026', inEndDate:= '30.01.2026')
