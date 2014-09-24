-- Function: gpSelect_Movement_Cash_Personal()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalCash (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash_Personal(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar

)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , MovementItem.Amount 
  
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName

       FROM Movement
           -- INNER JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                                                           
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

       WHERE Movement.DescId = zc_Movement_Cash()
         AND Movement.ParentId is NOT NULL 
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         --AND (MILinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
         --AND (CASE WHEN inisServiceDate = True THEN MIDate_ServiceDate.ValueData = inServiceDate else 0 = 0 END)
         ;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Cash_Personal (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash_Personal (inStartDate:= '30.01.2012', inEndDate:= '01.01.2016', inCashId:= 14462, inSession:= '2')
