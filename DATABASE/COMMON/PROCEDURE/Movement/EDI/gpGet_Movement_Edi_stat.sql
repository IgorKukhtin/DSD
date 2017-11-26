-- Function: gpGet_Movement_Edi_stat()

DROP FUNCTION IF EXISTS gpGet_Movement_Edi_stat (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_Edi_stat(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
BEGIN
    
   RETURN COALESCE ((SELECT COUNT(*)
                     FROM Movement
                          INNER JOIN MovementString AS MovementString_MovementDesc
                                                    ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                   AND MovementString_MovementDesc.DescId     = zc_MovementString_Desc()
                          INNER JOIN MovementDesc ON MovementDesc.Code =  MovementString_MovementDesc.ValueData
                                                 AND MovementDesc.Id   = zc_Movement_OrderExternal()
                     WHERE Movement.DescId   = zc_Movement_EDI()
                       AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                       AND Movement.StatusId <> zc_Enum_Status_Erased())
                  , 0);
  
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.11.17                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_Edi_stat (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())
