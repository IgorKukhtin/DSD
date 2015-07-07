-- Function: gpGet_Movement_Check()

DROP FUNCTION IF EXISTS gpGet_Movement_Check (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Check(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidKindName TVarChar, PaidTypeName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidKindName
           , Movement_Check.PaidTypeName
        FROM Movement_Check_View AS Movement_Check 
       WHERE Movement_Check.Id =  inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 23.05.15                         *                 
*/

-- тест
-- SELECT * FROM gpGet_Movement_Check (inMovementId:= 1, inSession:= '9818')