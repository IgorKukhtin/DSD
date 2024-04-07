-- Function: gpSelect_Movement_LossDebt()

DROP FUNCTION IF EXISTS gpSelect_Movement_LossDebt (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_LossDebt (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_LossDebt(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inJuridicalBasisId Integer   , -- Главное юр.лицо
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalSumm TFloat
             , TotalSumm_100301 TFloat
             , JuridicalBasisName TVarChar
             , BusinessName TVarChar
             , AccountName TVarChar
             , PaidKindName TVarChar
             , isList Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_LossDebt());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- Результат
     RETURN QUERY 
     WITH tmpMovement AS (SELECT Movement.*
                          FROM Movement 
                          WHERE Movement.DescId = zc_Movement_LossDebt()
                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         )
        , tmpMIContainer AS (SELECT MIContainer.MovementId
                                  , SUM (MIContainer.Amount) AS Summ_100301
                             FROM MovementItemContainer AS MIContainer
                             WHERE MIContainer.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)
                               AND MIContainer.AccountId = zc_Enum_Account_100301()
                             GROUP BY MIContainer.MovementId
                             )
       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementFloat_TotalSumm.ValueData AS TotalSumm
           , COALESCE (tmpMIContainer.Summ_100301, 0) :: TFloat AS TotalSumm_100301
                      
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           , Object_Business.ValueData       AS BusinessName
           , View_Account.AccountName_all    AS AccountName
           , Object_PaidKind.ValueData       AS PaidKindName
           , COALESCE (MovementBoolean_List.ValueData, False) :: Boolean AS isList
       FROM tmpMovement AS Movement
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementBoolean AS MovementBoolean_List
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_JuridicalBasis
                                         ON MovementLinkObject_JuridicalBasis.MovementId = Movement.Id
                                        AND MovementLinkObject_JuridicalBasis.DescId = zc_MovementLinkObject_JuridicalBasis()
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = MovementLinkObject_JuridicalBasis.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Business
                                         ON MovementLinkObject_Business.MovementId = Movement.Id
                                        AND MovementLinkObject_Business.DescId = zc_MovementLinkObject_Business()
            LEFT JOIN Object AS Object_Business ON Object_Business.Id = MovementLinkObject_Business.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Account
                                         ON MovementLinkObject_Account.MovementId = Movement.Id
                                        AND MovementLinkObject_Account.DescId = zc_MovementLinkObject_Account()
            LEFT JOIN Object_Account_View AS View_Account ON View_Account.AccountId = MovementLinkObject_Account.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMIContainer ON tmpMIContainer.MovementId = Movement.Id
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_LossDebt (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 24.10.18         *
 06.10.16         * add inJuridicalBasisId
 18.04.16         *
 24.03.14                                        * add Object_Account_View
 06.03.14         * add Account
 14.01.14                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_LossDebt (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
