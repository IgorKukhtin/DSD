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

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


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
                               FROM MovementItemContainer AS MIContainer
                               WHERE MIContainer.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                                 AND MIContainer.AccountId = zc_Enum_Account_100301()
                               GROUP BY MIContainer.MovementId
                               )
          , tmpMI AS (SELECT MovementItem.*
                      FROM tmpMovement AS Movement
                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId = zc_MI_Master()
                      )

          , tmpMIFloat AS (SELECT MIFloat_ParValue.*
                            FROM MovementItemFloat AS MIFloat_ParValue
                            WHERE MIFloat_ParValue.MovementItemId IN ( SELECT tmpMI.Id FROM tmpMI)
                              AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
                            )
          , tmpMIString AS (SELECT MIString_Comment.*
                            FROM MovementItemString AS MIString_Comment 
                            WHERE MIString_Comment.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                              AND MIString_Comment.DescId = zc_MIString_Comment()
                            )
          , tmpMILinkObject AS (SELECT MovementItemLinkObject.*
                                FROM MovementItemLinkObject 
                                WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.Id FROM tmpMI)
                                  AND MovementItemLinkObject.DescId IN ( zc_MILinkObject_Currency(), zc_MILinkObject_PaidKind())
                                 )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName


           , MovementItem.Amount             AS Amount
           , MIFloat_ParValue.ValueData      AS ParValue
           , COALESCE (-1 * tmpMIContainer.Amount_Currency, 0) :: TFloat AS Amount_Currency

           , MIString_Comment.ValueData      AS Comment

           , Object_CurrencyFrom.ValueData   AS CurrencyFromName
           
           , Object_CurrencyTo.ValueData     AS CurrencyToName

           , Object_PaidKind.ValueData       AS PaidKindName

       FROM tmpMovement AS Movement
           -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
            
            LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId

            LEFT JOIN tmpMIFloat AS MIFloat_ParValue ON MIFloat_ParValue.MovementItemId = MovementItem.Id

            LEFT JOIN tmpMIString AS MIString_Comment ON MIString_Comment.MovementItemId = MovementItem.Id

            LEFT JOIN tmpMILinkObject AS MILinkObject_CurrencyTo
                                      ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                     AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
            LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILinkObject_CurrencyTo.ObjectId
          
            LEFT JOIN tmpMILinkObject AS MILinkObject_PaidKind
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
 10.10.18         *
 06.10.16         * add inJuridicalBasisId
 10.11.14                                        * add ParValue
 28.07.14         *
*/

-- тест
--  SELECT * FROM gpSelect_Movement_Currency (inStartDate:= '01.09.2018', inEndDate:= '30.09.2018', inJuridicalBasisId:= 0, inIsErased:= false, inSession:= zfCalc_UserAdmin())
