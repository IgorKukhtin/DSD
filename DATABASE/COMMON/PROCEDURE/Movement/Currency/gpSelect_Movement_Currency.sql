-- Function: gpSelect_Movement_Currency()

DROP FUNCTION IF EXISTS gpSelect_Movement_Currency (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Currency(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             
             , Amount TFloat
             , Comment TVarChar
             , CurrencyFromName TVarChar
             , CurrencyToName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Currency());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName


           , MovementItem.Amount             AS Amount

           , MIString_Comment.ValueData      AS Comment

           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           
           , Object_CurrencyTo.ValueData     AS CurrencyToName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
           -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                             ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILinkObject_CurrencyTo.ObjectId
          
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Currency (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 28.07.14         *
*/

-- тест
--  SELECT * FROM gpSelect_Movement_Currency (inStartDate:= '30.01.2013', inEndDate:= '01.02.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin())
