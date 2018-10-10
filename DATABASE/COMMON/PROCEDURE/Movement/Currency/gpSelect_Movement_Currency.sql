-- Function: gpSelect_Movement_Currency()

DROP FUNCTION IF EXISTS gpSelect_Movement_Currency (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Currency (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Currency(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat, ParValue TFloat
             , Amount_Currency TFloat
             , Comment TVarChar
             , CurrencyFromName TVarChar
             , CurrencyToName TVarChar
             , PaidKindName TVarChar
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
          , tmpMovement AS (SELECT Movement.*
                            FROM tmpStatus
                                 JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.StatusId = tmpStatus.StatusId
                           )
          , tmpMIContainer AS (SELECT MIContainer.MovementId
                                    , SUM (MIContainer.Amount) AS Amount_Currency
                               FROM tmpMovement
                                    LEFT JOIN MovementItemContainer AS MIContainer
                                                                    ON MIContainer.MovementId = tmpMovement.Id
                                                                   AND MIContainer.AccountId = zc_Enum_Account_100301()
                               GROUP BY MIContainer.MovementId
                               )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName


           , MovementItem.Amount             AS Amount
           , MIFloat_ParValue.ValueData      AS ParValue
           , COALESCE (tmpMIContainer.Amount_Currency, 0) :: TFloat AS Amount_Currency

           , MIString_Comment.ValueData      AS Comment

           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           
           , Object_CurrencyTo.ValueData     AS CurrencyToName

           , Object_PaidKind.ValueData       AS PaidKindName

       FROM tmpMovement AS Movement
           -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                             ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILinkObject_CurrencyTo.ObjectId
          
            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                         ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                        AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId
            
            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementId = Movement.Id
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Currency (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 06.10.16         * add inJuridicalBasisId
 10.11.14                                        * add ParValue
 28.07.14         *
*/

-- тест
--  SELECT * FROM gpSelect_Movement_Currency (inStartDate:= '01.01.2016', inEndDate:= '31.12.2016', inJuridicalBasisId:= 0, inIsErased:= false, inSession:= zfCalc_UserAdmin())
