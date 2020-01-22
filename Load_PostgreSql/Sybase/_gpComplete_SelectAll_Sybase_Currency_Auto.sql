-- Function: gpComplete_SelectAll_Sybase_Currency_Auto()

DROP FUNCTION IF EXISTS gpComplete_SelectAll_Sybase_Currency_Auto (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION gpComplete_SelectAll_Sybase_Currency_Auto(
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
     SELECT Movement.Id AS MovementId
          , Movement.OperDate
          , Movement.InvNumber
          , MovementDesc.Code
          , (MovementDesc.ItemName || ' ' || COALESCE (Object_CurrencyFrom.ValueData, '') || ' ' || COALESCE (Object_CurrencyTo.ValueData, '')) ::TVarChar AS ItemName
     FROM Movement
          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
          LEFT JOIN MovementItemLinkObject AS MILO_CurrencyTo
                                           ON MILO_CurrencyTo.MovementItemId = MovementItem.Id
                                          AND MILO_CurrencyTo.DescId         = zc_MILinkObject_Currency()

          LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId
          LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILO_CurrencyTo.ObjectId
     WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate + INTERVAL '2 DAY'
       AND Movement.DescId   = zc_Movement_Currency()
       AND Movement.StatusId = zc_Enum_Status_Complete()
     ORDER BY Movement.OperDate, MovementItem.ObjectId, MILO_CurrencyTo.ObjectId
    ;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 19.01.20                                        *
*/

-- тест
-- SELECT * FROM gpComplete_SelectAll_Sybase_Currency_Auto (inStartDate:= '01.06.2017', inEndDate:= '30.06.2017')
-- SELECT * FROM gpComplete_SelectAll_Sybase_Currency_Auto (inStartDate:= '01.07.2017', inEndDate:= '31.07.2017')
