-- Function: gpComplete_SelectAll_Sybase_ReturnIn_Auto_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_Promo_Auto (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_Promo_Auto(
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
                  MIFloat_PromoMovement.ValueData :: Integer AS MovementId
           FROM Movement
                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                       AND MovementItem.DescId     = zc_MI_Master()
                                       AND MovementItem.isErased   = FALSE
                INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                             ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                            AND MIFloat_PromoMovement.ValueData      > 0
                                            AND MIFloat_PromoMovement.DescId     = zc_MIFloat_PromoMovementId()
       
         --WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate + INTERVAL '2 DAY'
           WHERE Movement.OperDate BETWEEN inStartDate AND CURRENT_DATE - INTERVAL '1 DAY'
             AND Movement.DescId IN (zc_Movement_ReturnIn(), zc_Movement_Sale(), zc_Movement_OrderExternal())
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND 1=1

          UNION
           SELECT DISTINCT
                  Movement.Id :: Integer AS MovementId
           FROM Movement
                INNER JOIN MovementDate AS MovementDate_StartSale
                                        ON MovementDate_StartSale.MovementId = Movement.Id
                                       AND MovementDate_StartSale.ValueData  BETWEEN inStartDate AND inEndDate
                                       AND MovementDate_StartSale.DescId     = zc_MovementDate_StartSale()
       
           WHERE Movement.DescId IN (zc_Movement_Promo())
             AND Movement.StatusId = zc_Enum_Status_Complete()
             AND 1=0

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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 23.07.17                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase_Promo_Auto (inStartDate:= '01.06.2017', inEndDate:= '30.06.2017')
-- SELECT * FROM gpComplete_SelectAll_Sybase_Promo_Auto (inStartDate:= '01.11.2024', inEndDate:= '30.11.2024')
