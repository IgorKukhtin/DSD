-- Function: gpGet_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Movement_ReturnIn (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_ReturnIn(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , UnitId Integer, UnitName TVarChar
             , CashRegisterId Integer, CashRegisterName TVarChar
             , FiscalCheckNumber TVarChar
             
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpReturnInRight (inSession, zc_Enum_Process_Get_Movement_ReturnIn());
     vbUserId := inSession;

     RETURN QUERY
      SELECT Movement_ReturnIn.Id
           , Movement_ReturnIn.InvNumber
           , COALESCE (Movement_ReturnIn.OperDate, CURRENT_DATE) :: TDateTime AS OperDate
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalCount.ValueData         AS TotalCount
           , MovementFloat_TotalSumm.ValueData          AS TotalSumm
           , MovementLinkObject_Unit.ObjectId           AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           
           , MovementLinkObject_CashRegister.ObjectId   AS CashRegisterId
           , Object_CashRegister.ValueData              AS CashRegisterName
           
           , MovementString_FiscalCheckNumber.ValueData AS FiscalCheckNumber

      FROM Movement AS Movement_ReturnIn
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_ReturnIn.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement_ReturnIn.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement_ReturnIn.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT OUTER JOIN MovementString AS MovementString_FiscalCheckNumber
                                           ON MovementString_FiscalCheckNumber.MovementId = Movement_ReturnIn.Id
                                          AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()
       WHERE Movement_ReturnIn.Id = inMovementId
         AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.19         *                
*/

-- тест
-- SELECT * FROM gpGet_Movement_ReturnIn (inMovementId:= 1, inSession:= '9818')