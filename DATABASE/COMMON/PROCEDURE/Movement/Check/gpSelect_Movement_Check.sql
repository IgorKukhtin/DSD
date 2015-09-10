-- Function: gpSelect_Movement_OrderInternal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inUnitId        Integer,  --Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar, Bayer TVarChar)

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidTypeName
           , Movement_Check.CashMember
        FROM Movement_Check_View AS Movement_Check 
                            JOIN tmpStatus ON tmpStatus.StatusId = Movement_Check.StatusId
       WHERE Movement_Check.OperDate BETWEEN inStartDate AND inEndDate
                                         AND (Movement_Check.UnitId = inUnitId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 07.08.15                                                                        *
 08.05.15                         * 

*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderInternal (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased := FALSE, inSession:= '2')