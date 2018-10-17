-- Function: gpSelect_Movement_TransportService()

DROP FUNCTION IF EXISTS gpSelect_Movement_TrasportService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, Boolean , TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_TransportService (TDateTime, TDateTime, Integer, Boolean , TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TransportService(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer , -- гл. юр.лицо
    IN inIsErased          Boolean ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MIId Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , StartRunPlan TDateTime, StartRun TDateTime
             , Amount TFloat, SummAdd TFloat, SummTotal TFloat, WeightTransport TFloat, Distance TFloat, Price TFloat, CountPoint TFloat, TrevelTime TFloat
             , ContractValue TFloat, ContractValueAdd TFloat
             , Comment TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , RouteId Integer, RouteName TVarChar
             , CarId Integer, CarName TVarChar
             , CarModelId Integer, CarModelName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , UnitForwardingId Integer, UnitForwardingName TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TransportService());
     vbUserId:= lpGetUserBySession (inSession);

     -- определяется - может ли пользовать видеть все документы
     IF zfCalc_AccessKey_TransportAll (vbUserId) = TRUE
     THEN vbAccessKeyId:= 0;
     ELSE vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportService());
     END IF;


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
           , MovementItem.Id as MIId
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRunPlan.ValueData) AS TDateTime) AS StartRunPlan
           , CAST (DATE_TRUNC ('MINUTE', MovementDate_StartRun.ValueData)     AS TDateTime) AS StartRun

           , MovementItem.Amount
           , MIFloat_SummAdd.ValueData             AS SummAdd
           , (MovementItem.Amount + COALESCE (MIFloat_SummAdd.ValueData, 0)) :: TFloat AS AmountSummTotal
           , MIFloat_WeightTransport.ValueData     AS WeightTransport
           , MIFloat_Distance.ValueData            AS Distance
           , MIFloat_Price.ValueData               AS Price
           , MIFloat_CountPoint.ValueData          AS CountPoint
           , MIFloat_TrevelTime.ValueData          AS TrevelTime
           , MIFloat_ContractValue.ValueData       AS ContractValue
           , MIFloat_ContractValueAdd.ValueData    AS ContractValueAdd

           , MIString_Comment.ValueData  AS Comment

           , View_Contract_InvNumber.ContractId
           , View_Contract_InvNumber.ContractCode   AS ContractCode
           , View_Contract_InvNumber.InvNumber      AS ContractName

           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
     
           , MovementItem.ObjectId       AS JuridicalId
           , Object_Juridical.ValueData  AS JuridicalName

           , Object_PaidKind.Id          AS PaidKindId
           , Object_PaidKind.ValueData   AS PaidKindName
           
           , Object_Route.Id             AS RouteId
           , Object_Route.ValueData      AS RouteName

           , Object_Car.Id               AS CarId
           , Object_Car.ValueData        AS CarName
           , Object_CarModel.Id          AS CarModelId
           , Object_CarModel.ValueData   AS CarModelName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_UnitForwarding.Id        AS UnitForwardingId
           , Object_UnitForwarding.ValueData AS UnitForwardingName

       FROM tmpStatus
            INNER JOIN Movement ON  Movement.DescId = zc_Movement_TransportService()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId
                               AND (Movement.AccessKeyId = vbAccessKeyId OR vbAccessKeyId = 0)
            -- JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId 
 
            LEFT JOIN MovementItemFloat AS MIFloat_WeightTransport
                                        ON MIFloat_WeightTransport.MovementItemId = MovementItem.Id
                                       AND MIFloat_WeightTransport.DescId = zc_MIFloat_WeightTransport()
                             
            LEFT JOIN MovementItemFloat AS MIFloat_Distance
                                        ON MIFloat_Distance.MovementItemId = MovementItem.Id
                                       AND MIFloat_Distance.DescId = zc_MIFloat_Distance()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            
            LEFT JOIN MovementItemFloat AS MIFloat_CountPoint
                                        ON MIFloat_CountPoint.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountPoint.DescId = zc_MIFloat_CountPoint()

            LEFT JOIN MovementItemFloat AS MIFloat_TrevelTime
                                        ON MIFloat_TrevelTime.MovementItemId = MovementItem.Id
                                       AND MIFloat_TrevelTime.DescId = zc_MIFloat_TrevelTime()
                                       
            LEFT JOIN MovementItemFloat AS MIFloat_SummAdd
                                        ON MIFloat_SummAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummAdd.DescId = zc_MIFloat_SummAdd()

            LEFT JOIN MovementItemFloat AS MIFloat_ContractValue
                                        ON MIFloat_ContractValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContractValue.DescId = zc_MIFloat_ContractValue()
            LEFT JOIN MovementItemFloat AS MIFloat_ContractValueAdd
                                        ON MIFloat_ContractValueAdd.MovementItemId = MovementItem.Id
                                       AND MIFloat_ContractValueAdd.DescId = zc_MIFloat_ContractValueAdd()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id 
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Route
                                             ON MILinkObject_Route.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Route.DescId = zc_MILinkObject_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MILinkObject_Route.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id 
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId
      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitForwarding
                                         ON MovementLinkObject_UnitForwarding.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitForwarding.DescId = zc_MovementLinkObject_UnitForwarding()
            LEFT JOIN Object AS Object_UnitForwarding ON Object_UnitForwarding.Id = MovementLinkObject_UnitForwarding.ObjectId

            LEFT JOIN MovementDate AS MovementDate_StartRunPlan
                                   ON MovementDate_StartRunPlan.MovementId = Movement.Id
                                  AND MovementDate_StartRunPlan.DescId = zc_MovementDate_StartRunPlan()
            LEFT JOIN MovementDate AS MovementDate_StartRun
                                   ON MovementDate_StartRun.MovementId = Movement.Id
                                  AND MovementDate_StartRun.DescId = zc_MovementDate_StartRun()
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д. 
 07.10.16         * add inJuridicalBasisId
 03.07.16         *
 16.12.15         * add WeightTransport
 22.09.15         * add inIsErased
 25.01.14                                        * add zc_MovementLinkObject_UnitForwarding
 14.01.14                                        * add Object_Contract_InvNumber_View
 07.01.14                                        * add InfoMoneyCode
 22.12.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TransportService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inJuridicalBasisId:= 0, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
