-- Function: gpComplete_SelectAll_Sybase_ReturnIn_Auto_ALL()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_ReturnIn_Auto (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_ReturnIn_Auto(
    IN inStartDate          TDateTime , -- 
    IN inEndDate            TDateTime   --
)                              
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar, Code TVarChar, ItemName TVarChar
              )
AS
$BODY$
BEGIN
     IF inStartDate >= '01.10.2016' THEN

     -- Результат
     RETURN QUERY 

     -- Результат
     SELECT tmp.MovementId
          , tmp.OperDate
          , tmp.InvNumber
          , tmp.Code
          , tmp.ItemName
     FROM (
     SELECT DISTINCT
            Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_From.ValueData, '') || ' ' || COALESCE (Object_To.ValueData, '')) ::TVarChar AS ItemName
     FROM Movement
          INNER JOIN MovementLinkObject AS MLO_PaidKind ON MLO_PaidKind.MovementId = Movement.Id
                                                       AND MLO_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                                                       -- AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm()

          LEFT JOIN MovementBoolean AS MovementBoolean_Error
                                    ON MovementBoolean_Error.MovementId =  Movement.Id
                                   AND MovementBoolean_Error.DescId = zc_MovementBoolean_Error()

          INNER JOIN MovementItem AS MI_Master ON MI_Master.MovementId = Movement.Id
                                AND MI_Master.DescId     = zc_MI_Master()
                                AND MI_Master.isErased   = FALSE
          INNER JOIN MovementItemFloat AS MIF_AmountPartner
                                       ON MIF_AmountPartner.MovementItemId = MI_Master.Id
                                      AND MIF_AmountPartner.DescId     = zc_MIFloat_AmountPartner()
                                      AND MIF_AmountPartner.ValueData <> 0
          INNER JOIN MovementItemFloat AS MIF_AmountPrice
                                       ON MIF_AmountPrice.MovementItemId = MI_Master.Id
                                      AND MIF_AmountPrice.DescId     = zc_MIFloat_Price()
                                      AND MIF_AmountPrice.ValueData <> 0

          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                AND MovementItem.DescId     = zc_MI_Child()
                                AND MovementItem.isErased   = FALSE
                                AND MovementItem.Amount     > 0

          LEFT JOIN MovementLinkObject AS MLO_From ON MLO_From.MovementId = Movement.Id
                                                  AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId
          LEFT JOIN MovementLinkObject AS MLO_To ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId

     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate + INTERVAL '2 DAY'
       AND Movement.DescId = zc_Movement_ReturnIn()
       AND Movement.StatusId = zc_Enum_Status_Complete()
       -- AND (MovementItem.MovementId IS NULL OR MovementBoolean_Error.ValueData = TRUE OR MovementBoolean_Error.ValueData IS NULL)
       AND (MovementItem.MovementId IS NULL
         OR MovementBoolean_Error.ValueData = TRUE
         OR MovementBoolean_Error.ValueData IS NULL
         -- OR MLO_PaidKind.ObjectId = zc_Enum_PaidKind_SecondForm()
         -- OR (MovementBoolean_Error.ValueData IS NULL AND MLO_PaidKind.ObjectId = zc_Enum_PaidKind_FirstForm())
           )
    ) AS tmp
    ;

     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.09.16                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase_ReturnIn_Auto (inStartDate:= '01.08.2016', inEndDate:= '31.08.2016')
-- SELECT * FROM gpComplete_SelectAll_Sybase_ReturnIn_Auto (inStartDate:= '01.09.2016', inEndDate:= '30.09.2016')
/*
insert into  "DBA"."_pgMovementReComlete_add"
SELECT * FROM _pgMovementReComlete_copy
where Movementid = 4400825 
*/